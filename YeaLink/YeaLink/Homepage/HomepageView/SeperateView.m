//
//  SeperateView.m
//  YeaLink
//
//  Created by 李根 on 16/6/8.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "SeperateView.h"

@implementation SeperateView
{
    QJLBaseView *_lineView;
    QJLBaseLabel *_shareLabel;
}
- (void)createView {
    _lineView = [[QJLBaseView alloc] init];
    [self addSubview:_lineView];
    _lineView.layer.borderColor = [UIColor colorWithHex:0xdddddd].CGColor;
    _lineView.layer.borderWidth = 1.0;
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.centerX.and.centerY.equalTo(self);
        make.height.mas_equalTo(0.5 * HEI);
    }];
    
    _shareLabel = [QJLBaseLabel LabelWithFrame:CGRectZero text:@"分享到" titleColor:[UIColor colorWithHex:0xdddddd] textAlignment:NSTextAlignmentCenter font:[UIFont systemFontOfSize:15]];
    [self addSubview:_shareLabel];
    _shareLabel.backgroundColor = [UIColor whiteColor];
    [_shareLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.width.mas_equalTo(70 * WID);
        make.height.mas_equalTo(15 * HEI);
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
