//
//  CityView.m
//  YeaLink
//
//  Created by 李根 on 16/5/26.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "CityView.h"

@implementation CityView

//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    if (point in _bottomView) {
//        <#statements#>
//    }
//}

- (void)createView {
    _bottomView= [[QJLBaseView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self addSubview:_bottomView];
    _bottomView.backgroundColor = [UIColor lightGrayColor];
    
    _imageview = [[QJLBaseImageView alloc] init];
    [_bottomView addSubview:_imageview];
    _imageview.layer.borderWidth = 1;
    [_imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_bottomView);
        make.height.equalTo(_bottomView);
        make.width.equalTo(_imageview.mas_height);
        make.top.equalTo(_bottomView);
    }];
    
    _label = [QJLBaseLabel LabelWithFrame:CGRectZero text:@"苏州市" titleColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter font:[UIFont systemFontOfSize:17]];
    [_bottomView addSubview:_label];
    _label.layer.borderWidth = 1;
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bottomView).with.offset(0);
        make.right.equalTo(_imageview.mas_left).with.offset(0);
        make.height.equalTo(_bottomView);
        make.top.equalTo(_bottomView);
    }];
}

@end
