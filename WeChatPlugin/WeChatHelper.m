//
//  WeChatHelper.m
//  WeChatPlugin
//
//  Created by wentian on 30/03/2018.
//  Copyright © 2018 natoto. All rights reserved.
//

#import "WeChatHelper.h"

@implementation WeChatHelper

+ (void)sendTextMessageToUsrName:(NSString *)toUserName msgText:(NSString *)msg atUserList:(NSArray *)userList {
    MessageService *service = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("MessageService")];
    NSString *currentUserName = [objc_getClass("CUtility") GetCurrentUserName];
    [service SendTextMessage:currentUserName toUsrName:toUserName msgText:msg atUserList:userList];
}

+ (void)sendTextMessageToUsrName:(NSString*)toUserName msgText:(NSString*)msg {
    [self sendTextMessageToUsrName:toUserName msgText:msg atUserList:nil];
}

+ (void)SendImgMessageToUsrName:(id)userName thumbImgData:(NSData*)thumb midImgData:(NSData*)midData imgData:(NSData*)imgData imgInfo:(id)info {
    MessageService *service = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("MessageService")];
    NSString *currentUserName = [objc_getClass("CUtility") GetCurrentUserName];

    [service SendImgMessage:currentUserName toUsrName:userName thumbImgData:thumb midImgData:midData imgData:imgData imgInfo:nil];
}

+ (void)sendImgMessageToUsrName:(id)userName imgUrl:(NSString*)imgUrl {
    MMAvatarService *avService = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("MMAvatarService")];
    
    [avService getAvatarImageWithUrl:imgUrl ?: @"http://p6.qhimg.com/t011254cf99a0443e58.jpg" completion:^(NSImage *image) {
        id thumb = [image thumbnailDataForMessage];
        
        NSData *imgdata = [image bestRepresentation];
        
        NSData *middata = imgdata;
        
        CGFloat factor = 0.8;
        while ([middata length] / 1000 > 800) {
            middata = [image JPEGRepresentationWithCompressionFactor:factor];
            factor *= 0.8;
        }
        
        [self SendImgMessageToUsrName:userName thumbImgData:[thumb data] midImgData:middata imgData:imgdata imgInfo:nil];
    }];
}

+ (NSArray*)groupList {
    MMSessionMgr *sessionMgr = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("MMSessionMgr")];
    NSArray *groupContact = [sessionMgr GetAllGroupSessionContact];
    return groupContact;
}

+ (NSArray*)contactsList {
    ContactStorage *contactStorage = [[objc_getClass("MMServiceCenter") defaultCenter] getService:objc_getClass("ContactStorage")];
    NSArray *members = [contactStorage GetAllFriendContacts];
    return members;
}

@end
