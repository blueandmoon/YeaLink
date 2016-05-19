//
//  UserCell.m
//  SI
//
//  Created by 李根 on 16/5/11.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "UserCell.h"

@implementation UserCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createView];
    }
    return self;
}

- (void)createView {
    _iconView = [[QJLBaseImageView alloc] init];
    [self.contentView addSubview:_iconView];
//    _iconView.layer.borderWidth = 1;
    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).with.offset(10 * WID);
        make.top.equalTo(self.contentView).with.offset(5 * HEI);
        make.bottom.equalTo(self.contentView).with.offset(-5 * HEI);
        make.width.mas_equalTo(_iconView.mas_height);
    }];
    
    _titlelabel = [[QJLBaseLabel alloc] init];
    [self.contentView addSubview:_titlelabel];
//    _titlelabel.layer.borderWidth = 1;
    [_titlelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconView.mas_right).with.offset(5 * WID);
        make.right.equalTo(self.contentView).with.offset(-5 * WID);
        make.top.equalTo(self.contentView).with.offset(5 * HEI);
        make.bottom.equalTo(self.contentView.mas_centerY).with.offset(-3 * HEI);
//        make.bottom.equalTo(_addressLabel.mas_top).with.offset(3 * HEI);
    }];
    
    _addressLabel = [[QJLBaseLabel alloc] init];
    [self.contentView addSubview:_addressLabel];
//    _addressLabel.layer.borderWidth = 1;
    [_addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconView.mas_right).with.offset(5 * WID);
        make.width.mas_equalTo(_titlelabel.mas_width);
        make.top.equalTo(self.contentView.mas_centerY).with.offset(3 * HEI);
        make.bottom.equalTo(self.contentView).with.offset(-5 * HEI);
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
