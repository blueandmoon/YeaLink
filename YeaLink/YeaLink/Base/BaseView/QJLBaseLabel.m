//
//  QJLBaseLabel.m
//  YeaLink
//
//  Created by 李根 on 16/4/24.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "QJLBaseLabel.h"

@implementation QJLBaseLabel

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
//        self.text = @"label";
//        self.layer.borderWidth = 1;
        
        [self createView];
        
        
    }
    
    return self;
}

- (void)createView {
    
}

//普通的文字label
+(instancetype)LabelWithFrame:(CGRect)frame
                         text:(NSString *)text
                   titleColor:(UIColor *)textColor
                textAlignment:(NSTextAlignment)textAlignment
                         font:(UIFont *)font
{
    QJLBaseLabel *l = [[QJLBaseLabel alloc] initWithFrame:frame];
    l.text = text;
    l.textColor = textColor;
    l.textAlignment = textAlignment;
    l.font = font;
    return l;
}


@end
