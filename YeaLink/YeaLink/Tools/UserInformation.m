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

+ (void)saveUserName:(NSString *)userName Password:(NSString *)password {
    NSUserDefaults *userdefau = [NSUserDefaults standardUserDefaults];
    [userdefau setObject:userName forKey:@"UserName"];
    [userdefau setObject:[MyMD5 md5:password] forKey:@"Password"];
    [userdefau synchronize];
}

+ (void)saveInformationToLocalWithModel:(UserModel *)model {
    NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
    [userdef setObject:model.APPUserRole forKey:@"APPUserRole"];
    [userdef setValue:model.UserID forKey:@"UserID"];
    [userdef synchronize];
}

+ (void)questUserInformationWith:(NSString *)userID {
    //  接收用户信息
    //  http://qianjiale.doggadatachina.com/api/APIUserManage/ShowUserInfo?UserID=18112572968
    NSString *strURL = [NSString stringWithFormat:@"%@api/APIUserManage/ShowUserInfo?UserID=%@", COMMONURL, userID];
    NSLog(@"strURL: %@",strURL);
    [NetWorkingTool getNetWorking:strURL block:^(id result) {
        UserInformation *userInfor = [UserInformation userinforSingleton];
        NSArray *arr = [UserModel baseModelByArray:result[@"list"]];
        userInfor.usermodel = arr[0];
        //  存储用户信息到本地
        [UserInformation saveInformationToLocalWithModel:userInfor.usermodel];
        NSLog(@"userInfor.usermodel.UserID: %@", userInfor.usermodel.UserID);
        
        userInfor.doSomething();
    }];
}

+ (NSArray *)getEightPassword {
    [UserInformation userinforSingleton].ownerModel = [[OwnerModel alloc] init];
    [UserInformation userinforSingleton].ownerModel.OwnerID = [[NSUserDefaults standardUserDefaults] objectForKey:@"defaultOwnerID"];
    [UserInformation userinforSingleton].ownerModel.VName = [[NSUserDefaults standardUserDefaults] objectForKey:@"defaultVName"];
    [UserInformation userinforSingleton].ownerModel.BID = [[NSUserDefaults standardUserDefaults] objectForKey:@"defaultBID"];
    [UserInformation userinforSingleton].ownerModel.RID = [[NSUserDefaults standardUserDefaults] objectForKey:@"defaultRID"];;
    //    NSString *OwnerID = [UserInformation userinforSingleton].ownerModel.OwnerID;
//    NSString *VName = [UserInformation userinforSingleton].ownerModel.VName;
    NSString *BID = [UserInformation userinforSingleton].ownerModel.BID;
    NSString *RID = [UserInformation userinforSingleton].ownerModel.RID;
    
//    _addressField.text = [NSString stringWithFormat:@"%@%@栋", VName, BID];
//    _entranceField.text = [NSString stringWithFormat:@"%@室", RID];
    
    NSString *strRID = RID;
    if (RID.length < 4) {
        for (NSInteger i = 0; i < 4 - RID.length; i++) {
            strRID = [NSString stringWithFormat:@"%@%@", @"0", strRID];
        }
    }
    //  生成两位随机数
    NSString *randomStr = [NSString stringWithFormat:@"%u", arc4random() % 90 + 10];
    
    NSString *randomPassword = [NSString stringWithFormat:@"%@%@%@", BID, strRID, randomStr];
    
    return @[[UserInformation userinforSingleton].ownerModel, randomPassword];
}

+ (void)saveOwnerInforToLocalWithModel:(OwnerModel *)model {
    NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
    [userdef setObject:model.OwnerID forKey:@"defaultOwnerID"];
    [userdef setObject:model.VName forKey:@"defaultVName"];
    [userdef setObject:model.BID forKey:@"defaultBID"];
    [userdef setObject:model.Unit forKey:@"defaultlUnit"];
    [userdef setObject:model.RID forKey:@"defaultRID"];
    [userdef synchronize];
}

@end
