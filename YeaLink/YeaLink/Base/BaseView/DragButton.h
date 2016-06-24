//
//  DragButton.h
//  YeaLink
//
//  Created by 李根 on 16/6/7.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "QJLBaseButton.h"

@interface DragButton : QJLBaseButton
@property(nonatomic, strong)void(^beginDrag)(CGFloat); //  拖动开始
@property(nonatomic, strong)void(^endDrag)();   //  结束滑动
@property(nonatomic, strong)void(^operate)();   //  符合条件, 执行相应的功能
@property(nonatomic, strong)void(^changebgColor)(); //  改变滑动按钮是背景颜色

@end
