//
//  BlueToothCell.m
//  YeaLink
//
//  Created by 李根 on 16/5/24.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "BlueToothCell.h"

@implementation BlueToothCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createView];
    }
    return self;
}

- (void)createView {
    self.imageview = [[QJLBaseImageView alloc] init];
    [self addSubview:self.imageview];
    self.imageView.backgroundColor = CUSTOMBLUE;
//    _imageview.layer.borderWidth = 1;
    _imageview.image = [UIImage imageNamed:@"lock"];
    [self.imageview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).with.offset(15 * WID);
        make.width.mas_equalTo(30 * WID);
        make.top.equalTo(self).with.offset(5 * HEI);
        make.height.mas_equalTo(30 * HEI);
    }];
    
    _titleLabel = [QJLBaseLabel LabelWithFrame:CGRectZero text:@"fdasfdsa" titleColor:[UIColor blackColor] textAlignment:NSTextAlignmentLeft font:[UIFont systemFontOfSize:17]];
    [self addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imageview.mas_right).with.offset(15 * WID);
        make.width.mas_equalTo(150 * WID);
        make.centerY.equalTo(_imageview);
        make.height.equalTo(self.imageview);
    }];
    
    _statusLabel = [QJLBaseLabel LabelWithFrame:CGRectZero text:@"" titleColor:[UIColor lightGrayColor] textAlignment:NSTextAlignmentRight font:[UIFont systemFontOfSize:17]];
    [self addSubview:_statusLabel];
    [_statusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).with.offset(-10 * WID);
        make.width.equalTo(_titleLabel);
        make.centerY.equalTo(_titleLabel);
        make.height.equalTo(_titleLabel);
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
