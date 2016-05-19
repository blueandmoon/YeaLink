//
//  UIAddressTextField.m
//  SDKDemo
//
//  Created by  Tim Lei on 10/19/15.
//  Copyright © 2015 FreeView. All rights reserved.
//

#import "UIAddressTextField.h"

@implementation UIAddressTextField

- (void)setText:(NSString *)text {
    [super setText:text];
    [self sendActionsForControlEvents:UIControlEventEditingChanged];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    // disable "define" option, since it messes with the keyboard
    if ([[NSStringFromSelector(action) lowercaseString] rangeOfString:@"define"].location != NSNotFound) {
        return NO;
    } else {
        return [super canPerformAction:action withSender:sender];
    }
}

@end
