//
//  NetworkState.m
//  YeaLink
//
//  Created by 李根 on 16/4/27.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "NetworkState.h"

@implementation NetworkState

+ (void)checkNetworkState {
    //  检测wifi状态
    Reachability *wifi = [Reachability reachabilityForLocalWiFi];
    //  检测手机是否能上网络
    Reachability *conn = [Reachability reachabilityForInternetConnection];
    
    //  判断网络状态
    if ([wifi currentReachabilityStatus] != NotReachable) {   //   有wifi
        NSLog(@"有wifi");
    } else if ([conn currentReachabilityStatus] != NotReachable) {
        //  没有wifi, 使用手机自带网络能上网
        NSLog(@"手机自带网络上网");
    } else {
        //  没有网络
        NSLog(@"没有网络");
    }
    
    
    
    
}

@end
