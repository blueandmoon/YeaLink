//
//  ObserverKeyboard.h
//  YeaLink
//
//  Created by 李根 on 16/6/2.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ObserverKeyboard : UIView
@property(nonatomic, strong)void(^takeKeyboardValue)(CGFloat);  //  传递键盘长宽
@property(nonatomic, strong)void(^keyboardWillHide)();  //  键盘隐去

+ (instancetype)shareKeyboard;

- (void)addObserver;

@end
