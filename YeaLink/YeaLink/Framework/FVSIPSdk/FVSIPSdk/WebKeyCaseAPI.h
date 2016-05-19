//
//  WebKeyCaseAPI.h
//  FVSIPSdk
//
//  Created by  Tim Lei on 1/28/16.
//  Copyright © 2016 FreeView. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebKeyCaseAPI : NSObject

/**
 *  WebUserAPI 初始化方法
 *
 *  @param serverAddr 服务器地址 e.g: 192.168.100:9700
 *  @param tokenType 登录获取到的token类型
 *  @param accessToken 登录获取到的token
 *
 *  @return WebUserAPI 实例
 */
- (id)initWithSeverAddress:(NSString*) serverAddr
                 tokenType:(NSString*) tokenType
               accessToken:(NSString*) accessToken
             developerCode:(NSString*) developerCode;

/**
 *  根据用户名和租户编码，向服务器请求钥匙包信息
 *
 *  @param username        账户名称
 *  @param tenantCode      租户编码
 *  @param completionBlock 返回获取结果, error 为空表示成功 否则失败
 */
- (void)getKeyCaseWithUsername:(NSString*) username
                  andTenantCode:(NSString*) tenantCode
              completionBlock:(void(^)(NSError* error, NSArray* keyInfos))completionBlock;

/**
 *  根据钥匙索引和用户名，执行远程开锁请求
 *
 *  @param tenantCode      租户编码
 *  @param deviceDirectory 设备位置编码（同LocalDirectory）
 *  @param username        用户名
 *  @param completionBlock 返回获取结果, error 为空表示成功 否则失败
 */
- (void)unlockDoorWithTenantCode:(NSString*) tenantCode
                 deviceDirectory:(NSString*) deviceDirectory
                     andUsername:(NSString*) username
               completionBlock:(void(^)(NSError* error))completionBlock;
@end
