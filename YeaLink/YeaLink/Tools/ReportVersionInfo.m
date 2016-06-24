//
//  ReportVersionInfo.m
//  YeaLink
//
//  Created by 李根 on 16/6/7.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "ReportVersionInfo.h"

@implementation ReportVersionInfo

+ (NSString *)getVersionInfo {
    //  版本检测
    //  版本信息
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    NSString *systemModel = [[UIDevice currentDevice] model];   //  是iPhone还是iPad
    NSDictionary *dic = [[NSBundle mainBundle] infoDictionary]; //  获取info-plist
    NSString *appName = [dic objectForKey:@"CFBundleIdentifier"];   //  获取Bundle identifier
    NSString *appVersion = [dic valueForKey:@"CFBundleIdentifier"]; //  获取Bundle Version
    NSDictionary *userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:
                              systemVersion, @"systemVersion",
                              systemModel, @"systemModel",
                              appName, @"appName",
                              appVersion, @"appVersion", nil];
//    NSLog(@"%@", userInfo);
    //  版本号
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *version;
    version = [infoDic objectForKey:(id)kCFBundleVersionKey];
    NSLog(@"版本号: %@", version);
    return version;
}

@end
