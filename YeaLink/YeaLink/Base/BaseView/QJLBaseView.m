//
//  QJLBaseView.m
//  YeaLink
//
//  Created by 李根 on 16/4/24.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "QJLBaseView.h"

@implementation QJLBaseView

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
        self.backgroundColor= [UIColor whiteColor];
    }
    return self;
}

- (void)createView {
    
}


@end
