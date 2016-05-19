//
//  HomepageCell.m
//  YeaLink
//
//  Created by 李根 on 16/4/24.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "HomepageCell.h"

@implementation HomepageCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init {
    if (self = [super init]) {
        [self createView];
    }
    
    return self;
}

- (void)createView {
    //    self.contentView.backgroundColor = [UIColor blackColor];
    self.contentView.layer.borderWidth = 1;
    self.contentView.layer.borderColor = [UIColor colorWithRed:222 / 255.0 green:222 / 255.0 blue:222 / 255.0 alpha:1].CGColor;
    
    self.iconView = [[QJLBaseImageView alloc] init];
    [self.contentView addSubview:self.iconView];
//    self.iconView.layer.borderWidth = 1;
    
    self.label = [[QJLBaseLabel alloc] init];
    [self.contentView addSubview:self.label];
//    self.label.layer.borderWidth = 1;
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.font = [UIFont systemFontOfSize:13];
    self.label.textColor = [UIColor colorWithRed:88 / 255.0 green:88 / 255.0 blue:88 / 255.0 alpha:1];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.contentView).with.offset(10);
//        make.right.equalTo(self.contentView).with.offset(-10);
//        make.top.equalTo(self.contentView).with.offset(5);
//        make.bottom.equalTo(self.label.mas_top).with.offset(-5);
        make.centerX.mas_offset(0);
        make.top.equalTo(self.contentView).with.offset(5 * HEI);
//        make.center.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(50 * WID, 50 * HEI));
        
        
    }];
    
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.contentView).with.offset(10);
//        make.width.equalTo(self.imageview.mas_width);
//        make.top.equalTo(self.imageview.mas_bottom).with.offset(5);
//        make.bottom.equalTo(self.contentView).with.offset(-5);
        
        make.centerX.equalTo(self.iconView.mas_centerX);
        make.top.equalTo(self.iconView.mas_bottom).with.offset(3 * HEI);
        
        
        
    }];
    
    
}



@end
