//
//  UserInformation.h
//  YeaLink
//
//  Created by 李根 on 16/5/7.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

@interface UserInformation : NSObject
//  获取用户信息
+ (instancetype)userinforSingleton;

@property(nonatomic, strong)UserModel *usermodel;

@property(nonatomic, strong)NSString *strURL;

@end
