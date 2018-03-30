//
//  WeChatHelper.h
//  WeChatPlugin
//
//  Created by wentian on 30/03/2018.
//  Copyright © 2018 natoto. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeChatHelper : NSObject

+ (void)sendTextMessageToUsrName:(NSString*)toUserName msgText:(NSString*)msg atUserList:(NSArray*)userList;
+ (void)sendTextMessageToUsrName:(NSString*)toUserName msgText:(NSString*)msg;

+ (void)SendImgMessageToUsrName:(id)userName thumbImgData:(NSData*)thumb midImgData:(NSData*)midData imgData:(NSData*)imgData imgInfo:(id)info;
+ (void)sendImgMessageToUsrName:(id)userName imgUrl:(NSString*)imgUrl;

+ (NSArray*)groupList;
+ (NSArray*)contactsList;

@end
