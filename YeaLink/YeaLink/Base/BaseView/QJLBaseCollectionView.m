//
//  QJLBaseCollectionView.m
//  YeaLink
//
//  Created by 李根 on 16/4/24.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "QJLBaseCollectionView.h"

@implementation QJLBaseCollectionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        [self createView];
    }
    return self;
}

/**
 *  刷新
 */

- (void)setRefresher:(id<CollectionRefresher>)refresher {
    _refresher = refresher;
    if (self.refresher) {
        self.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [self.refresher headRe];
        }];
        self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            [self.refresher footRe];
        }];
        NSLog(@"签订了代理");
    } else {
        NSLog(@"没签代理");
    }
}

- (void)createView {
    
}


@end
