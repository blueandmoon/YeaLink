//
//  QJLBaseImageView.m
//  YeaLink
//
//  Created by 李根 on 16/4/24.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "QJLBaseImageView.h"

@implementation QJLBaseImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
//        self.backgroundColor = [UIColor orangeColor];
//        self.layer.borderWidth = 1;
        
        [self createView];
    }
    return self;
}

- (void)createView {
    
}


@end
