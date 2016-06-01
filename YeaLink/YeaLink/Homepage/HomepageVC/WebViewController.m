//
//  WebViewController.m
//  YeaLink
//
//  Created by 李根 on 16/5/5.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()<UIWebViewDelegate>
//@property(nonatomic, strong)UIWebView *wv;
@property(nonatomic, strong)QJLBaseButton *button;

@end

@implementation WebViewController
{
    NSString *_url;
//    UIActivityIndicatorView *_activView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    _url = [UserInformation userinforSingleton].strURL;
    [self createWebview];
//    NSLog(@"_url: %@", _url);
    
}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 25 * HEI)];
//    [self.view addSubview:view];
//    view.backgroundColor = [UIColor colorWithHex:0xfefefe];
    //  禁止webview的弹跳
//    [(UIScrollView *)[[self.wv subviews] objectAtIndex:0] setBounces:NO];
    
    __weak WebViewController *blockSelf = self;
    //  返回
//    self.back = ^() {
//        [blockSelf.navigationController popToRootViewControllerAnimated:YES];
//    };
    [self settingNavigationbar];
    
    self.backNative = ^() {
        [blockSelf.navigationController popViewControllerAnimated:YES];
    };
    
}

- (void)createWebview {
    [self getHtmlWithstr:_url];
    
    [self.hud hide:YES];
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
    self.backforH5(self.wv);
}

- (void)backAction:(id)sender {
    self.backforH5(self.wv);
}

//- (void)webViewDidFinishLoad:(UIWebView *)webView {
//    [self.hud hide:YES];
//}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self.hud hide:YES];
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
