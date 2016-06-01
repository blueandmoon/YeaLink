//
//  upAndDownView.m
//  YeaLink
//
//  Created by 李根 on 16/5/28.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "upAndDownView.h"

@implementation upAndDownView
{
//    QJLBaseView *_bottomView;
    QJLBaseImageView *_imageView;
    QJLBaseLabel *_label;
}
- (void)createView {
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [UIColor colorWithHex:0xdddddd].CGColor;
    
//    _iconButton = [[QJLBaseImageView alloc] init];
//    [self addSubview:_iconView];
//    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(self);
//        make.size.mas_equalTo(CGSizeMake(41 * WID, 41 * HEI));
//    }];
//    
//    _label = [QJLBaseLabel LabelWithFrame:CGRectZero text:nil titleColor:[UIColor colorWithHex:0x666666] textAlignment:NSTextAlignmentCenter font:[UIFont systemFontOfSize:15]];
//    [self addSubview:_label];
//    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(_iconView);
//        make.width.mas_equalTo(_iconView);
//        make.top.equalTo(_iconView.mas_bottom).with.offset(5);
//        make.height.mas_equalTo(15 * HEI);
//    }];
    
}



@end
