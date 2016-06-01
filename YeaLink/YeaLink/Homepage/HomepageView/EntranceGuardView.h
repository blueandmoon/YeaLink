//
//  EntranceGuardView.h
//  YeaLink
//
//  Created by 李根 on 16/4/26.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "QJLBaseView.h"

@interface EntranceGuardView : QJLBaseView
@property(nonatomic, strong)QJLBaseTableView *tableView;
@property(nonatomic, strong)NSMutableArray *arr;
@property(nonatomic, strong)void(^jump)(NSInteger row);

@end
