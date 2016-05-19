//
//  BaseProgressHUD.m
//  YeaLink
//
//  Created by 李根 on 16/5/6.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "BaseProgressHUD.h"

@implementation BaseProgressHUD

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init {
    if ([super init]) {
        [self show:YES];
//        self.labelText = @"Load"; //  在这里设置不起作用
        self.mode = MBProgressHUDModeAnnularDeterminate;
//        self.labelColor = [UIColor orangeColor];
    }
    return self;
}



@end
