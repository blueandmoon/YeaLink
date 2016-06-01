//
//  LeftView.h
//  YeaLink
//
//  Created by 李根 on 16/5/30.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "QJLBaseView.h"
/**
 *  Homepage左上角 地区+图标
 */
@interface LeftView : QJLBaseView
@property(nonatomic, strong)QJLBaseLabel *label;
@property(nonatomic, strong)QJLBaseImageView *iconView;
@property(nonatomic, strong)void(^tapAction)();

@end
