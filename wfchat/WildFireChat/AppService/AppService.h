//
//  AppService.h
//  WildFireChat
//
//  Created by Heavyrain Lee on 2019/10/22.
//  Copyright © 2019 WildFireChat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WFChatUIKit/WFChatUIKit.h>
#import <WFChatClient/WFCChatClient.h>
#import "Device.h"

NS_ASSUME_NONNULL_BEGIN

@class PttChannelInfo;

@interface AppService : NSObject <WFCUAppServiceProvider>
+ (AppService *)sharedAppService;

- (void)login:(NSString *)user password:(NSString *)password success:(void(^)(NSString *userId, NSString *token, NSString *mobile, BOOL newUser))successBlock error:(void(^)(int errCode, NSString *message))errorBlock;

- (void)sendCode:(NSString *)phoneNumber success:(void(^)(void))successBlock error:(void(^)(NSString *message))errorBlock;

- (void)pcScaned:(NSString *)sessionId success:(void(^)(void))successBlock error:(void(^)(int errorCode, NSString *message))errorBlock;

- (void)pcConfirmLogin:(NSString *)sessionId success:(void(^)(void))successBlock error:(void(^)(int errorCode, NSString *message))errorBlock;

- (void)pcCancelLogin:(NSString *)sessionId success:(void(^)(void))successBlock error:(void(^)(int errorCode, NSString *message))errorBlock;

- (void)uploadLogs:(void(^)(void))successBlock error:(void(^)(NSString *errorMsg))errorBlock;

- (void)showPCSessionViewController:(UIViewController *)baseController pcClient:(WFCCPCOnlineInfo *)clientInfo;

- (void)addDevice:(NSString *)name
         deviceId:(NSString *)deviceId
            owner:(NSArray<NSString *> *)owners
          success:(void(^)(Device *device))successBlock
            error:(void(^)(int error_code))errorBlock;

- (void)getMyDevices:(void(^)(NSArray<Device *> *devices))successBlock
               error:(void(^)(int error_code))errorBlock;

- (void)delDevice:(NSString *)deviceId
          success:(void(^)(Device *device))successBlock
            error:(void(^)(int error_code))errorBlock;

- (void)createPttChannel:(PttChannelInfo *)channelInfo success:(void(^)(NSString *channelId))successBlock error:(void(^)(int errorCode, NSString *message))errorBlock;

- (void)destroyPttChannel:(NSString *)channelId success:(void(^)(void))successBlock error:(void(^)(int errorCode, NSString *message))errorBlock;

- (NSData *)getAppServiceCookies;
- (NSString *)getAppServiceAuthToken;

//清除应用服务认证cookies和认证token
- (void)clearAppServiceAuthInfos;

//注册
- (void)regist:(NSString *)user password:(NSString *)password success:(void(^)(NSString *userId, NSString *token, NSString *mobile, BOOL newUser))successBlock error:(void(^)(int errCode, NSString *message))errorBlock;

//绑定/修改手机号接口
- (void)changeMobile:(NSString *)mobile success:(void(^)(NSString *userId, NSString *token, NSString *mobile, BOOL newUser))successBlock error:(void(^)(int errCode, NSString *message))errorBlock;

//修改密码
- (void)changePassword:(NSString *)oldPassword newPwd:(NSString *)newPassword success:(void(^)(NSString *userId, NSString *token, NSString *mobile, BOOL newUser))successBlock error:(void(^)(int errCode, NSString *message))errorBlock;
@end

NS_ASSUME_NONNULL_END
