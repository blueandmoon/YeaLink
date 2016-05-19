//
//  SetWebViewController.m
//  YeaLink
//
//  Created by 李根 on 16/5/14.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "SetWebViewController.h"

@interface SetWebViewController ()

@end

@implementation SetWebViewController
{
    QJLBaseButton *_button;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
    [self getHtmlWithTotalStr:[UserInformation userinforSingleton].strURL];

    _button = [QJLBaseButton buttonWithType:UIButtonTypeCustom];
    [_button setTitle:@"个人中心" forState:UIControlStateNormal];
    _button.font = [UIFont systemFontOfSize:15];
    //    [_button setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [self.view addSubview:_button];
    [_button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    _button.frame = CGRectMake(50 * WID, 25 * HEI, 70 * WID, 30 * HEI);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor cyanColor];
    

}

- (void)backAction:(QJLBaseButton *)button {
    [self.navigationController popToRootViewControllerAnimated:YES];
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
