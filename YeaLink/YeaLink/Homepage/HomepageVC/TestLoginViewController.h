//
//  TestLoginViewController.h
//  YeaLink
//
//  Created by 李根 on 16/5/3.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestLoginViewController : UIViewController

@property(nonatomic, strong)UITextField *acctTextField;
@property(nonatomic, strong)UITextField *developerCodeTextField;
@property(nonatomic, strong)UIButton *loginButton;

- (void)loginButtonPressed:(UIButton *)button;




@end
