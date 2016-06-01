//
//  BindingCellController.h
//  YeaLink
//
//  Created by 李根 on 16/5/20.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "QJLBaseViewController.h"

@interface BindingCellController : QJLBaseViewController
@property(nonatomic, strong)void(^refreshDataWithSwitchNeighbour)();    //  个人用户绑定小区

@end
