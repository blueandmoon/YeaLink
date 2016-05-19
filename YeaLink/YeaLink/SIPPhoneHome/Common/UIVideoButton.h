//
//  UIVideoButton.h
//  SDKDemo
//
//  Created by  Tim Lei on 10/24/15.
//  Copyright © 2015 FreeView. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIToggleButton.h"

@interface UIVideoButton : UIToggleButton <UIToggleButtonDelegate> {
}

@property (nonatomic, strong) IBOutlet UIActivityIndicatorView*  waitView;

@end
