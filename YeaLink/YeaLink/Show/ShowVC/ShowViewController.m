//
//  ShowViewController.m
//  YeaLink
//
//  Created by 李根 on 16/4/24.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "ShowViewController.h"

@interface ShowViewController ()

@end

@implementation ShowViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    self.navigationController.navigationBar.hidden = NO;
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50 * WID, 30 * HEI)];
//    label.text = @"秀场";
//    //    label.textColor = [UIColor blueColor];
//    self.navigationItem.titleView = label;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self getHtmlWithstr:@"show/showindex"];
//    [self getHtmlWithUrl:[NSString stringWithFormat:@"%@show/showindex", COMMONURL]];
    
    
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
