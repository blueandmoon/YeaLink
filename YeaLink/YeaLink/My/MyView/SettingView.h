//
//  SettingView.h
//  YeaLink
//
//  Created by 李根 on 16/5/12.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "QJLBaseTableView.h"

@interface SettingView : QJLBaseView
@property(nonatomic, strong)QJLBaseTableView *tableView;
@property(nonatomic, strong)NSMutableArray *arr;
@property(nonatomic, strong)void(^push)();
@property(nonatomic, strong)NSMutableArray *nextArr;    //  跳到下一个页面的webview的数组

@end
