//
//  SettingViewController.m
//  YeaLink
//
//  Created by 李根 on 16/5/12.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingView.h"
#import "LoginViewController.h"
#import "SettingWebViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController
{
    SettingView *_settingview;
    QJLBaseButton *_logOffButton;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self settingNavigationbar];
    [self questData];
    [self getValue];
    [self getView];
}

- (void)settingNavigationbar {
    QJLBaseLabel *label = [QJLBaseLabel LabelWithFrame:CGRectMake(0, 0, 50 * WID, 30 * HEI) text:@"设置" titleColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter font:[UIFont systemFontOfSize:19]];
    self.navigationItem.titleView = label;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
}

- (void)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    //  调用刷新数据
    self.refreshData();
}

- (void)questData {
    
}

- (void)getValue {
    _settingview = [[SettingView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 350 * HEI)];
    [self.view addSubview:_settingview];
    
    [self createLogOffButton];
}

- (void)getView {
    __weak SettingViewController *blockSelf = self;
    SettingWebViewController *settingVC = [[SettingWebViewController alloc] init];
    _settingview.push = ^() {
//        NSLog(@"点击了");
        [blockSelf.navigationController pushViewController:settingVC animated:YES];
    };
}

- (void)createLogOffButton {
    _logOffButton = [QJLBaseButton buttonCustomFrame:CGRectZero title:@"切换账号" currentTitleColor:[UIColor whiteColor]];
//    _logOffButton.layer.borderWidth = 1;
    _logOffButton.layer.cornerRadius = 10;
    [self.view addSubview:_logOffButton];
    _logOffButton.backgroundColor = [UIColor colorWithRed:250 / 255.0 green:110 / 255.0 blue:94 / 255.0 alpha:1];
    [_logOffButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_settingview.mas_bottom).with.offset(20 * HEI);
        make.left.equalTo(self.view).with.offset(30 * WID);
        make.right.equalTo(self.view).with.offset(-30 * WID);
        make.height.mas_equalTo(50 * HEI);
    }];
    [_logOffButton addTarget:self action:@selector(logOffAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)logOffAction {
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    [self.navigationController pushViewController:loginVC animated:YES];
    
    loginVC.afterLoginSuccessToGetHomepageData = ^() {
        //  切换账号, 要刷新数据
//        NSLog(@"哈哈哈, 我就不刷新数据, 你能咋地");
        [self.navigationController popViewControllerAnimated:YES];
        
    };
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
