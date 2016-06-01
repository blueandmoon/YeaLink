//
//  LeftView.m
//  YeaLink
//
//  Created by 李根 on 16/5/30.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "LeftView.h"

@implementation LeftView

- (void)createView {
    self.backgroundColor = CUSTOMBLUE;
    
    _iconView = [[QJLBaseImageView alloc] init];
    [self addSubview:_iconView];
    _iconView.image = [UIImage imageNamed:@"Local32"];
//    _iconView.backgroundColor = [UIColor grayColor];
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.and.centerY.and.right.equalTo(self);
        make.width.mas_equalTo(_iconView.mas_height);
    }];
    
    _label = [QJLBaseLabel LabelWithFrame:CGRectZero text:@"切换市" titleColor:[UIColor whiteColor] textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:15]];
    [self addSubview:_label];
    [_label sizeToFit];
//    _label.backgroundColor = [UIColor redColor];
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.and.height.and.left.equalTo(self);
        make.right.equalTo(_iconView.mas_left).with.offset(0);
    }];
    
    self.userInteractionEnabled = YES;
    _iconView.userInteractionEnabled = YES;
    _label.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    
    //  把superView的userInteractionEnabled打开, 子视图的关闭, 即可只响应superVIew的手势方法
    [self addGestureRecognizer:tap];
//    [_iconView addGestureRecognizer:tap];
//    [_label addGestureRecognizer:tap];
}

- (void)tap:(id)sender {
//    NSLog(@"daf");
    _tapAction();
}

@end
