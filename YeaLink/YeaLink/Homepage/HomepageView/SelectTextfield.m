//
//  SelectTextfield.m
//  YeaLink
//
//  Created by 李根 on 16/6/8.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "SelectTextfield.h"

@implementation SelectTextfield
{
    UIImageView *_imageview;
}
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.borderWidth = 1;
        self.layer.borderColor = [UIColor colorWithHex:0xb7b7b7].CGColor;
        self.layer.cornerRadius = 5;
        self.rightViewMode = UITextFieldViewModeAlways;
        self.enabled = NO;
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dropDown_Black"]];
        imageView.frame = CGRectMake(0, 0, 19 * WID, 10 * HEI);
        self.rightView = imageView;
        
//        [self createView];
    }
    return self;
}



//- (void)createView {
//    _coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
//    [self addSubview:_coverView];
//    _coverView.backgroundColor = [UIColor grayColor];
//    _coverView.userInteractionEnabled = YES;
////    coverView.alpha = 1.0;
//    
//    
//    
//}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
