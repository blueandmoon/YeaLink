//
//  BaseWebViewController.m
//  YeaLink
//
//  Created by 李根 on 16/5/6.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "BaseWebViewController.h"
#import "CustomURLCache.h"  //  缓存
#import <JavaScriptCore/JavaScriptCore.h>
#import "UserModel.h"

#import "WebViewJavascriptBridge.h"

@interface BaseWebViewController ()<UIWebViewDelegate>
@property(nonatomic, strong)WebViewJavascriptBridge *bridge;

@end

@implementation BaseWebViewController

- (instancetype)init {
    if (self == [super init]) {
//        self.bgImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"start_icon375"]];
//        [self.view addSubview:self.bgImageView];
//        self.bgImageView.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
//        self.bgImageView.hidden = NO;
        self.hud = [BaseProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = YES;
//    self.bgImageView.hidden = YES;
    if (_bridge) { return; }
    
    [WebViewJavascriptBridge enableLogging];
    
    _bridge = [WebViewJavascriptBridge bridgeForWebView:_wv];
    
    [_bridge registerHandler:@"testObjcCallback" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"-----testObjcCallback called: %@", data);
        responseCallback(@"Response from testObjcCallback");
    }];
    
    [_bridge callHandler:@"testJavascriptHandler" data:@{ @"foo":@"before ready" }];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = YES;
    
//    //  缓存webview
//    CustomURLCache *urlCache = [[CustomURLCache alloc] initWithMemoryCapacity:20 * 1024 * 1024 diskCapacity:200 * 1024 * 1024 diskPath:nil cacheTime:0];
//    [CustomURLCache setSharedURLCache:urlCache];
    
    _wv = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    [self.view addSubview:_wv];
    _wv.delegate = self;
    
//    self.bgImageView = [[QJLBaseImageView alloc] initWithImage:[UIImage imageNamed:@"start_icon375"]];
//    self.bgImageView.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
//    [self.view addSubview:self.bgImageView];
//    self.bgImageView.hidden = NO;
    
    
    
}
//  &cityName=苏州市&latitude=13.2345&lontitude=12.35436
- (void)getHtmlWithstr:(NSString *)str {
    UserModel *model = [[UserModel alloc] init];
    model = [UserInformation userinforSingleton].usermodel;
    NSString *tempStr = [NSString stringWithFormat:@"%@%@?UserID=%@&CityID=%@", COMMONURL, str, model.UserID,model.CityID];
    NSLog(@"%@", tempStr);
    [_wv loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:tempStr]]];
}

- (void)getHtmlWithTotalStr:(NSString *)totalStr {
    UserModel *model = [[UserModel alloc] init];
    model = [UserInformation userinforSingleton].usermodel;
    NSString *tempStr = [NSString stringWithFormat:@"%@?%@", totalStr, model.UserID];
    NSLog(@"%@", totalStr);
    [_wv loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:tempStr]]];
}

- (void)getHtmlWithUrl:(NSString *)url {
    [_wv loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
//    self.bgImageView.hidden = YES;
    UserModel *model = [[UserModel alloc] init];
    model = [UserInformation userinforSingleton].usermodel;
    [_wv stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"UserFromiOS('%@','%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@');", model.APPUserRole, model.CityID, model.Email, model.HeadThumbPath, model.ImageID, model.NickName, model.OwnerId, model.UserID, model.VName]];
    
    [self.hud hide:YES];
    [self.hud setHidden:YES];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
//    NSString *jsStr = [_wv stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"UserFromiOS('%@','%@', '%@', '%@', '%@', '%@', '%@', '%@', '%@');", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9"]];
    
//    self.bgImageView.hidden = YES;
    [self.hud hide:YES];
    [self.hud setHidden:YES];
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    self.hud = [BaseProgressHUD showHUDAddedTo:self.view animated:YES];
    [self.hud show:YES];
    self.hud.labelText = @"loading...";
}

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
