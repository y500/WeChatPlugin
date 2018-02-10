//
//     Generated by class-dump 3.5 (64 bit).
//
//     class-dump is Copyright (C) 1997-1998, 2000-2001, 2004-2013 by Steve Nygard.
//

#import "PBGeneratedMessage.h"

@class NSString;

__attribute__((visibility("hidden")))
@interface QQGroup : PBGeneratedMessage
{
    unsigned int hasGroupId:1;
    unsigned int hasGroupName:1;
    unsigned int hasMd5:1;
    unsigned int hasMemberNum:1;
    unsigned int hasWeixinNum:1;
    unsigned int groupId;
    unsigned int memberNum;
    unsigned int weixinNum;
    NSString *groupName;
    NSString *md5;
}

+ (id)parseFromData:(id)arg1;
@property(nonatomic, setter=SetWeixinNum:) unsigned int weixinNum; // @synthesize weixinNum;
@property(readonly, nonatomic) BOOL hasWeixinNum; // @synthesize hasWeixinNum;
@property(nonatomic, setter=SetMemberNum:) unsigned int memberNum; // @synthesize memberNum;
@property(readonly, nonatomic) BOOL hasMemberNum; // @synthesize hasMemberNum;
@property(retain, nonatomic, setter=SetMd5:) NSString *md5; // @synthesize md5;
@property(readonly, nonatomic) BOOL hasMd5; // @synthesize hasMd5;
@property(retain, nonatomic, setter=SetGroupName:) NSString *groupName; // @synthesize groupName;
@property(readonly, nonatomic) BOOL hasGroupName; // @synthesize hasGroupName;
@property(nonatomic, setter=SetGroupId:) unsigned int groupId; // @synthesize groupId;
@property(readonly, nonatomic) BOOL hasGroupId; // @synthesize hasGroupId;
- (void).cxx_destruct;
- (id)mergeFromCodedInputStream:(id)arg1;
- (int)serializedSize;
- (void)writeToCodedOutputStream:(id)arg1;
- (BOOL)isInitialized;
- (id)init;

@end
