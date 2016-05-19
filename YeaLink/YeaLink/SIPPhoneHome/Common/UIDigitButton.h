//
//  UIDigitButton.h
//  SDKDemo
//
//  Created by  Tim Lei on 10/21/15.
//  Copyright © 2015 FreeView. All rights reserved.
//

#import "UILongTouchButton.h"

@interface UIDigitButton : UILongTouchButton

@property (nonatomic, strong) IBOutlet UITextField* addressField;
@property char digit;
@property bool dtmf;

@end
