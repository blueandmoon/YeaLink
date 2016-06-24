//
//  SlideButton.h
//  YeaLink
//
//  Created by 李根 on 16/6/8.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "QJLBaseButton.h"
#import "DragButton.h"

/**
 *  这是一个view, understand?   滑动按钮
 */
@interface SlideButton : QJLBaseView
@property(nonatomic, strong)QJLBaseLabel *bottomLabel;
@property(nonatomic, strong)DragButton *slideBtn;
@property(nonatomic, strong)QJLBaseLabel *topLabel;

@end
