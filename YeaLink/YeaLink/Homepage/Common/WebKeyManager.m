//
//  WebKeyManager.m
//  YeaLink
//
//  Created by 李根 on 16/4/27.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "WebKeyManager.h"
#import "WebKeyCaseAPI.h"
#import "KeyInfos.h"

@interface WebKeyManager ()
@property(nonatomic, copy)NSString *tenantCode;
@property(nonatomic, copy)NSString *username;
@property(nonatomic, strong)WebKeyCaseAPI *keyApi;

@end

@implementation WebKeyManager

+ (instancetype)sharedManager {
    static dispatch_once_t predicate = 0;
    __strong static id sharedObject = nil;
    
    dispatch_once(&predicate, ^{
        sharedObject = [[self alloc] init];
    });
    
    return sharedObject;
}

#pragma mark    - developerCode需要根据自己的来
- (void)getWebKeys:(NSString*)serverAddress
          username:(NSString*)username
        tenantCode:(NSString*)tenantCode
         tokenType:(NSString*)tokenType
       accessToken:(NSString*)accessToken
   completionBlock:(void(^)(NSError* error))completionBlock {
    
    _tenantCode = tenantCode;
    _username = username;
    [_keyInfos removeAllObjects];
    _keyApi = [[WebKeyCaseAPI alloc] initWithSeverAddress:serverAddress
                                                tokenType:tokenType
                                              accessToken:accessToken developerCode:@"A32F265D-6C46-469E-A1DC-74E5E67A523C"];
    
    [_keyApi getKeyCaseWithUsername:username andTenantCode:tenantCode completionBlock:^(NSError* error, NSArray* result){
        if (result) {
            _keyInfos = [result copy];
        }
        completionBlock(error);
    }];
}

- (void)unlockDoor:(NSInteger)index completionBlock:(void(^)(NSError* error))completionBlock {
    if (index < [_keyInfos count]) {
        KeyInfos* key = [_keyInfos objectAtIndex:index];
        [_keyApi unlockDoorWithTenantCode:_tenantCode
                          deviceDirectory:key.localDirectory
                              andUsername:_username
                          completionBlock:completionBlock];
    }
}


@end
