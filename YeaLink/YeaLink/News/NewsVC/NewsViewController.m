//
//  NewsViewController.m
//  YeaLink
//
//  Created by 李根 on 16/4/24.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "NewsViewController.h"

@interface NewsViewController ()

@end

@implementation NewsViewController



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50 * WID, 30 * HEI)];
//    label.text = @"消息";
//    //    label.textColor = [UIColor blueColor];
//    self.navigationItem.titleView = label;
    [self getHtmlWithstr:@"message/message"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [self getHtmlWithUrl:[NSString stringWithFormat:@"%@message/message", COMMONURL]];
    [self settingNavigationbar];
    
    self.backNative = ^() {
        NSLog(@"跑回来了?");
    };
}

- (void)settingNavigationbar {
    QJLBaseLabel *label = [QJLBaseLabel LabelWithFrame:CGRectMake(0, 0, 200 * WID, 30 * HEI) text:@" " titleColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter font:[UIFont systemFontOfSize:19]];
    self.navigationItem.titleView = label;
    self.navigationController.navigationBar.barTintColor = CUSTOMBLUE;
    self.takeStr = ^(NSString *currentTitle) {
        label.text = currentTitle;
    };
    label.numberOfLines = 0;
    [label sizeToFit];
    
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    
    
}

//- (void)back:(id)sender {
//    self.backforH5(self.wv);
//}

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
