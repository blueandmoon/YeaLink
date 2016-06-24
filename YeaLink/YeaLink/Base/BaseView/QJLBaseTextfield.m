//
//  QJLBaseTextfield.m
//  YeaLink
//
//  Created by 李根 on 16/4/24.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "QJLBaseTextfield.h"

@implementation QJLBaseTextfield

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.layer.borderWidth = 1;
        
        [self createView];
//        self.text = @"istextfield";
    }
    
    
    return self;
}

- (void)createView {
    [self setValue:[NSNumber numberWithInt:5] forKey:@"paddingLeft"];
    self.layer.cornerRadius = 5;
}

+ (instancetype)textfieldCustomWithFrame:(CGRect)frame placeholderText:(NSString *)placeholderText textAlignment:(NSTextAlignment)textAlignment titlecolor:(UIColor *)titlecolor font:(UIFont *)font {
    QJLBaseTextfield *textfield = [[QJLBaseTextfield alloc] init];
    textfield.frame = frame;
    textfield.placeholder = placeholderText;
    textfield.textAlignment = textAlignment;
    textfield.textColor = titlecolor;
    textfield.font = font;
    
    //  设置左内边距
    [textfield setValue:[NSNumber numberWithInt:15] forKey:@"paddingLeft"];
    textfield.layer.cornerRadius = 5;
    return textfield;
}

#pragma mark    - 改变rightVIew距离右边界的距离
- (CGRect)rightViewRectForBounds:(CGRect)bounds {
    CGRect textRect = [super rightViewRectForBounds:bounds];
    textRect.origin.x -= 10 * WID;
    return textRect;
}

@end
