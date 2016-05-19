//
//  BaseScrollView.h
//  YeaLink
//
//  Created by 李根 on 16/5/6.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "QJLBaseView.h"

@interface BaseScrollView : QJLBaseView
@property(nonatomic, strong)NSMutableArray *arr;
@property(nonatomic, strong)UIScrollView *scrollview;
@property(nonatomic, strong)NSTimer *timer;

@end
