//
//  UserCell.h
//  SI
//
//  Created by 李根 on 16/5/11.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "QJLBaseTableViewCell.h"

@interface UserCell : QJLBaseTableViewCell
@property(nonatomic, strong)QJLBaseImageView *iconView;
@property(nonatomic, strong)QJLBaseLabel *titlelabel;
@property(nonatomic, strong)QJLBaseLabel *addressLabel;

@end
