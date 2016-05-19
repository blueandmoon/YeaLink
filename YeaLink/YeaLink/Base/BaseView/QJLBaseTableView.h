//
//  QJLBaseTableView.h
//  YeaLink
//
//  Created by 李根 on 16/4/24.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TableViewRefresher <NSObject>

- (void)headRe;
- (void)footRe;

@end

@interface QJLBaseTableView : UITableView

@property(nonatomic, strong)id<TableViewRefresher>refresher;
@property(nonatomic, copy)void(^push)(NSIndexPath *);
@property(nonatomic, strong)NSMutableArray *dataArr;

-(void)createView;


@end
