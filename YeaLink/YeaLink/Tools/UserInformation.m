//
//  UserInformation.m
//  YeaLink
//
//  Created by 李根 on 16/5/7.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "UserInformation.h"

@implementation UserInformation

+ (instancetype)userinforSingleton {
    static UserInformation *userSingelton;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userSingelton = [[UserInformation alloc] init];
    });
    
    return userSingelton;
}

@end
