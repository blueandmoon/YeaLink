//
//  GetUserInformation.m
//  YeaLink
//
//  Created by 李根 on 16/5/31.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "GetUserInformation.h"

@implementation GetUserInformation

+ (void)getUserInfroWithUserName:(NSString *)UserName {
    //  接收用户信息
    //  http://qianjiale.doggadatachina.com/api/APIUserManage/ShowUserInfo?UserID=18112572968
    NSString *strURL = [NSString stringWithFormat:@"%@api/APIUserManage/ShowUserInfo?UserID=%@", COMMONURL, UserName];
    NSLog(@"strURL: %@",strURL);
    [NetWorkingTool getNetWorking:strURL block:^(id result) {
        UserInformation *userInfor = [UserInformation userinforSingleton];
        NSArray *arr = [UserModel baseModelByArray:result[@"list"]];
        userInfor.usermodel = arr[0];
        //  存储用户信息到本地
        [UserInformation saveInformationToLocalWithModel:userInfor.usermodel];
        NSLog(@"获取用户信息成功");
        
        }];
}

@end
