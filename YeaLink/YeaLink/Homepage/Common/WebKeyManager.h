//
//  WebKeyManager.h
//  YeaLink
//
//  Created by 李根 on 16/4/27.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebKeyManager : NSObject
@property(nonatomic, strong)NSMutableArray *keyInfos;

+ (instancetype)sharedManager;

- (void)getWebKeys:(NSString *)serverAddress
          username:(NSString *)username
        tenantCode:(NSString *)tenantCode
         tokenType:(NSString *)tokenType
       accessToken:(NSString *)accessToken
   completionBlock:(void (^)(NSError *error))completionBlock;

- (void)unlockDoor:(NSInteger)index completionBlock:(void(^)(NSError *error))completionBlock;

@end
