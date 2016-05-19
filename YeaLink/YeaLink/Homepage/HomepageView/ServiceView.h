//
//  ServiceView.h
//  YeaLink
//
//  Created by 李根 on 16/4/24.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "QJLBaseView.h"

@interface ServiceView : QJLBaseView
/**
 *  首页下部图标
 */
@property(nonatomic, strong)NSMutableArray *tempArr;
@property(nonatomic, strong)QJLBaseCollectionView * collectionview;
@property(nonatomic, strong)void(^jumpView)();  //  跳转页面


@end
