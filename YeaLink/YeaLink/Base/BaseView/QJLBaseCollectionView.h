//
//  QJLBaseCollectionView.h
//  YeaLink
//
//  Created by 李根 on 16/4/24.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CollectionRefresher <NSObject>

- (void)headRe;
- (void)footRe;

@end

@interface QJLBaseCollectionView : UICollectionView

@property(nonatomic, strong)id<CollectionRefresher>refresher;
@property(nonatomic, copy)void(^push)(NSIndexPath *);
@property(nonatomic, strong)NSMutableArray *dataArr;



- (void)createView;


@end
