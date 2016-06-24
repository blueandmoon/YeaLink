//
//  AccessControlView.m
//  YeaLink
//
//  Created by 李根 on 16/6/7.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "AccessControlView.h"

@implementation AccessControlView
{
    QJLBaseView *_bottomView;   //  蓝色底层view
    QJLBaseImageView *_homeImageView;   //  小房子
    QJLBaseLabel *_bottomLabel; //  底层绘图
    QJLBaseLabel *_topLabel;    //  顶层视图
    
}

- (void)createView {
    _bottomView = [[QJLBaseView alloc] init];
    [self addSubview:_bottomView];
    _bottomView.backgroundColor = CUSTOMBLUE;
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.top.and.left.equalTo(self);
        make.height.mas_equalTo(155 * HEI);
    }];
    
    _homeImageView = [[QJLBaseImageView alloc] init];
    [self addSubview:_homeImageView];
    _homeImageView.image = [UIImage imageNamed:@"smallHouse"];
    _homeImageView.backgroundColor = CUSTOMBLUE;
    [_homeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(71 * WID, 65 * HEI));
        make.left.equalTo(self).with.offset(21 * WID);
        make.centerY.equalTo(_bottomView);
    }];
    
    //  地址栏
    _addressField = [QJLBaseTextfield textfieldCustomWithFrame:CGRectZero placeholderText:@"" textAlignment:NSTextAlignmentLeft titlecolor:[UIColor whiteColor] font:[UIFont systemFontOfSize:19]];
    _addressField.text = @"地址";
    [self addSubview:_addressField];
    _addressField.enabled = NO;
    _addressField.backgroundColor = CUSTOMBLUE;
    _addressField.layer.borderColor = [UIColor whiteColor].CGColor;
    _addressField.rightViewMode = UITextFieldViewModeAlways;
    [_addressField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_bottomView);
        make.left.equalTo(_homeImageView.mas_right).with.offset(11 * WID);
//        make.right.equalTo(_bottomView).with.offset(- 21 * WID);
        make.width.mas_equalTo(225 * WID);
        make.height.mas_equalTo(45 * HEI);
    }];
    NSLog(@"_addressField.textColor: %@", _addressField.textColor);
    
    QJLBaseImageView *rightView = [[QJLBaseImageView alloc] initWithFrame:CGRectMake(0, 0, 30 * WID, 20 * HEI)];
    rightView.image = [UIImage imageNamed:@"dropDown"];
    _addressField.rightView = rightView;
    
    //  在地址栏覆盖一层透明view, 一边添加点击事件
    //  当textfield禁止编辑之后, 其用户交互也被关闭了, 只能这样搞了, 蛋的
    _view = [[UIView alloc] init];
    [self addSubview:_view];
    [_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.and.equalTo(_addressField);
        make.left.equalTo(_addressField.mas_left);
        make.top.equalTo(_addressField);
    }];
    
    [self addTapGestureWith:_view];
    
    _videoBtn = [[SlideButton alloc] init];
    _videoBtn.backgroundColor = [UIColor colorWithHex:0xf4f4f4];
    [self addSubview:_videoBtn];
    _videoBtn.slideBtn.tag = 101;
    _videoBtn.slideBtn.enabled = NO;
    [_videoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(39 * WID);
        make.right.equalTo(self).with.offset(-39 * WID);
        make.top.equalTo(_bottomView.mas_bottom).with.offset(36 * HEI);
        make.height.mas_equalTo(33 * HEI);
    }];
    
    _blueToothBtn = [[SlideButton alloc] init];
    [self addSubview:_blueToothBtn];
    _blueToothBtn.slideBtn.tag = 102;
    _blueToothBtn.slideBtn.backgroundColor = CUSTOMBLUE;
    _blueToothBtn.backgroundColor = [UIColor colorWithHex:0xf4f4f4];
    [_blueToothBtn.slideBtn setTitle:@"蓝牙" forState:UIControlStateNormal];
    _blueToothBtn.bottomLabel.text = @"蓝牙开锁";
    [_blueToothBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.and.centerX.equalTo(_videoBtn);
        make.top.equalTo(_videoBtn.mas_bottom).with.offset(70 * HEI);
    }];
    
    _passwordBtn = [[SlideButton alloc] init];
    [self addSubview:_passwordBtn];
    _passwordBtn.slideBtn.tag = 103;
    _passwordBtn.slideBtn.backgroundColor = CUSTOMBLUE;
    _passwordBtn.bottomLabel.text = @"右划授权";
    [_passwordBtn.slideBtn setTitle:@"密码" forState:UIControlStateNormal];
    _passwordBtn.backgroundColor = [UIColor colorWithHex:0xf4f4f4];
    [_passwordBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.and.centerX.equalTo(_videoBtn);
        make.top.equalTo(_blueToothBtn.mas_bottom).with.offset(70 * HEI);
    }];
    
    
}

#pragma mark    - 地址栏下拉手势
- (void)addTapGestureWith:(UIView *)view {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [view addGestureRecognizer:tap];
    
}

- (void)tap {
    self.clickAddress();
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
