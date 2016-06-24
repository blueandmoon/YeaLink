//
//  HeaderView.m
//  YeaLink
//
//  Created by 李根 on 16/5/24.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "HeaderView.h"

@interface HeaderView ()
@property(nonatomic, strong)QJLBaseImageView *scanImageView;

@end

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
    
    _scanImageView = [[QJLBaseImageView alloc] init];
    [self addSubview:_scanImageView];
    _scanImageView.image = [UIImage imageNamed:@"scan"];
    [_scanImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_label);
        make.height.mas_equalTo(18 * HEI);
        make.right.equalTo(self).with.offset(-26 * WID);
        make.width.mas_equalTo(20.5 * WID);
    }];
    
    _button = [QJLBaseButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_button];
    _button.opaque = NO;

    [_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.right.and.height.equalTo(self);
        make.left.equalTo(_scanImageView.mas_left).with.offset(-10);
    }];



}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
