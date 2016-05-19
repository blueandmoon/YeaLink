//
//  SettingCell.m
//  YeaLink
//
//  Created by 李根 on 16/5/12.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "SettingCell.h"

@implementation SettingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createView];
    }
    return self;
}

- (void)createView {
//    self.contentView.backgroundColor = [UIColor orangeColor];
    
    _titleLabel = [[QJLBaseLabel alloc] init];
    [self.contentView addSubview:_titleLabel];
//    _label.layer.borderWidth = 1;
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(15 * WID);
        make.top.equalTo(self.contentView).with.offset(5 * HEI);
        make.bottom.equalTo(self.contentView).with.offset(-5 * HEI);
        make.width.mas_equalTo(200 * WID);
    }];
    
    _switchButton = [[UISwitch alloc] init];
    [self.contentView addSubview:_switchButton];
    [_switchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).with.offset(-10 * WID);
        make.centerY.equalTo(_titleLabel);
    }];
    _switchButton.hidden = YES;
    _switchButton.on = YES;
    
    _seperatorLine = [[QJLBaseView alloc] init];
    [self.contentView addSubview:_seperatorLine];
    _seperatorLine.layer.borderWidth = 1;
    _seperatorLine.layer.borderColor = [UIColor colorWithRed:205 / 255.0 green:205 / 255.0 blue:205 / 255.0 alpha:1].CGColor;
    [_seperatorLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).with.offset(0);
        make.height.mas_equalTo(0.5 * HEI);
        make.width.equalTo(self.contentView);
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
