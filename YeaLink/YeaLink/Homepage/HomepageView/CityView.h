//
//  CityView.h
//  YeaLink
//
//  Created by 李根 on 16/5/26.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "QJLBaseView.h"
/**
 *  首页左上角   城市名 + 图标
 */
@interface CityView : QJLBaseView
@property(nonatomic, strong)QJLBaseView *bottomView;
@property(nonatomic, strong)QJLBaseLabel *label;
@property(nonatomic, strong)QJLBaseImageView *imageview;

@end
