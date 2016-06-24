//
//  SlideButton.m
//  YeaLink
//
//  Created by 李根 on 16/6/8.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "SlideButton.h"

@implementation SlideButton

- (void)createView {
    //  滑动按钮
    _bottomLabel = [QJLBaseLabel LabelWithFrame:CGRectZero text:@"右划开锁" titleColor:[UIColor colorWithHex:0xaaaaaa] textAlignment:NSTextAlignmentCenter font:[UIFont systemFontOfSize:17]];
    [self addSubview:_bottomLabel];
    _bottomLabel.backgroundColor = [UIColor colorWithHex:0xe3e3e3];
    _bottomLabel.layer.cornerRadius = 15;
    _bottomLabel.clipsToBounds = YES;
    [_bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.and.centerY.equalTo(self);
        make.width.equalTo(self);
        make.height.mas_equalTo(30 * HEI);
    }];
    
    _slideBtn = [DragButton buttonWithType:UIButtonTypeCustom];
    [_slideBtn setTitle:@"视频" forState:UIControlStateNormal];
    [_slideBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _slideBtn.font = [UIFont systemFontOfSize:19];
    [self addSubview:_slideBtn];
    _slideBtn.layer.cornerRadius = 33 * WID;
    _slideBtn.backgroundColor = [UIColor colorWithHex:0xdddddd];
    [_slideBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.and.left.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(66 * WID, 66 * WID));
    }];
    
    _topLabel = [QJLBaseLabel LabelWithFrame:CGRectZero text:@"dadasf" titleColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter font:[UIFont systemFontOfSize:17]];
    [_bottomLabel addSubview:_topLabel];
    _topLabel.backgroundColor = CUSTOMBLUE;
    _topLabel.layer.cornerRadius = 15;
    _topLabel.clipsToBounds = YES;
    [_topLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.centerY.and.height.equalTo(_bottomLabel);
        make.width.mas_equalTo(0);
    }];
    
    _slideBtn.beginDrag = ^(CGFloat rightBorder) {
        _topLabel.frame = CGRectMake(0, 0, rightBorder, _bottomLabel.frame.size.height);
    };
    
    _slideBtn.endDrag = ^() {
        _topLabel.frame = CGRectMake(0, 0, 0, _bottomLabel.frame.size.height);
    };
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
