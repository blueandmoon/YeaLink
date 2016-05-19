//
//  UISwitchViewCell.m
//  SDKDemo
//
//  Created by  Tim Lei on 1/6/16.
//  Copyright © 2016 FreeView. All rights reserved.
//

#import "UISwitchViewCell.h"

NSString * const  kUISwitchViewCellIdentifier = @"UISwitchViewCellIdentifier";

@implementation UISwitchViewCell

- (void)awakeFromNib {
    // Initialization code
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
