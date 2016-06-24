//
//  ShareButton.m
//  YeaLink
//
//  Created by 李根 on 16/6/17.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "ShareButton.h"

@implementation ShareButton

- (void)createView {
    _topBtn = [[QJLBaseButton alloc] init];
    [self addSubview:_topBtn];
    [_topBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.top.and.right.equalTo(self);
        make.height.mas_equalTo(self.mas_width);
    }];
    
    _downLabel = [[QJLBaseLabel alloc] init];
    [self addSubview:_downLabel];
    _downLabel.textAlignment = NSTextAlignmentCenter;
    _downLabel.textColor = [UIColor colorWithHex:0x333333];
    _downLabel.font = [UIFont systemFontOfSize:14];
    [_downLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topBtn.mas_bottom).with.offset(5 * HEI);
        make.left.equalTo(self).with.offset(5 * WID);
        make.right.equalTo(self).with.offset(-5 * WID);
        
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
