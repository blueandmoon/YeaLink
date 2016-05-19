//
//  FindViewController.m
//  YeaLink
//
//  Created by 李根 on 16/4/24.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "FindViewController.h"

@interface FindViewController ()<UIWebViewDelegate>

@end

@implementation FindViewController
{
    QJLBaseImageView *imageView;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getHtmlWithstr:@"/find/find"];
//    [self getHtmlWithUrl:[NSString stringWithFormat:@"%@/find/find?UserId=18112572968&ciyyId=1", COMMONURL]];
    self.wv.delegate = self;
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
