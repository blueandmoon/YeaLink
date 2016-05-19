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
    self.navigationController.navigationBar.hidden = YES;
    _url = [UserInformation userinforSingleton].strURL;
    [self createWebview];
//    NSLog(@"_url: %@", _url);
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor orangeColor];
    
    _button = [QJLBaseButton buttonWithType:UIButtonTypeSystem];
    [_button setTitle:@"首页" forState:UIControlStateNormal];
//    [_button setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [self.view addSubview:_button];
    [_button setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    
//    _activView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    [self.view addSubview:_activView];
//    _activView.center = self.view.center;
//    _activView.color = [UIColor blackColor];
//    [_activView startAnimating];
}

- (void)createWebview {
    NSString *str = [_url substringFromIndex:35];
    [self getHtmlWithstr:str];
    _button.frame = CGRectMake(50 * WID, 25 * HEI, 50 * WID, 30 * HEI);
    
//    self.bgImageView.hidden = YES;
//    [_activView stopAnimating];
//    [_activView setHidesWhenStopped:YES];
    
    [self.hud hide:YES];
}

- (void)backAction:(QJLBaseButton *)button {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.hud hide:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self.hud hide:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = NO;
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
