//
//  UIEraseButton.h
//  SDKDemo
//
//  Created by  Tim Lei on 10/24/15.
//  Copyright © 2015 FreeView. All rights reserved.
//

#import "UILongTouchButton.h"

@interface UIEraseButton : UILongTouchButton<UILongTouchButtonDelegate> 
@property (nonatomic, weak) IBOutlet UITextField* addressField;
@end
