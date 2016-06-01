//
//  BlueToothCell.h
//  YeaLink
//
//  Created by 李根 on 16/5/24.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "QJLBaseTableView.h"

@interface BlueToothCell : QJLBaseTableViewCell
@property(nonatomic, strong)QJLBaseImageView *imageview;
@property(nonatomic, strong)QJLBaseLabel *titleLabel;
@property(nonatomic, strong)QJLBaseLabel *statusLabel;

@end
