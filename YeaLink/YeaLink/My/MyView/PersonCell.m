//
//  PersonCell.m
//  SI
//
//  Created by 李根 on 16/5/11.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "PersonCell.h"

@implementation PersonCell

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
        make.width.equalTo(_iconView.mas_height);
    }];
    
    _label = [[QJLBaseLabel alloc] init];
    [self.contentView addSubview:_label];
//    _label.layer.borderWidth = 1;
    _label.font = [UIFont systemFontOfSize:15];
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(_iconView);
        make.left.equalTo(_iconView.mas_right).with.offset(5 * WID);
        make.right.equalTo(self.contentView).with.offset(-5 * WID);
        make.centerY.equalTo(_iconView);
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
