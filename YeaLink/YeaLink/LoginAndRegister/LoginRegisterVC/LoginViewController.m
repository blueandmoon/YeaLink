//
//  LoginViewController.m
//  YeaLink
//
//  Created by 李根 on 16/4/28.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "ForgetPasswordViewController.h"
#import "SIPLogin.h"

#define LDISTANCE 25 * WID
#define HDISTANCE 25 * HEI

@interface LoginViewController ()<UITextFieldDelegate, UIAlertViewDelegate>
@property(nonatomic, strong)QJLBaseTextfield *phoneNumberTextfield; //  手机号
@property(nonatomic, strong)QJLBaseTextfield *passwordTextfield;    //  密码
@property(nonatomic, strong)QJLBaseButton *loginButton; //  登录
@property(nonatomic, strong)QJLBaseButton *IRegisterBUtton; //  我要注册
@property(nonatomic, strong)QJLBaseButton *forgetPasswordButton;    //  忘记密码
@property(nonatomic, strong)QJLBaseView *segmentView;   //  分割线

@end

@implementation LoginViewController

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setNavigationbar];
    [self getView];
    
}

- (void)setNavigationbar {
    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationController.navigationBar.barTintColor = CUSTOMBLUE;
    QJLBaseLabel *label = [QJLBaseLabel LabelWithFrame:CGRectMake(0, 0, 50, 30) text:@"登录" titleColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter font:[UIFont systemFontOfSize:19]];
    self.navigationItem.titleView = label;
    
}

- (void)getView {
    _phoneNumberTextfield = [[QJLBaseTextfield alloc] init];
    [self.view addSubview:_phoneNumberTextfield];
    _phoneNumberTextfield.placeholder = @"请输入手机号";
    _phoneNumberTextfield.layer.borderColor = BORDERCOLOR.CGColor;
    _phoneNumberTextfield.delegate = self;
    _phoneNumberTextfield.tag = 1000;
    [_phoneNumberTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(LDISTANCE);
        make.right.equalTo(self.view).with.offset(-LDISTANCE);
        make.top.equalTo(self.view).with.offset(HDISTANCE);
        make.height.mas_equalTo(50 * HEI);
    }];
    
    _passwordTextfield = [[QJLBaseTextfield alloc] init];
    [self.view addSubview:_passwordTextfield];
    _passwordTextfield.placeholder = @"请输入密码";
    _passwordTextfield.delegate= self;
    _passwordTextfield.tag= 1001;
    _passwordTextfield.layer.borderColor = BORDERCOLOR.CGColor;
    _passwordTextfield.secureTextEntry = YES;
    [_passwordTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.and.centerX.equalTo(_phoneNumberTextfield);
        make.top.equalTo(_phoneNumberTextfield.mas_bottom).with.offset(HDISTANCE);
    }];
    [_passwordTextfield addTarget:self action:@selector(textChange) forControlEvents:UIControlEventAllEditingEvents];
    
    _loginButton = [QJLBaseButton buttonWithType:UIButtonTypeSystem];
    [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [self.view addSubview:_loginButton];
    [_loginButton setTitleColor:[UIColor colorWithRed:132 / 255.0 green:132 / 255.0 blue:132 / 255.0 alpha:1] forState:UIControlStateNormal];
    _loginButton.backgroundColor = BGCOLOR;
    _loginButton.layer.cornerRadius = 5;
    _loginButton.enabled = NO;
    [_loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.and.centerX.equalTo(_phoneNumberTextfield);
        make.top.equalTo(_passwordTextfield.mas_bottom).with.offset(HDISTANCE);
    }];
    [_loginButton addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _segmentView = [[QJLBaseView alloc] initWithFrame:CGRectMake(187 * WID, 375 * HEI, 1 * WID, 30 * HEI)];
    [self.view addSubview:_segmentView];
    _segmentView.layer.borderColor = BORDERCOLOR.CGColor;
    _segmentView.layer.borderWidth = 2;
    [_segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_phoneNumberTextfield);
        make.top.equalTo(_loginButton.mas_bottom).with.offset(HDISTANCE);
        make.size.mas_equalTo(CGSizeMake(1 * WID, 30 * HEI));
    }];

    _IRegisterBUtton = [QJLBaseButton buttonWithType:UIButtonTypeSystem];
//    _IRegisterBUtton.frame= CGRectMake(107 * WID, 375 * HEI, 75 * WID, 30 * HEI);
    [self.view addSubview:_IRegisterBUtton];
    [_IRegisterBUtton setTitleColor:[UIColor colorWithRed:252 / 255.0 green:105 / 255.0 blue:93 / 255.0 alpha:1] forState:UIControlStateNormal];
    [_IRegisterBUtton setTitle:@"我要注册" forState:UIControlStateNormal];
    _IRegisterBUtton.font = [UIFont systemFontOfSize:15];
    [_IRegisterBUtton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_segmentView.mas_left).with.offset(-5 * WID);
        make.centerY.equalTo(_segmentView);
        make.size.mas_equalTo(CGSizeMake(85 * WID, 30 * HEI));
    }];
    [_IRegisterBUtton addTarget:self action:@selector(registerAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _forgetPasswordButton = [QJLBaseButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:_forgetPasswordButton];
    [_forgetPasswordButton setTitleColor:[UIColor colorWithRed:252 / 255.0 green:105 / 255.0 blue:93 / 255.0 alpha:1] forState:UIControlStateNormal];
    [_forgetPasswordButton setTitle:@"忘记密码?" forState:UIControlStateNormal];
    _forgetPasswordButton.font = [UIFont systemFontOfSize:15];
    [_forgetPasswordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.centerY.equalTo(_IRegisterBUtton);
        make.left.equalTo(_segmentView.mas_right).with.offset(5 * WID);
    }];
    [_forgetPasswordButton addTarget:self action:@selector(forgetPasswordAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
}

- (void)textChange {
    VALUECHANGE(_phoneNumberTextfield, _loginButton);
}

- (void)forgetPasswordAction:(QJLBaseButton *)button {
    
    ForgetPasswordViewController *forgetPasswordVC = [[ForgetPasswordViewController alloc] init];
    [self.navigationController pushViewController:forgetPasswordVC animated:YES];
}

- (void)loginAction:(QJLBaseButton *)button {
    if ([UserInformation userinforSingleton].usermodel.UserID != nil && [[UserInformation userinforSingleton].usermodel.UserID isEqualToString: _phoneNumberTextfield.text]) {
        
        self.afterLoginSuccessToGetHomepageData();
        return;
    }
    
//    NSString *str = @"api/APIUserManage/APPloginByIOS?UserID=13800000001&PassWord=1";
    NSString *str = [NSString stringWithFormat:@"api/APIUserManage/APPloginByIOS?UserID=%@&PassWord=%@", _phoneNumberTextfield.text, [MyMD5 md5:_passwordTextfield.text]];
    NSString *tempStr = [COMMONURL stringByAppendingString:str];
    NSLog(@"login: %@", tempStr);
    [NetWorkingTool getNetWorking:tempStr block:^(id result) {
        NSLog(@"登录code: %@", result[@"code"]);
        if ([result[@"code"] isEqualToString:@"1"]) {
#pragma mark    - 登录成功, 则登录全视通平台
            [SIPLogin loginSIP];
            NSLog(@"登录成功~~~");
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
            //  登录成功则把信息存储本地, 下次自动登录
            [UserInformation saveUserName:_phoneNumberTextfield.text Password:_passwordTextfield.text];
            //  获取用户信息
            [UserInformation questUserInformationWith:_phoneNumberTextfield.text];
            
            //  登录成功请求首页数据
            [UserInformation userinforSingleton].doSomething = ^() {
                self.afterLoginSuccessToGetHomepageData();
            };
            
        } else {
            //            NSLog(@"登录失败");   //  0, 密码错误;    1, 密码正确
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"登录失败" message:@"请输入正确的用户名和密码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alertView show];
        }
    }];
    

}

- (void)registerAction:(QJLBaseButton *)button {
    
    RegisterViewController *registerVC = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:registerVC animated:YES];
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
