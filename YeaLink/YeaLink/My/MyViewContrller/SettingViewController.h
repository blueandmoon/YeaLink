//
//  SettingViewController.h
//  YeaLink
//
//  Created by 李根 on 16/5/12.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "QJLBaseViewController.h"
/**
 *  设置
 */
@interface SettingViewController : QJLBaseViewController
@property(nonatomic, strong)void(^refreshData)();   //  业主向个人, 个人向业主转换时, 增减小区, 及切换账号时

@end
