//
//  DropListView.h
//  YeaLink
//
//  Created by 李根 on 16/6/15.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "QJLBaseView.h"
#import "OwnerModel.h"
/**
 *  访客密码下拉列表
 */
@interface DropListView : QJLBaseView

@property(nonatomic, strong)QJLBaseTableView *tableView;
@property(nonatomic, strong)NSMutableArray *arr;

@property(nonatomic, strong)void(^selectVillage)(); //  选择了小区
@property(nonatomic, strong)void(^showTitle)(OwnerModel *); //  显示在下拉框的标题

@end
