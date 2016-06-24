//
//  UserInformation.h
//  YeaLink
//
//  Created by 李根 on 16/5/7.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
#import "OwnerModel.h"

@interface UserInformation : NSObject
@property(nonatomic, strong)void(^doSomething)();   //  在获取用户信息后, 做些其他操作
//  获取用户信息
+ (instancetype)userinforSingleton;
//  存储用户信息到本地
+ (void)saveInformationToLocalWithModel:(UserModel *)model;
//  保存用户名密码在本地
+ (void)saveUserName:(NSString *)userName Password:(NSString *)password;
//  获取用户信息
+ (void)questUserInformationWith:(NSString *)userID;

//  获取8位随机密码, 业主默认小区信息
+ (NSArray *)getEightPassword;
//  保存用户信息
@property(nonatomic, strong)UserModel *usermodel;
//  传链接
@property(nonatomic, strong)NSString *strURL;
//  存储用户所选城市
@property(nonatomic, strong)NSString *cityID;
@property(nonatomic, strong)NSString *cityName;
//  键盘
@property(nonatomic, assign)CGRect keyboardRect;
//  判断当前处于发现页
@property(nonatomic, assign)BOOL isFind;
//  用户经纬度
@property(nonatomic, assign)float latitude;
@property(nonatomic, assign)float longitude;
//  定位的当前城市
@property(nonatomic, strong)NSString *currentCity;

@property(nonatomic, assign)NSInteger callStatus;   //  当前呼入状态

//  业主用户默认小区
@property(nonatomic, strong)OwnerModel *ownerModel;
//  将业主信息写入本地
+ (void)saveOwnerInforToLocalWithModel:(OwnerModel *)model;

@end
