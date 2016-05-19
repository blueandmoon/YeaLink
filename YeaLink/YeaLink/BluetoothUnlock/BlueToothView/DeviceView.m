//
//  DeviceView.m
//  YeaLink
//
//  Created by 李根 on 16/5/17.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "DeviceView.h"
#define HDISTANCE 30 * HEI
#define WDISTANCE 30 * WID

@implementation DeviceView

- (void)createView {
    _passwordField = [[QJLBaseTextfield alloc] init];
    [self addSubview:_passwordField];
    _passwordField.placeholder = @"请输入密码";
    _passwordField.layer.cornerRadius = 10;
//    _passwordField.backgroundColor = [UIColor blueColor];
    _passwordField.layer.borderColor = [UIColor colorWithRed:209 / 255.0 green:209 / 255.0 blue:209 / 255.0 alpha:1].CGColor;
    [_passwordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(HDISTANCE);
        make.left.equalTo(self).with.offset(WDISTANCE);
        make.right.equalTo(self).with.offset(-WDISTANCE);
        make.height.mas_equalTo(50 * HEI);
    }];
    
//    _connectBtn = [[QJLBaseButton alloc] init];
//    [self addSubview:_connectBtn];
////    _connectBtn.backgroundColor = [UIColor lightGrayColor];
//    _connectBtn.layer.cornerRadius = 10;
//    _connectBtn.backgroundColor = [UIColor colorWithRed:221 / 255.0 green:103 / 255.0 blue:49 / 255.0 alpha:1];
////    [_connectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [_connectBtn setTitle:@"连接" forState:UIControlStateNormal];
//    [_connectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_passwordField.mas_bottom).with.offset(HDISTANCE);
//        make.size.equalTo(_passwordField);
//        make.left.equalTo(self).with.offset(WDISTANCE);
//    }];

//    _disconnectBtn = [[QJLBaseButton alloc] init];
//    [self addSubview:_disconnectBtn];
//    _disconnectBtn.backgroundColor = [UIColor colorWithRed:221 / 255.0 green:103 / 255.0 blue:49 / 255.0 alpha:1];
////    _disconnectBtn.backgroundColor = [UIColor lightGrayColor];
//    _disconnectBtn.layer.cornerRadius = 10;
////    [_disconnectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [_disconnectBtn setTitle:@"断开连接" forState:UIControlStateNormal];
//    [_disconnectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_connectBtn.mas_bottom).with.offset(HDISTANCE);
//        make.size.equalTo(_passwordField);
//        make.left.equalTo(self).with.offset(WDISTANCE);
//    }];
    
    _openDoorBtn = [[QJLBaseButton alloc] init];
    [self addSubview:_openDoorBtn];
//    _openDoorBtn.backgroundColor = [UIColor lightGrayColor];
    _openDoorBtn.backgroundColor = [UIColor colorWithRed:221 / 255.0 green:103 / 255.0 blue:49 / 255.0 alpha:1];
    _openDoorBtn.layer.cornerRadius = 10;
//    [_openDoorBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_openDoorBtn setTitle:@"开锁" forState:UIControlStateNormal];
    [_openDoorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_passwordField.mas_bottom).with.offset(HDISTANCE);
        make.size.equalTo(_passwordField);
        make.left.equalTo(self).with.offset(WDISTANCE);
    }];
    
//    _closeDoorBtn = [[QJLBaseButton alloc] init];
//    [self addSubview:_closeDoorBtn];
//    _closeDoorBtn.backgroundColor = [UIColor colorWithRed:221 / 255.0 green:103 / 255.0 blue:49 / 255.0 alpha:1];
////    _closeDoorBtn.backgroundColor = [UIColor lightGrayColor];
//    _closeDoorBtn.layer.cornerRadius = 10;
////    [_closeDoorBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [_closeDoorBtn setTitle:@"关锁" forState:UIControlStateNormal];
//    [_closeDoorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(_openDoorBtn.mas_bottom).with.offset(HDISTANCE);
//        make.size.equalTo(_passwordField);
//        make.left.equalTo(self).with.offset(WDISTANCE);
//    }];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
