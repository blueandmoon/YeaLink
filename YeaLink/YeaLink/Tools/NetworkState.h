//
//  NetworkState.h
//  YeaLink
//
//  Created by 李根 on 16/4/27.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface NetworkState : NSObject
/**
 *  判断网络状态
 */
+ (void)checkNetworkState;

@end
