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
@property(nonatomic, strong)QJLBaseLabel *label;

@end

@implementation WebViewController
{
    NSString *_url;
//    UIActivityIndicatorView *_activView;
}

- (instancetype)init {
    if (self = [super init]) {

    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.translucent = NO;
    
    _url = [UserInformation userinforSingleton].strURL;
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"selectPhoto"] isEqualToString:@"1"]) {
        [self createWebview];
    }
    
}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"selectPhoto"] isEqualToString:@"1"]) {
        _label.text = nil;
    }

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

    [self settingNavigationbar];
    
    self.backNative = ^() {
        [blockSelf dismissViewControllerAnimated:YES completion:nil];
    };
    
    
}

- (void)createWebview {
    [self getHtmlWithstr:_url];
    
}

- (void)createWebviewWithURL:(NSString *)strURL {
    [self getHtmlWithstr:strURL];
    
}

- (void)settingNavigationbar {
    __weak WebViewController *blockSelf = self;
    _label = [QJLBaseLabel LabelWithFrame:CGRectMake(0, 0, 200 * WID, 30 * HEI) text:@" " titleColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter font:[UIFont systemFontOfSize:19]];
    self.navigationItem.titleView = _label;
    self.navigationController.navigationBar.barTintColor = CUSTOMBLUE;
    self.takeStr = ^(NSString *currentTitle) {
        blockSelf.label.text = currentTitle;
    };
    _label.numberOfLines = 0;
    [_label sizeToFit];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    
    
}

- (void)back:(id)sender {
    __weak WebViewController *blockSelf = self;
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
