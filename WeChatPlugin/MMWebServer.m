//
//  WeWebServer.m
//  WeChatPlugin
//
//  Created by wentian on 30/03/2018.
//  Copyright © 2018 natoto. All rights reserved.
//

#import "MMWebServer.h"
#import "WeChatPlugin.h"
#import "WeChatHelper.h"

@implementation MMWebServer

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupAdvanceRouters];
    }
    return self;
}

- (void)setupAdvanceRouters {
    __weak typeof(self) weakSelf = self;
    [self addHandlerForMethod:@"GET"
                      pathRegex:@"/.*"
                   requestClass:[GCDWebServerRequest class]
                   processBlock:^GCDWebServerResponse *(GCDWebServerRequest* request) {
                       return [weakSelf responseWithRequest:request];
                   }];
    
    [self addHandlerForMethod:@"POST"
                      pathRegex:@"/.*"
                   requestClass:[GCDWebServerURLEncodedFormRequest class]
                   processBlock:^GCDWebServerResponse *(GCDWebServerRequest* request) {
                       
                       return [weakSelf responseWithRequest:request];
                       
                   }];
}

- (GCDWebServerDataResponse*)responseWithRequest:(GCDWebServerRequest *)request {

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
        
        [WeChatHelper sendTextMessageToUsrName:userName msgText:content];
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
        
        [WeChatHelper sendImgMessageToUsrName:userName imgUrl:url];
        return [GCDWebServerDataResponse responseWithJSONObject:@{@"code":@200, @"info":@"sent"}];
    }
    else if ([request.URL.path isEqualToString:@"/groupList"]) {
        NSArray *groupContact = [WeChatHelper groupList];
        
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
        NSArray *members = [WeChatHelper contactsList];
        
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
            [WeChatHelper sendTextMessageToUsrName:user msgText:content];
            
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
        
        for (NSString *user in users) {
            [WeChatHelper sendImgMessageToUsrName:user imgUrl:url];
            
            //安全策略
            double val = ((double)arc4random() / 0x100000000);
            sleep(val + 1);
            NSLog(@"xxx:%@", [NSDate date]);
        }
        return [GCDWebServerDataResponse responseWithJSONObject:@{@"code":@200, @"info":@"sent"}];
    }
    else if ([request.path isEqualToString:@"/enableMagicGroup"]) {
        NSString *chatRoomID = request.query[@"room"];
        
        if ([request.method isEqualToString:@"POST"]) {
            chatRoomID = [[(GCDWebServerURLEncodedFormRequest*)request arguments] objectForKey:@"room"];
        }
        if (chatRoomID.length > 0) {
            [[NSUserDefaults standardUserDefaults] setObject:chatRoomID forKey:kAllowTulingReplayGroupIDKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            return [GCDWebServerDataResponse responseWithJSONObject:@{@"code":@200, @"info":@"success"}];
        }else {
            return [GCDWebServerDataResponse responseWithJSONObject:@{@"code":@400, @"info":@"wrong parameter"}];
        }
        
    }
    else if ([request.path isEqualToString:@"/disableMagicGroup"]) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:kAllowTulingReplayGroupIDKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return [GCDWebServerDataResponse responseWithJSONObject:@{@"code":@200, @"info":@"success"}];
    }
    else {
        return [GCDWebServerDataResponse responseWithHTML:@"<html><body><p>Hi, man!</p></body></html>"];
    }
}

@end
