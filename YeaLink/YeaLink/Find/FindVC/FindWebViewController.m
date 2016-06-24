//
//  FindWebViewController.m
//  YeaLink
//
//  Created by 李根 on 16/5/23.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "FindWebViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface FindWebViewController ()

@end

@implementation FindWebViewController
{
    QJLBaseButton *_btn;    //  返回按钮
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"selectPhoto"] isEqualToString:@"1"]) {
        [self getHtmlWithstr:[UserInformation userinforSingleton].strURL];
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self settingNavigationbar];
    
    __weak FindWebViewController *blockSelf = self;
    self.backNative = ^() {
        [blockSelf.navigationController popViewControllerAnimated:YES];
    };
    
}

- (void)settingNavigationbar {
    QJLBaseLabel *label = [QJLBaseLabel LabelWithFrame:CGRectMake(0, 0, 200 * WID, 30 * HEI) text:@"搜索" titleColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter font:[UIFont systemFontOfSize:19]];
    self.navigationItem.titleView = label;
    self.navigationController.navigationBar.barTintColor = CUSTOMBLUE;
    self.takeStr = ^(NSString *currentTitle) {
        label.text = currentTitle;
    };
    label.numberOfLines = 0;
    [label sizeToFit];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
    
    self.changeShowLeftButton = ^(NSString *str) {
        
    };
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
