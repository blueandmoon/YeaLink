//
//  ObserverKeyboard.m
//  YeaLink
//
//  Created by 李根 on 16/6/2.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "ObserverKeyboard.h"

@implementation ObserverKeyboard

+ (instancetype)shareKeyboard {
    static ObserverKeyboard *obser;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obser = [[ObserverKeyboard alloc] init];
    });
    return obser;
}

- (instancetype)init {
    if (self = [super init]) {
        [self addObserver];
    }
    return self;
}

- (void)addObserver {
    //  增加监听, 当键盘出现或者改变时获取消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    //  增加监听, 当键盘退出时获得消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)keyboardWillShow:(NSNotification *)notification {
    //  获取键盘的高度
    /**
     iphone 6:
     中文
     2014-12-31 11:16:23.643 Demo[686:41289] 键盘高度是  258
     2014-12-31 11:16:23.644 Demo[686:41289] 键盘宽度是  375
     英文
     2014-12-31 11:55:21.417 Demo[1102:58972] 键盘高度是  216
     2014-12-31 11:55:21.417 Demo[1102:58972] 键盘宽度是  375
     
     iphone  6 plus：
     英文：
     2014-12-31 11:31:14.669 Demo[928:50593] 键盘高度是  226
     2014-12-31 11:31:14.669 Demo[928:50593] 键盘宽度是  414
     中文：
     2015-01-07 09:22:49.438 Demo[622:14908] 键盘高度是  271
     2015-01-07 09:22:49.439 Demo[622:14908] 键盘宽度是  414
     
     iphone 5 :
     2014-12-31 11:19:36.452 Demo[755:43233] 键盘高度是  216
     2014-12-31 11:19:36.452 Demo[755:43233] 键盘宽度是  320
     
     ipad Air：
     2014-12-31 11:28:32.178 Demo[851:48085] 键盘高度是  264
     2014-12-31 11:28:32.178 Demo[851:48085] 键盘宽度是  768
     
     ipad2 ：
     2014-12-31 11:33:57.258 Demo[1014:53043] 键盘高度是  264
     2014-12-31 11:33:57.258 Demo[1014:53043] 键盘宽度是  768
     */
    NSDictionary *userInfo = [notification userInfo];
    NSValue *value = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [value CGRectValue];
    
    [UserInformation userinforSingleton].keyboardRect = keyboardRect;

    int height = keyboardRect.size.height;
//    int width = keyboardRect.size.width;
    NSLog(@"键盘高度是: %d", height);
    self.takeKeyboardValue(height);
//    NSLog(@"键盘宽度是: %d", width);
//    NSLog(@"keyboardRect:%@", [UserInformation userinforSingleton].keyboardRect);
}

//  当键盘退出时调用
- (void)keyboardWillHide:(NSNotification *)notification {
    self.keyboardWillHide();
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
