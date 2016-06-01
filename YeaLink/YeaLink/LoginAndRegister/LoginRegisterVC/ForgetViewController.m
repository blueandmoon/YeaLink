//
//  ForgetViewController.m
//  YeaLink
//
//  Created by 李根 on 16/5/6.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "ForgetViewController.h"

@interface ForgetViewController ()
@property(nonatomic, strong)QJLBaseButton *backButton;

@end

@implementation ForgetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self getHtmlWithUrl:_strURL];
//    NSLog(@"strURL: %@", _strURL);
    [self getHtmlWithstr:@"/personalcenter/updatepassword"];
    _backButton = [QJLBaseButton buttonWithType:UIButtonTypeCustom];
    _backButton.frame = CGRectMake(10, 10, 30, 30);
    [self.view addSubview:_backButton];
    //    _backButton.layer.borderWidth = 1;
    
    [_backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)backAction:(QJLBaseButton *)button {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
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
