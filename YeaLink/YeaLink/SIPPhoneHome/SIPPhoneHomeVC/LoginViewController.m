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
#import "ForgetViewController.h"
#import "SIPLogin.h"

@interface LoginViewController ()<UITextFieldDelegate>
//@property(nonatomic, strong)QJLBaseButton *returnButton;
//@property(nonatomic, strong)QJLBaseButton *userButton;
@property(nonatomic, strong)QJLBaseTextfield *phoneNumberTextfield; //  手机号
@property(nonatomic, strong)QJLBaseTextfield *passwordTextfield;    //  密码
@property(nonatomic, strong)QJLBaseButton *loginButton; //  登录
@property(nonatomic, strong)QJLBaseButton *IRegisterBUtton; //  我要注册
@property(nonatomic, strong)QJLBaseButton *forgetPasswordButton;    //  忘记密码
@property(nonatomic, strong)QJLBaseView *segmentView;   //  分割线

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self getView];
    
}

- (void)getView {
    _phoneNumberTextfield = [[QJLBaseTextfield alloc] initWithFrame:CGRectMake(25 * WID, 125 * HEI, WIDTH - 50 * WID, 50 * HEI)];
    [self.view addSubview:_phoneNumberTextfield];
    _phoneNumberTextfield.placeholder = @"          请输入手机号";
//    _phoneNumberTextfield.backgroundColor = [UIColor colorWithRed:220 / 255.0 green:223 / 255.0 blue:169 / 255.0 alpha:1];
    
    _phoneNumberTextfield.layer.borderColor = [UIColor colorWithRed:209 / 255.0 green:209 / 255.0 blue:209 / 255.0 alpha:1].CGColor;
    _phoneNumberTextfield.delegate = self;
    _phoneNumberTextfield.tag = 1;
    
    _passwordTextfield = [[QJLBaseTextfield alloc] initWithFrame:CGRectMake(25 * WID, 200 * HEI, WIDTH - 50 * HEI, 50 * HEI)];
    [self.view addSubview:_passwordTextfield];
    _passwordTextfield.placeholder = @"         请输入密码";
    _passwordTextfield.delegate= self;
    _passwordTextfield.tag= 2;
    _passwordTextfield.layer.borderColor = [UIColor colorWithRed:209 / 255.0 green:209 / 255.0 blue:209 / 255.0 alpha:1].CGColor;
    _passwordTextfield.secureTextEntry = YES;
    
    _loginButton = [QJLBaseButton buttonWithType:UIButtonTypeSystem];
    _loginButton.frame = CGRectMake(25 * WID, 275 * HEI, WIDTH - 50 * WID, 50 * HEI);
    [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [self.view addSubview:_loginButton];
    [_loginButton setTitleColor:[UIColor colorWithRed:132 / 255.0 green:132 / 255.0 blue:132 / 255.0 alpha:1] forState:UIControlStateNormal];
    _loginButton.backgroundColor = [UIColor colorWithRed:221 / 255.0 green:221 / 255.0 blue:221 / 255.0 alpha:1];
    _loginButton.layer.cornerRadius = 10;
    [_loginButton addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _IRegisterBUtton = [QJLBaseButton buttonWithType:UIButtonTypeSystem];
    _IRegisterBUtton.frame= CGRectMake(107 * WID, 375 * HEI, 75 * WID, 30 * HEI);
    [self.view addSubview:_IRegisterBUtton];
    [_IRegisterBUtton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_IRegisterBUtton setTitle:@"我要注册" forState:UIControlStateNormal];
    _IRegisterBUtton.font = [UIFont systemFontOfSize:15];
    [_IRegisterBUtton addTarget:self action:@selector(registerAction:) forControlEvents:UIControlEventTouchUpInside];
    
    _segmentView = [[QJLBaseView alloc] initWithFrame:CGRectMake(187 * WID, 375 * HEI, 1 * WID, 30 * HEI)];
    [self.view addSubview:_segmentView];
    _segmentView.layer.borderColor = [UIColor redColor].CGColor;
    _segmentView.layer.borderWidth = 2;
    
    _forgetPasswordButton = [QJLBaseButton buttonWithType:UIButtonTypeSystem];
    _forgetPasswordButton.frame= CGRectMake(193 * WID, 375 * HEI, 85 * WID, 30 * HEI);
    [self.view addSubview:_forgetPasswordButton];
    [_forgetPasswordButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_forgetPasswordButton setTitle:@"忘记密码?" forState:UIControlStateNormal];
    _forgetPasswordButton.font = [UIFont systemFontOfSize:15];
    [_forgetPasswordButton addTarget:self action:@selector(forgetPasswordAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
}
- (void)forgetPasswordAction:(QJLBaseButton *)button {
    ForgetViewController *forgetVC = [[ForgetViewController alloc] init];
    forgetVC.strURL = [NSString stringWithFormat:@"%@personalcenter/updatepassword", COMMONURL];
    
    [self presentViewController:forgetVC animated:YES completion:^{
        
    }];
}

- (void)loginAction:(QJLBaseButton *)button {
//    NSString *str = @"api/APIUserManage/APPloginByIOS?UserID=13800000001&PassWord=1";
    NSString *str = [NSString stringWithFormat:@"api/APIUserManage/APPloginByIOS?UserID=%@&PassWord=%@", _phoneNumberTextfield.text, [MyMD5 md5:_passwordTextfield.text]];
    NSString *tempStr = [COMMONURL stringByAppendingString:str];
    NSLog(@"%@", tempStr);
    [NetWorkingTool getNetWorking:tempStr block:^(id result) {
        NSLog(@"登录code: %@", result[@"code"]);
        if ([result[@"code"] isEqualToString:@"1"]) {
#pragma mark    - 登录成功, 则登录全视通平台
            [SIPLogin loginSIP];
            
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];
            
            //  登录成功则把信息存储本地, 下次自动登录
            NSUserDefaults *userdefau = [NSUserDefaults standardUserDefaults];
            [userdefau setObject:_phoneNumberTextfield.text forKey:@"UserName"];
            [userdefau setObject:[MyMD5 md5:_passwordTextfield.text] forKey:@"Password"];
            
            //  接收用户信息
            //  http://qianjiale.doggadatachina.com/api/APIUserManage/ShowUserInfo?UserID=18112572968
            NSString *strURL = [NSString stringWithFormat:@"%@api/APIUserManage/ShowUserInfo?UserID=%@", COMMONURL, _phoneNumberTextfield.text];
            NSLog(@"strURL: %@",strURL);
            [NetWorkingTool getNetWorking:strURL block:^(id result) {
                UserInformation *userInfor = [UserInformation userinforSingleton];
                NSArray *arr = [UserModel baseModelByArray:result[@"list"]];
                userInfor.usermodel = arr[0];
                NSLog(@"userInfor.usermodel.UserID: %@", userInfor.usermodel.UserID);
            }];
            
            
        } else {
            //            NSLog(@"登录失败");   //  0, 密码错误;    1, 密码正确
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"登录失败" message:@"请输入正确的用户名和密码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alertView show];
        }
    }];
    

}

- (void)registerAction:(QJLBaseButton *)button {
    RegisterViewController *registerVC = [[RegisterViewController alloc] init];
    [self presentViewController:registerVC animated:YES completion:^{
       
    }];
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
