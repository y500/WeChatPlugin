//
//  TKWeChatPluginConfig.h
//  WeChatPlugin
//
//  Created by nato on 2017/1/11.
//  Copyright © 2017年 github:natototo. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface TKWeChatPluginConfig : NSObject

@property (nonatomic, assign) BOOL preventRevokeEnable;                 /**<    是否开启防撤回    */
@property (nonatomic, assign) BOOL autoAuthEnable;                      /**<    是否免认证登录    */
@property (nonatomic, assign) BOOL onTop;                               /**<    是否要置顶微信    */
@property (nonatomic, assign) BOOL multipleSelectionEnable;             /**<    是否要进行多选    */
@property (nonatomic, copy) NSMutableArray *autoReplyModels;            /**<    自动回复的数组    */
@property (nonatomic, copy) NSMutableArray *remoteControlModels;        /**<    远程控制的数组    */
@property (nonatomic, copy) NSMutableArray *ignoreSessionModels;        /**<    聊天置底的数组    */
@property (nonatomic, copy) NSMutableArray *selectSessions;             /**<    已经选中的会话    */

@property (nonatomic, assign) BOOL enableTulingSingle;
@property (nonatomic, assign) BOOL enabelTulingGroup;

@property (nonatomic, assign) BOOL enabelInviteToGroup;
@property (nonatomic, copy) NSString *inviteGroupID;

- (void)saveAutoReplyModels;
- (void)saveRemoteControlModels;
- (void)saveIgnoreSessionModels;

+ (instancetype)sharedConfig;

@end
