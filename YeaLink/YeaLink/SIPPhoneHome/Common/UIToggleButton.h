//
//  UIToggleButton.h
//  SDKDemo
//
//  Created by  Tim Lei on 10/24/15.
//  Copyright © 2015 FreeView. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UIToggleButtonDelegate
- (void)onOn;
- (void)onOff;
- (bool)onUpdate;
@end

@interface UIToggleButton : UIButton <UIToggleButtonDelegate> {
}

- (bool)update;
- (void)setOn;
- (void)setOff;
- (bool)toggle;
@end
