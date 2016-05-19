//
//  UILongTouchButton.h
//  SDKDemo
//
//  Created by  Tim Lei on 10/21/15.
//  Copyright © 2015 FreeView. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UILongTouchButtonDelegate
-(void) onRepeatTouch;
-(void) onLongTouch;
@end

@interface UILongTouchButton : UIButton <UILongTouchButtonDelegate>


@end
