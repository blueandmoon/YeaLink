//
//  QJLBaseButton.m
//  YeaLink
//
//  Created by 李根 on 16/4/24.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "QJLBaseButton.h"

@implementation QJLBaseButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
//        self.layer.borderWidth = 1;
        
        [self createView];
//        [self setTitle:@"我是button" forState:UIControlStateNormal];
    }
    return self;
}

- (void)createView {
    
}

+ (instancetype)buttonCustomFrame:(CGRect)frame title:(NSString *)title currentTitleColor:(UIColor *)titleColor {
    QJLBaseButton *button = [QJLBaseButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    
    return button;
}

+ (instancetype)buttonCustomFrame:(CGRect)frame normalImageString:(NSString *)imageString {
    QJLBaseButton *button = [QJLBaseButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    [button setImage:[UIImage imageNamed:imageString] forState:UIControlStateNormal];
    
    return button;
}



@end
