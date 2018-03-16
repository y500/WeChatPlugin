//
//  ToolKit.m
//  WeChatPlugin
//
//  Created by wentian on 16/03/2018.
//  Copyright © 2018 natoto. All rights reserved.
//

#import "ToolKit.h"

@implementation ToolKit

+ (id)dicGetObject:(NSDictionary*)dic key:(id)key class:(Class)class {
    
    if (dic == nil || ![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    id result = [dic objectForKey:key];
    if (result && [result isKindOfClass:class]) {
        return result;
    }
    return nil;
}

+ (NSString*)dicGetString:(NSDictionary*)dic key:(id)key {
    if (dic == nil || ![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    id result = [dic objectForKey:key];
    if (result && [result isKindOfClass:[NSNumber class]]) {
        return [NSString stringWithFormat:@"%@",result];
    } else if (result && [result isKindOfClass:[NSString class]]) {
        return (NSString *)result;
    }
    return nil;
}

+ (int)dicGetInt:(NSDictionary*)dic key:(id)key default:(int)intDefault {
    if (dic == nil || ![dic isKindOfClass:[NSDictionary class]]) {
        return intDefault;
    }
    
    id result = [dic objectForKey:key];
    if (result && [result isKindOfClass:[NSNumber class]]) {
        return [(NSNumber *)result floatValue];
    }
    else if (result && [result isKindOfClass:[NSString class]]) {
        return [(NSString *)result floatValue];
    }
    return intDefault;
}

@end

@implementation NSString (URLEncode)

- (NSString *)urlEncode {
    NSString * encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)self, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
    return encodedString;
}

- (NSString *)URLDecode {
    NSString *result = [(NSString *)self stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    result = [result stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return result;
}


@end

