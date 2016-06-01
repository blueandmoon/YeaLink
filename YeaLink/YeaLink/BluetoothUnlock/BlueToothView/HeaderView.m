//
//  HeaderView.m
//  YeaLink
//
//  Created by 李根 on 16/5/24.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "HeaderView.h"

@implementation HeaderView

- (void)createView {
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.borderWidth = 1;
    
    _label = [QJLBaseLabel LabelWithFrame:CGRectZero text:@"可用设备" titleColor:[UIColor grayColor] textAlignment:NSTextAlignmentCenter font:[UIFont systemFontOfSize:19]];
    [self addSubview:_label];
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(15 * WID);
        make.width.mas_equalTo(100 * WID);
        make.bottom.equalTo(self).with.offset(-5 * HEI);
        make.height.mas_equalTo(30 * HEI);
    }];
    
    _button = [QJLBaseButton buttonCustomFrame:CGRectZero normalImageString:@"scan"];
    [self addSubview:_button];
    _button.frame = CGRectMake(0, 0, 50, 50);
//    _button.backgroundColor = CUSTOMBLUE;
    [_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_label);
        make.height.mas_equalTo(18 * HEI);
        make.right.equalTo(self).with.offset(-26 * WID);
        make.width.mas_equalTo(20.5 * WID);
    }];
//    [_button addTarget:self action:@selector(scanAppDevices:) forControlEvents:UIControlEventTouchUpInside];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
