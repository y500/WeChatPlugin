//
//  ToolKit.h
//  WeChatPlugin
//
//  Created by wentian on 16/03/2018.
//  Copyright © 2018 natoto. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToolKit : NSObject

+ (id)dicGetObject:(NSDictionary*)dic key:(id)key class:(Class)class;
+ (NSString*)dicGetString:(NSDictionary*)dic key:(id)key;
+ (int)dicGetInt:(NSDictionary*)dic key:(id)key default:(int)intDefault;

@end


@interface NSString (URLEncode)
- (NSString *)urlEncode;
- (NSString *)URLDecode;
@end
