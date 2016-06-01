//
//  ShowViewController.m
//  YeaLink
//
//  Created by 李根 on 16/4/24.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "ShowViewController.h"
#import "ShowWebViewController.h"

@interface ShowViewController ()

@end

@implementation ShowViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50 * WID, 30 * HEI)];
//    label.text = @"秀场";
//    //    label.textColor = [UIColor blueColor];
//    self.navigationItem.titleView = label;
    [self getHtmlWithstr:@"show/showindex"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self settingNavigationbar];
    
    self.backNative = ^() {
        
    };
    
}

- (void)settingNavigationbar {
    QJLBaseLabel *label = [QJLBaseLabel LabelWithFrame:CGRectMake(0, 0, 200 * WID, 30 * HEI) text:@"秀场" titleColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter font:[UIFont systemFontOfSize:19]];
    self.navigationItem.titleView = label;
    self.navigationController.navigationBar.barTintColor = CUSTOMBLUE;
    self.takeStr = ^(NSString *currentTitle) {
        label.text = currentTitle;
    };
    label.numberOfLines = 0;
    [label sizeToFit];
    
    __weak ShowViewController *blockSelf = self;
    self.changeShowLeftButton = ^(NSString *typeStr) {
        if ([typeStr rangeOfString:@"showindex?"].location != NSNotFound) {
            //  在秀场主页面
            blockSelf.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"camera"] style:UIBarButtonItemStylePlain target:self action:@selector(leftAction:)];
        } else {
            blockSelf.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
        }
    };
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"camera"] style:UIBarButtonItemStylePlain target:self action:@selector(leftAction:)];
    
}

- (void)back:(id)sender {
    self.backforH5(self.wv);
}

- (void)leftAction:(id)sender {
    //  Show/SendShowWords
    [UserInformation userinforSingleton].strURL = @"Show/SendShowWords";
    ShowWebViewController *showWebVC = [[ShowWebViewController alloc] init];
    [self.navigationController pushViewController:showWebVC animated:YES];
//    [self presentViewController:findWebVC animated:YES completion:^{
//        
//    }];
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
