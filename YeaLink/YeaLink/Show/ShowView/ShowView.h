//
//  ShowView.h
//  YeaLink
//
//  Created by 李根 on 16/6/15.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "QJLBaseView.h"

/**
 *  秀场右上角下拉列表
 */
@interface ShowView : QJLBaseView
@property(nonatomic, strong)QJLBaseTableView *tableView;
@property(nonatomic, strong)NSArray *arr;

@property(nonatomic, strong)void(^selectVillage)(NSString *); //  选择了小区

@end
