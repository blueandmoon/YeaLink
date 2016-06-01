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
    _bottomView = [[QJLBaseView alloc] init];
    [self addSubview:_bottomView];
    _bottomView.backgroundColor = [UIColor colorWithHex:0x13a3fe];
    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.height.mas_equalTo(205 * HEI);
        make.left.equalTo(self);
        make.width.equalTo(self);
    }];
    
    _button = [QJLBaseButton buttonCustomFrame:CGRectZero normalImageString:@"blueToothImage"];
    [_bottomView addSubview:_button];
    [_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(_bottomView);
        make.size.mas_equalTo(CGSizeMake(100 * WID, 100 * HEI));
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
