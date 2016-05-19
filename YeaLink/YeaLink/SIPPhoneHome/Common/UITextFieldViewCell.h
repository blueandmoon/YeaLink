//
//  UITextFieldViewCell.h
//  SDKDemo
//
//  Created by  Tim Lei on 1/7/16.
//  Copyright © 2016 FreeView. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const kTextFieldCellIdentifier;

@interface UITextFieldViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel*    titleLabel;
@property (nonatomic, weak) IBOutlet UITextField*   textField;
@end
