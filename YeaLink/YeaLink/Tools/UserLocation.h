//
//  UserLocation.h
//  YeaLink
//
//  Created by 李根 on 16/5/16.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserLocation : QJLBaseView
//  一键定位, 哇咔咔~
+ (instancetype)shareGpsManager;

//@property(nonatomic, strong)void(^realtimePosition)();  //  启动定位的接口

- (void)UpdatingLocation;  //  更新位置

@end
