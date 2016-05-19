//
//  UISwitchViewCell.h
//  SDKDemo
//
//  Created by  Tim Lei on 1/6/16.
//  Copyright © 2016 FreeView. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const  kUISwitchViewCellIdentifier;

@interface UISwitchViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel*   titleLabel;
@property (nonatomic, weak) IBOutlet UISwitch*  switchButton;
@end
