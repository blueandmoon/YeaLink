//
//  SettingWebViewController.m
//  YeaLink
//
//  Created by 李根 on 16/5/16.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "SettingWebViewController.h"

@interface SettingWebViewController ()

@end

@implementation SettingWebViewController
{
    QJLBaseButton *_button;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
    [self getHtmlWithstr:[UserInformation userinforSingleton].strURL];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    _button = [QJLBaseButton buttonWithType:UIButtonTypeSystem];
    [_button setTitle:@"设置" forState:UIControlStateNormal];
    //    [_button setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [self.view addSubview:_button];
    [_button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    _button.frame = CGRectMake(50 * WID, 25 * HEI, 50 * WID, 30 * HEI);
}

- (void)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
