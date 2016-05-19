//
//  QJLBaseTableView.m
//  YeaLink
//
//  Created by 李根 on 16/4/24.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "QJLBaseTableView.h"

@implementation QJLBaseTableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}

- (void)setRefresher:(id<TableViewRefresher>)refresher {
    _refresher = refresher;
    if (self.refresher) {
        self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self.refresher headRe];
        }];
        self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self.refresher footRe];
        }];
        NSLog(@"已签代理");
        
    } else {
        NSLog(@"没签代理人");
    }
}

- (void)createView {
    
}

@end
