//
//  QJLBaseButton.h
//  YeaLink
//
//  Created by 李根 on 16/4/24.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QJLBaseButton : UIButton


- (void)createView;

//  创建普通文字的button
+ (instancetype)buttonCustomFrame:(CGRect)frame
                            title:(NSString *)title
                currentTitleColor:(UIColor *)titleColor;

//  创建图片button
+ (instancetype)buttonCustomFrame:(CGRect)frame
                normalImageString:(NSString *)imageString;



@end
