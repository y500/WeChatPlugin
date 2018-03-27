//
//  WeChatPlugin.m
//  WeChatPlugin
//
//  Created by nato on 2017/1/22.
//  Copyright (c) 2017年 github:natoto. All rights reserved.
//

#import "WeChatPlugin.h"
#import "WeChatPluginHeader.h"
#import "MMTimeLineMainViewController.h"
#import "MMTimeLineViewController.h"
#import "WeChat+hook.h"
#import "MMChatsTableCellView+hook.h"
#import "GCDWebServer.h"
#import "GCDWebServerDataResponse.h"
#import "GCDWebServerURLEncodedFormRequest.h"

#pragma mark - Plugin

@implementation NSBundle (WeChatPlugin)

+ (instancetype)pluginBundle {
    return [NSBundle bundleWithIdentifier:@"com.corbin.WeChatPlugin"];
}

@end

@implementation NSObject (WeChatPlugin)

#pragma mark - MMLogger

+ (void)cb_logWithMMLogLevel:(int)arg1 module:(const char *)arg2 file:(const char *)arg3 line:(int)arg4 func:(const char *)arg5 message:(id)arg6 {
    NSLog(@"[%s] %s %s %@", arg2, arg3, arg5, arg6);
}

#pragma mark - MMCGIConfig

- (const struct MMCGIItem *)cb_findItemWithFuncInternal:(int)arg1 {
    struct MMCGIItem *res = (struct MMCGIItem *)[self cb_findItemWithFuncInternal:arg1];
    if (arg1 == kMMCGIWrapTimeLineFunctionId) {
        res = malloc(sizeof(struct MMCGIItem));
        res->_field1 = kMMCGIWrapTimeLineFunctionId;
        res->_field2 = 0;
        res->_field3 = 0;
        res->_field4 = "mmsnstimeline";
        res->_field5 = CBGetClass(SnsTimeLineResponse);
        res->_field6 = 1;
        res->_field7 = 2;
        res->_field8 = 0;
    }
    else if (arg1 == kMMCGIWrapHomePageFunctionId) {
        res = malloc(sizeof(struct MMCGIItem));
        res->_field1 = kMMCGIWrapHomePageFunctionId;
        res->_field2 = 0;
        res->_field3 = 0;
        res->_field4 = "mmsnsuserpage";
        res->_field5 = CBGetClass(SnsUserPageResponse);
        res->_field6 = 1;
        res->_field7 = 2;
        res->_field8 = 0;
    }
    return res;
}

#pragma mark - AppDelegate

- (void)cb_applicationDidFinishLaunching:(id)arg {
    [self cb_applicationDidFinishLaunching:arg];
    if ([WeChatService(AccountService) canAutoAuth]) {
        [WeChatService(AccountService) AutoAuth];
    }
}

- (NSApplicationTerminateReply)cb_applicationShouldTerminate:(NSApplication *)sender {
    return NSTerminateNow;
}

@end

@implementation NSView (WeChatPlugin)

@end

@implementation NSViewController (WeChatPlugin)

#pragma mark - LeftViewController

- (void)cb_setViewControllers:(NSArray *)vcs {
    
    MMTimeLineMainViewController *timeLineMainVC = [[CBGetClass(MMTimeLineMainViewController) alloc] initWithNibName:@"MMContactsViewController" bundle:[NSBundle mainBundle]];
    [timeLineMainVC setTitle:[[NSBundle mainBundle] localizedStringForKey:@"Tabbar.Chats" value:@"" table:0x0]];
    
    
    MMTimeLineViewController *timeLineVC = [[CBGetClass(MMTimeLineViewController) alloc] initWithNibName:@"MMTimeLineViewController" bundle:[NSBundle pluginBundle]]; //[[CBGetClass(MMTimeLineViewController) alloc] initWithNibName:@"MMTimeLineViewController" bundle:[NSBundle pluginBundle]];
    timeLineMainVC.detailViewController = (id)timeLineVC;
    
    MMTabbarItem *tabBarItem = [[CBGetClass(MMTabbarItem) alloc] initWithTitle:@"朋友圈" onStateImage:[[NSBundle pluginBundle] imageForResource:@"Tabbar-TimeLine-Selected"] onStateAlternateImage:[[NSBundle pluginBundle] imageForResource:@"Tabbar-TimeLine-Selected-HI"] offStateImage:[[NSBundle pluginBundle] imageForResource:@"Tabbar-TimeLine"] offStateAlternateImage:[[NSBundle pluginBundle] imageForResource:@"Tabbar-TimeLine-HI"]];
    [timeLineMainVC setTabbarItem:tabBarItem];
    
    NSMutableArray *viewControllers = [vcs mutableCopy];
    [viewControllers addObject:timeLineMainVC];
    [self cb_setViewControllers:[viewControllers copy]];

    __weak typeof(self) weakSelf = self;
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:10 repeats:true block:^(NSTimer * _Nonnull timer) {
        [weakSelf autoSendRequest];
    }];
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    
    
    GCDWebServer *server = [[GCDWebServer alloc] init];
    
    [server addHandlerForMethod:@"GET"
                              pathRegex:@"/.*"
                      requestClass:[GCDWebServerRequest class]
                      processBlock:^GCDWebServerResponse *(GCDWebServerRequest* request) {
                          return [weakSelf responseWithRequest:request];
                      }];
    
    [server addHandlerForMethod:@"POST"
                              pathRegex:@"/.*"
                      requestClass:[GCDWebServerURLEncodedFormRequest class]
                      processBlock:^GCDWebServerResponse *(GCDWebServerRequest* request) {
                          
                          return [weakSelf responseWithRequest:request];
                          
                      }];
    
    
    [server startWithPort:9000 bonjourName:@""];
    objc_setAssociatedObject(self, @"gcdwebserver", server, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (GCDWebServerDataResponse*)responseWithRequest:(GCDWebServerRequest *)request {
    MessageService *service = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("MessageService")];
    NSString *currentUserName = [objc_getClass("CUtility") GetCurrentUserName];
    
    if ([request.URL.path isEqualToString:@"/sendText"]) {
        NSString *content = request.query[@"text"];
        NSString *userName = request.query[@"user"];
        
        if ([request.method isEqualToString:@"POST"]) {
            content = [[(GCDWebServerURLEncodedFormRequest*)request arguments] objectForKey:@"text"];
            userName = [[(GCDWebServerURLEncodedFormRequest*)request arguments] objectForKey:@"user"];
        }
        
        if (content.length == 0 || userName.length == 0) {
            return [GCDWebServerDataResponse responseWithHTML:@"<html><body><p>wrong parameter</p></body></html>"];
        }
        
        [service SendTextMessage:currentUserName toUsrName:userName msgText:content atUserList:nil];
        return [GCDWebServerDataResponse responseWithJSONObject:@{@"code":@200, @"info":@"sent"}];
    }
    else if ([request.URL.path isEqualToString:@"/sendImg"]) {
        NSString *url = request.query[@"url"];
        NSString *userName = request.query[@"user"];
        
        if ([request.method isEqualToString:@"POST"]) {
            url = [[(GCDWebServerURLEncodedFormRequest*)request arguments] objectForKey:@"url"];
            userName = [[(GCDWebServerURLEncodedFormRequest*)request arguments] objectForKey:@"user"];
        }
        
        if (url.length == 0 || userName.length == 0) {
            return [GCDWebServerDataResponse responseWithHTML:@"<html><body><p>wrong parameter</p></body></html>"];
        }
        
        MMAvatarService *avService = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("MMAvatarService")];
        
        [avService getAvatarImageWithUrl:url ?: @"http://p6.qhimg.com/t011254cf99a0443e58.jpg" completion:^(NSImage *image) {
            id thumb = [image thumbnailDataForMessage];
            
            NSData *imgdata = [image bestRepresentation];
            
            NSData *middata = imgdata;
            
            CGFloat factor = 0.8;
            while ([middata length] / 1000 > 800) {
                middata = [image JPEGRepresentationWithCompressionFactor:factor];
                factor *= 0.8;
            }
            
            [service SendImgMessage:currentUserName toUsrName:userName thumbImgData:[thumb data] midImgData:middata imgData:imgdata imgInfo:nil];
        }];
        return [GCDWebServerDataResponse responseWithJSONObject:@{@"code":@200, @"info":@"sent"}];
    }
    else if ([request.URL.path isEqualToString:@"/groupList"]) {
        MMSessionMgr *sessionMgr = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("MMSessionMgr")];
        NSArray *groupContact = [sessionMgr GetAllGroupSessionContact];
        
        NSMutableArray *chatRooms = [NSMutableArray arrayWithCapacity:1];
        
        for (WCContactData *contact in groupContact) {
            if ([contact.m_nsUsrName hasSuffix:@"chatroom"]) {
                NSMutableDictionary *room = [NSMutableDictionary dictionaryWithCapacity:1];
                [room setObject:contact.m_nsUsrName?:@"" forKey:@"user"];
                [room setObject:contact.m_nsNickName?:@"" forKey:@"name"];
                [room setObject:contact.m_nsHeadImgUrl?:@"" forKey:@"avatar"];
                [chatRooms addObject:room];
            }
        }
        
        return [GCDWebServerDataResponse responseWithJSONObject:@{@"code":@200,@"data":chatRooms?:@[],@"info":@"success"}];
    }
    else if ([request.path isEqualToString:@"/contactList"]) {
        ContactStorage *contactStorage = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("ContactStorage")];
        NSArray *members = [contactStorage GetAllFriendContacts];
        
        NSMutableArray *contacts = [NSMutableArray arrayWithCapacity:1];
        
        for (WCContactData *contact in members) {
            if (contact.m_uiWCFlag) {
                NSMutableDictionary *room = [NSMutableDictionary dictionaryWithCapacity:1];
                [room setObject:contact.m_nsUsrName?:@"" forKey:@"user"];
                [room setObject:contact.m_nsNickName?:@"" forKey:@"name"];
                [room setObject:contact.m_nsHeadImgUrl?:@"" forKey:@"avatar"];
                [contacts addObject:room];
            }
        }
        
        return [GCDWebServerDataResponse responseWithJSONObject:@{@"code":@200,@"data":contacts?:@[],@"info":@"success"}];
    }
    else if ([request.path isEqualToString:@"/sendTextToMultiUser"]) {
        NSString *content = request.query[@"text"];
        NSString *userNames = request.query[@"users"];
        
        if ([request.method isEqualToString:@"POST"]) {
            content = [[(GCDWebServerURLEncodedFormRequest*)request arguments] objectForKey:@"text"];
            userNames = [[(GCDWebServerURLEncodedFormRequest*)request arguments] objectForKey:@"users"];
        }
        
        NSArray *users = [userNames componentsSeparatedByString:@","];
        
        if (content.length == 0 || users.count == 0) {
            return [GCDWebServerDataResponse responseWithHTML:@"<html><body><p>wrong parameter</p></body></html>"];
        }
        
        for (NSString *user in users) {
            [service SendTextMessage:currentUserName toUsrName:user msgText:content atUserList:nil];
            
            //安全策略
            double val = ((double)arc4random() / 0x100000000);
            sleep(val + 1);
            NSLog(@"xxx:%@", [NSDate date]);
        }
        
        return [GCDWebServerDataResponse responseWithJSONObject:@{@"code":@200, @"info":@"sent"}];
    }
    else if ([request.path isEqualToString:@"/sendImgToMultiUser"]) {
        NSString *url = request.query[@"url"];
        NSString *userNames = request.query[@"users"];
        
        if ([request.method isEqualToString:@"POST"]) {
            url = [[(GCDWebServerURLEncodedFormRequest*)request arguments] objectForKey:@"url"];
            userNames = [[(GCDWebServerURLEncodedFormRequest*)request arguments] objectForKey:@"users"];
        }
        
        NSArray *users = [userNames componentsSeparatedByString:@","];
        
        if (url.length == 0 || users.count == 0) {
            return [GCDWebServerDataResponse responseWithHTML:@"<html><body><p>wrong parameter</p></body></html>"];
        }
        
        MMAvatarService *avService = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("MMAvatarService")];
        
        [avService getAvatarImageWithUrl:url ?: @"http://p6.qhimg.com/t011254cf99a0443e58.jpg" completion:^(NSImage *image) {
            id thumb = [image thumbnailDataForMessage];
            
            NSData *imgdata = [image bestRepresentation];
            
            NSData *middata = imgdata;
            
            CGFloat factor = 0.8;
            while ([middata length] / 1000 > 800) {
                middata = [image JPEGRepresentationWithCompressionFactor:factor];
                factor *= 0.8;
            }
            
            for (NSString *user in users) {
                [service SendImgMessage:currentUserName toUsrName:user thumbImgData:[thumb data] midImgData:middata imgData:imgdata imgInfo:nil];
               
                //安全策略
                double val = ((double)arc4random() / 0x100000000);
                sleep(val + 1);
                NSLog(@"xxx:%@", [NSDate date]);
            }
            
        }];
        return [GCDWebServerDataResponse responseWithJSONObject:@{@"code":@200, @"info":@"sent"}];
    }
    else {
        return [GCDWebServerDataResponse responseWithHTML:@"<html><body><p>Hi, man!</p></body></html>"];
    }
}

-(void)cb_mmDidLoad{
    NSLog(@"\n----\n ❤️ %@ didLoad \n----\n",NSStringFromClass([self class]));
}
-(void)cb_preViewDidLoad{

    [self cb_preViewDidLoad];
}

-(void)cb_preshow{
    [self cb_preshow];
}

//请求接口，然后自动回复
- (void)autoSendRequest {
    return;
    NSInteger rand = random() % 5;
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://192.168.0.105/wechat.php?key=%@", @(rand)]]];
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        MessageService *service = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("MessageService")];
        NSString *currentUserName = [objc_getClass("CUtility") GetCurrentUserName];
//        if ([self dicGetInt:result key:@"code" default:0] == 0) {
//
//            [service SendTextMessage:currentUserName toUsrName:@"4604041976@chatroom" msgText:[self dicGetString:result key:@"data"] atUserList:nil];
//        }
//        NSImage *image = [[NSBundle pluginBundle] imageForResource:@"Tabbar-TimeLine-Selected"];
//        id thumb = [image thumbnailDataForMessage];
//        NSData *imgdata = [image bestRepresentation];
//        [service SendImgMessage:currentUserName toUsrName:@"nyatou" thumbImgData:[thumb data] midImgData:imgdata imgData:imgdata imgInfo:nil];
        
        MMAvatarService *avService = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("MMAvatarService")];

        [avService getAvatarImageWithUrl:@"http://p6.qhimg.com/t011254cf99a0443e58.jpg" completion:^(NSImage *image) {
            id thumb = [image thumbnailDataForMessage];
            
            NSData *imgdata = [image bestRepresentation];
            
            CGFloat factor = 0.8;
            while ([imgdata length] / 1000 > 800) {
                imgdata = [image JPEGRepresentationWithCompressionFactor:factor];
                factor *= 0.8;
            }
            
            [service SendImgMessage:currentUserName toUsrName:@"nyatou" thumbImgData:[thumb data] midImgData:imgdata imgData:imgdata imgInfo:nil];
        }];
        
    }];
    [task resume];
}

@end

static void __attribute__((constructor)) initialize(void) {
    NSLog(@"++++++++ WeChatPlugin loaded ++++++++");
    NSLog(@"++++++++ WeChatPlugin loaded ++++++++");
    [NSObject hookWeChat];
    [NSObject hookMMChatsTableCellView];
    
    CBRegisterClass(MMContactsViewController, MMTimeLineMainViewController);
    
    CBHookClassMethod(MMLogger, @selector(logWithMMLogLevel:module:file:line:func:message:), @selector(cb_logWithMMLogLevel:module:file:line:func:message:));
    
    CBHookInstanceMethod(MMCGIConfig, @selector(findItemWithFuncInternal:), @selector(cb_findItemWithFuncInternal:));
    
    CBHookInstanceMethod(AppDelegate, @selector(applicationDidFinishLaunching:), @selector(cb_applicationDidFinishLaunching:));
    CBHookInstanceMethod(AppDelegate, @selector(applicationShouldTerminate:), @selector(cb_applicationShouldTerminate:));
    
    CBHookInstanceMethod(LeftViewController, @selector(setViewControllers:), @selector(cb_setViewControllers:));
    
    
    CBHookInstanceMethod(MMViewController, @selector(viewDidLoad), @selector(cb_mmDidLoad));
    
    CBHookInstanceMethod(MMPreviewViewController, @selector(viewDidLoad), @selector(cb_preViewDidLoad));
    CBHookInstanceMethod(MMPreviewPanel, @selector(show), @selector(cb_preshow));
    
    
}

