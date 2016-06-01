//
//  PersonCenterView.h
//  SI
//
//  Created by 李根 on 16/5/11.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "QJLBaseView.h"

@interface PersonCenterView : QJLBaseView
@property(nonatomic, strong)QJLBaseTableView *tableview;
@property(nonatomic, strong)NSMutableArray *arr;
@property(nonatomic, strong)void(^pushView)(NSInteger section, NSInteger userRole);
@property(nonatomic, strong)void(^jumpView)();

@end
