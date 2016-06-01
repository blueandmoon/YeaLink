//
//  AreaView.h
//  YeaLink
//
//  Created by 李根 on 16/4/26.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "QJLBaseView.h"
#import "AreaModel.h"

@interface AreaView : QJLBaseView
@property(nonatomic, strong)NSMutableArray *arr;
@property(nonatomic, strong)QJLBaseTableView *tableView;
@property(nonatomic, strong)void(^setLeftNavigationItem)(AreaModel *model); //  传值切换城市
@property(nonatomic, strong)void(^changeCity)(AreaModel *model);

@end
