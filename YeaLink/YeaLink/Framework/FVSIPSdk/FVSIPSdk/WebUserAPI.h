//
//  WebUserAPI.h
//  FVSIPSdk
//
//  Created by  Tim Lei on 1/25/16.
//  Copyright © 2016 FreeView. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginResponse.h"

@interface WebUserAPI : NSObject

/**
 *  WebUserAPI 初始化方法
 *
 *  @param loginServerAddr 登录服务器地址 e.g: 192.168.100:9700
 *  @param serviceAddr 业务处理服务器地址  格式同登录服务器
 *  @param developerCode 开发者账号（UUID）
 *
 *  @return WebUserAPI 实例
 */
- (id)initWithLoginSeverAddress:(NSString*) loginServerAddr andServiceAddr:(NSString*) serviceAddr developerCode:(NSString*)developerCode;

/**
 *  根据用户名和密码信息，向服务器发送注册请求
 *
 *  @param username 账户名称
 *  @param password 账户密码
 *  @param mobileNumber 手机号码
 *  @param completionBlock 注册响应处理块
 */
- (void)registerWithName:(NSString*)username
            mobileNumber:(NSString*)mobileNumber
         completionBlock:(void(^)(NSError* error))completionBlock;

/**
 *  根据用户名和密码信息，向服务器发送登录请求
 *
 *  @param username 账户名称
 *  @param completionBlock 登录响应处理块
 */
- (void)loginWithName:(NSString*)username
      completionBlock:(void(^)(NSError* error, LoginResponse* response))completionBlock;

@end
