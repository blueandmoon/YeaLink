//
//  AppDelegate.h
//  YeaLink
//
//  Created by 李根 on 16/4/24.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SIPPhoneHomeViewController.h"

//@class  SIPPhoneHomeViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, weak) SIPPhoneHomeViewController *mainViewController;

@end

