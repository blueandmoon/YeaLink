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
//  存储用户信息到本地
+ (void)saveInformationToLocalWithModel:(UserModel *)model;
//  保存用户信息
@property(nonatomic, strong)UserModel *usermodel;
//  传链接
@property(nonatomic, strong)NSString *strURL;
//  用户所选城市
@property(nonatomic, strong)NSString *cityID;
@property(nonatomic, strong)NSString *cityName;



@end
