//
//  DropDownListView.h
//  YeaLink
//
//  Created by 李根 on 16/6/14.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "QJLBaseView.h"
/**
 *  下拉列表, 门禁开门的
 */
@interface DropDownListView : QJLBaseView
@property(nonatomic, strong)QJLBaseTableView *tableView;
@property(nonatomic, strong)NSMutableArray *arr;

@property(nonatomic, strong)void(^selectVillage)(); //  选择了小区

@end
