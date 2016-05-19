//
//  AreaCell.m
//  YeaLink
//
//  Created by 李根 on 16/4/26.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "AreaCell.h"

@implementation AreaCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createView];
    }
    return self;
}

- (void)createView {
    self.areaLabel = [[QJLBaseLabel alloc] init];
    [self.contentView addSubview:self.areaLabel];
    _areaLabel.font = [UIFont systemFontOfSize:15];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.areaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
        make.edges.equalTo(self.contentView).with.insets(UIEdgeInsetsMake(5 * HEI, 10 * WID, -5 * HEI, -10 * WID));
    }];
    
    
}

@end
