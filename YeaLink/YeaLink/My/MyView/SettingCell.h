//
//  SettingCell.h
//  YeaLink
//
//  Created by 李根 on 16/5/12.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "QJLBaseTableViewCell.h"

@interface SettingCell : QJLBaseTableViewCell
@property(nonatomic, strong)QJLBaseLabel *titleLabel;
@property(nonatomic, strong)UISwitch *switchButton;
@property(nonatomic, strong)QJLBaseView *seperatorLine;

@end
