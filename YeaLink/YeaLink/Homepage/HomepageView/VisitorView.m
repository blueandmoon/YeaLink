//
//  VisitorView.m
//  YeaLink
//
//  Created by 李根 on 16/6/8.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "VisitorView.h"
#import "SeperateView.h"

#define kHDistance 11.5 * HEI
#define kLeftDistance 30 * WID

@implementation VisitorView
{
    OwnerModel *_ownModel;  //  业主默认小区信息
    QJLBaseView *_bottomView;   //  访客密码底层视图
    QJLBaseLabel *_titleLabel;  //
    QJLBaseButton *_closeBtn;   //  关闭按钮
    QJLBaseButton *_ensureBtn;  //  确定按钮
    SeperateView *_seperView;   //  分割线
    
}
- (void)createView {
    _titleLabel = [QJLBaseLabel LabelWithFrame:CGRectZero text:@"访客密码" titleColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter font:[UIFont systemFontOfSize:23]];
    [self addSubview:_titleLabel];
    _titleLabel.backgroundColor = CUSTOMBLUE;
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.width.equalTo(self);
        make.height.mas_equalTo(60 * HEI);
    }];
    
    _closeBtn = [QJLBaseButton buttonCustomFrame:CGRectZero normalImageString:@"close"];
    [self addSubview:_closeBtn];
    _closeBtn.backgroundColor = CUSTOMBLUE;
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_titleLabel);
        make.right.equalTo(self).with.offset(-15 * WID);
        make.size.mas_equalTo(CGSizeMake(24 * WID, 24 * WID));
    }];
    [_closeBtn addTarget:self action:@selector(closeClick:) forControlEvents:UIControlEventTouchUpInside];
    
    //  地址栏
    _addressField = [[SelectTextfield alloc] init];
    [self addSubview:_addressField];

    _addressField.rightViewMode = UITextFieldViewModeAlways;
    [_addressField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.left.equalTo(self).with.offset(kLeftDistance);
        make.height.mas_equalTo(36 * HEI);
        make.top.equalTo(_titleLabel.mas_bottom).with.offset(kHDistance);
    }];
    [_addressField setValue:[NSNumber numberWithInt:10] forKey:@"paddingLeft"];
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"dropDown_Black"]];
    imageView.frame = CGRectMake(0, 0, 19 * WID, 10 * HEI);
    _addressField.rightView = imageView;
    
    //  覆盖上一层view来添加点击手势
    _coverAddressView = [[UIView alloc] init];
    [self addSubview:_coverAddressView];
    [_coverAddressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_addressField);
        make.size.equalTo(_addressField);
    }];
    
    _entranceField = [[SelectTextfield alloc] init];
    [self addSubview:_entranceField];
//    _entranceField.placeholder = @"请选择具体的门禁";
    [_entranceField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.and.centerX.equalTo(_addressField);
        make.top.equalTo(_addressField.mas_bottom).with.offset(kHDistance);
    }];
    [_entranceField setValue:[NSNumber numberWithInt:10] forKey:@"paddingLeft"];
    
    //  覆盖上一层view来添加点击手势
    _coverEntranceView = [[UIView alloc] init];
    [self addSubview:_coverEntranceView];
    [_coverEntranceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_entranceField);
        make.size.equalTo(_entranceField);
    }];
    
    //  点击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightTap:)];
    [_coverAddressView addGestureRecognizer:tap];
//    UITapGestureRecognizer *entTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightTap:)];
//    [_coverEntranceView addGestureRecognizer:entTap];
    
    //  随机密码框
    _randomLabel = [[QJLBaseLabel alloc] init];
    [self addSubview:_randomLabel];
    _randomLabel.layer.borderColor = [UIColor colorWithHex:0xb7b7b7].CGColor;
    _randomLabel.layer.borderWidth = 1;
    _randomLabel.layer.cornerRadius = 5;
    _randomLabel.textAlignment = NSTextAlignmentCenter;
    [_randomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_entranceField.mas_bottom).with.offset(kHDistance);
        make.left.equalTo(self).with.offset(kLeftDistance);
        make.height.equalTo(_entranceField);
        make.width.mas_equalTo(140 * WID);
    }];
    
    _ensureBtn = [QJLBaseButton buttonCustomFrame:CGRectZero title:@"确定" currentTitleColor:[UIColor whiteColor]];
    [self addSubview:_ensureBtn];
    _ensureBtn.layer.cornerRadius = 5;
    _ensureBtn.backgroundColor = [UIColor colorWithHex:0x30cf38];
    [_ensureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.and.centerY.equalTo(_randomLabel);
        make.right.equalTo(self).with.offset(-kLeftDistance);
        make.width.mas_equalTo(90 * WID);
    }];
    [_ensureBtn addTarget:self action:@selector(ensureClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _seperView = [[SeperateView alloc] init];
    [self addSubview:_seperView];
    [_seperView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_randomLabel.mas_bottom).with.offset(11.5 * HEI);
        make.left.and.width.equalTo(self);
        make.height.mas_equalTo(15 * HEI);
    }];
    
    NSArray *arr = [UserInformation getEightPassword];
    _ownModel = arr[0];
    NSString *randomPassword = arr[1];
    _addressField.text = [NSString stringWithFormat:@"%@%@栋", _ownModel.VName, _ownModel.BID];
    _entranceField.text = [NSString stringWithFormat:@"%@室", _ownModel.RID];
    _randomLabel.text = randomPassword;
    
    //  分享按钮
    _wechatBtn = [[ShareButton alloc] init];
    [_wechatBtn.topBtn setImage:[UIImage imageNamed:@"wechat"] forState:UIControlStateNormal];
    _wechatBtn.downLabel.text = @"微信";
    [self addSubview:_wechatBtn];
    [_wechatBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(kLeftDistance);
        make.size.mas_equalTo(CGSizeMake(43 * WID, 60 * HEI));
        make.bottom.equalTo(self).with.offset(-5 * HEI);
    }];
    
    _qqBtn = [[ShareButton alloc] init];
    [_qqBtn.topBtn setImage:[UIImage imageNamed:@"qq"] forState:UIControlStateNormal];
    _qqBtn.downLabel.text = @"QQ";
    [self addSubview:_qqBtn];
    [_qqBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.and.centerY.equalTo(_wechatBtn);
        make.centerX.equalTo(self);
    }];
    
    _smsBtn = [[ShareButton alloc] init];
    [_smsBtn.topBtn setImage:[UIImage imageNamed:@"sms"] forState:UIControlStateNormal];
    _smsBtn.downLabel.text = @"短信";
    [self addSubview:_smsBtn];
    [_smsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.and.centerY.equalTo(_wechatBtn);
        make.right.equalTo(self).with.offset(-kLeftDistance);
    }];
}

- (void)ensureClick:(UIButton *)btn {
    [_ensureBtn setEnabled:NO];
    NSLog(@"点点点");
    NSString *tempStr = [NSString stringWithFormat:@"http://wapi.go2family.com/api/DoorControl/AddVisitorPassword?OwnerID=%@&VisitorPassword=%@", _ownModel.OwnerID, _randomLabel.text];
    NSLog(@"%@", tempStr);
    [NetWorkingTool getNetWorking:tempStr block:^(id result) {
        [_ensureBtn setEnabled:YES];
        if ([result[@"code"] isEqualToString:@"1"]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"发送成功" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:result[@"text"] message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }
    }];
}

- (void)rightTap:(id)sender {
//    NSLog(@"点我干啥哩");
    self.selectVillage();
}

#pragma mark    - 关闭按钮
- (void)closeClick:(UIButton *)btn {
//    [self removeFromSuperview];
    self.removeView();
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
