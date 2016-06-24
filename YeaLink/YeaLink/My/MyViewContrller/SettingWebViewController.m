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
    self.navigationController.navigationBar.hidden = NO;
    
    [self getHtmlWithstr:[UserInformation userinforSingleton].strURL];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self settingNavigationbar];
    
    __weak SettingWebViewController *blockSelf = self;
    self.backNative = ^() {
        [blockSelf.navigationController popViewControllerAnimated:YES];
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
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    
    
}

- (void)back:(id)sender {
    __weak SettingWebViewController *blockSelf = self;
    //  h5页面的返回
    self.backforH5 = ^(UIWebView *webview) {
        NSString *Str = [webview stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"gotoPre();"]];
        NSLog(@"jsStr: %@", Str);
        if ([Str isEqualToString:@"a"] || [Str isEqualToString:@"b"]) {
            //            NSLog(@"我该怎么返回!");
        } else {
            //  返回native
            blockSelf.backNative();
        }
    };
    self.backforH5(self.wv);
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
