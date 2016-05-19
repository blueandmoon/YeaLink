//
//  RemoteCell.m
//  YeaLink
//
//  Created by 李根 on 16/4/26.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "RemoteCell.h"

@implementation RemoteCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self= [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createView];
    }
    return self;
}

- (void)createView {
//    self.iconImageView = [[QJLBaseImageView alloc] init];
//    [self.contentView addSubview:self.iconImageView];
//    _iconImageView.layer.borderWidth = 1;
    
    self.doorLabel = [[QJLBaseLabel alloc] init];
    [self.contentView addSubview:self.doorLabel];
//    _doorLabel.layer.borderWidth = 1;
    _doorLabel.font = [UIFont systemFontOfSize:15];
    _doorLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
//    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(self.contentView);
//        make.left.equalTo(self.contentView).with.offset(10 * WID);
////        make.size.mas_equalTo(CGSizeMake(20 * WID, 20 * HEI));
//        make.top.equalTo(self.contentView).with.offset(5 * HEI);
//        make.bottom.equalTo(self.contentView).with.offset(-5 * HEI);
//        make.width.mas_equalTo(30 * WID);
//    }];
    
    [self.doorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(5 * HEI, 10 * WID, -5 * HEI, -10 * WID));
    }];
    
    
}

@end
