//
//  ForgetPasswordViewController.m
//  YeaLink
//
//  Created by 李根 on 16/4/29.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "ForgetPasswordViewController.h"

#define LDISTANCE 25 * WID
#define HDISTANCE 25 * HEI

@interface ForgetPasswordViewController ()
@property(nonatomic, strong)QJLBaseTextfield *phoneTextfield;
@property(nonatomic, strong)QJLBaseButton *getVerifycodeButton;
@property(nonatomic, strong)QJLBaseTextfield *verifyTextfield;
@property(nonatomic, strong)QJLBaseButton *nextButton;
@property(nonatomic, strong)QJLBaseView *tempView;
@property(nonatomic, strong)QJLBaseTextfield *passwordTextfield;
@property(nonatomic, strong)QJLBaseTextfield *confirmPasswordTextfield;
@property(nonatomic, strong)QJLBaseButton *submitButton;

@end

@implementation ForgetPasswordViewController
{
    NSTimer *_timer;    //  延时一分钟, 才能再次发送验证码
    NSString *_mes; //  弹出框展示的信息
}

- (void)viewWillDisappear:(BOOL)animated {
    [_getVerifycodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_getVerifycodeButton setEnabled:YES];
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setNavigationbar];
    [self getView];
}

- (void)getView {
    _phoneTextfield = [[QJLBaseTextfield  alloc] init];
    [self.view addSubview:_phoneTextfield];
    _phoneTextfield.placeholder = @"请输入您的手机号码";
    _phoneTextfield.layer.borderColor = BORDERCOLOR.CGColor;
    [_phoneTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(HDISTANCE);
        make.left.equalTo(self.view).with.offset(LDISTANCE);
        make.size.mas_equalTo(CGSizeMake(230 * WID, 50 * HEI));
    }];
    [_phoneTextfield addTarget:self action:@selector(phoneFieldValueChange) forControlEvents:UIControlEventAllEditingEvents];
    
    _getVerifycodeButton = [QJLBaseButton buttonWithType:UIButtonTypeSystem];
    _getVerifycodeButton.frame = CGRectMake(260 * WID, 100 * HEI, 90 * WID, 50 * HEI);
    [self.view addSubview:_getVerifycodeButton];
    [_getVerifycodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    _getVerifycodeButton.backgroundColor = BGCOLOR;
    [_getVerifycodeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _getVerifycodeButton.layer.cornerRadius = 5;
    _getVerifycodeButton.enabled = NO;
    [_getVerifycodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.and.height.equalTo(_phoneTextfield);
        make.left.equalTo(_phoneTextfield.mas_right).with.offset(5 * WID);
        make.right.equalTo(self.view).with.offset(-LDISTANCE);
    }];
    [_getVerifycodeButton addTarget:self action:@selector(getVerificationCode:) forControlEvents:UIControlEventTouchUpInside];
    
    self.verifyTextfield = [[QJLBaseTextfield alloc] init];
    [self.view addSubview:self.verifyTextfield];
    self.verifyTextfield.placeholder = @"请输入您的验证码";
    self.verifyTextfield.layer.borderColor = BORDERCOLOR.CGColor;
    [_verifyTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(LDISTANCE);
        make.right.equalTo(self.view).with.offset(-LDISTANCE);
        make.height.equalTo(_phoneTextfield);
        make.top.equalTo(_phoneTextfield.mas_bottom).with.offset(HDISTANCE);
    }];
    [_verifyTextfield addTarget:self action:@selector(verifyValueChange) forControlEvents:UIControlEventAllEditingEvents];
    
    _nextButton = [QJLBaseButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:_nextButton];
    [_nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [_nextButton setTitleColor:[UIColor colorWithRed:130 / 255.0 green:130 / 255.0 blue:130 / 255.0 alpha:1] forState:UIControlStateNormal];
    _nextButton.backgroundColor = BGCOLOR;
    _nextButton.layer.cornerRadius = 5;
    _nextButton.enabled = NO;
    [_nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.and.centerX.equalTo(_verifyTextfield);
        make.top.equalTo(_verifyTextfield.mas_bottom).with.offset(HDISTANCE);
    }];
    [_nextButton addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //  过度页面
    _tempView = [[QJLBaseView alloc] initWithFrame:CGRectMake(WIDTH, 0, WIDTH, HEIGHT)];
    [self.view addSubview:_tempView];
    _tempView.backgroundColor = [UIColor whiteColor];
    
    _passwordTextfield = [[QJLBaseTextfield alloc] init];
    [_tempView addSubview:_passwordTextfield];
    _passwordTextfield.placeholder = @"请输入6 - 16位的密码";
    _passwordTextfield.layer.borderWidth = 1;
    _passwordTextfield.layer.borderColor = BORDERCOLOR.CGColor;
    _passwordTextfield.secureTextEntry = YES;
    [_passwordTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(_verifyTextfield);
        make.centerX.equalTo(_tempView);
        make.top.equalTo(_tempView).with.offset(HDISTANCE);
    }];
    
    _confirmPasswordTextfield = [[QJLBaseTextfield alloc] init];
    [_tempView addSubview:_confirmPasswordTextfield];
    _confirmPasswordTextfield.placeholder = @"请输入6 - 16位的确认密码";
    _confirmPasswordTextfield.layer.borderWidth = 1;
    _confirmPasswordTextfield.layer.borderColor = BORDERCOLOR.CGColor;
    _confirmPasswordTextfield.secureTextEntry = YES;
    [_confirmPasswordTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.and.centerX.equalTo(_passwordTextfield);
        make.top.equalTo(_passwordTextfield.mas_bottom).with.offset(HDISTANCE);
    }];
    [_confirmPasswordTextfield addTarget:self action:@selector(confirmValueChange) forControlEvents:UIControlEventAllEditingEvents];
    
    _submitButton = [[QJLBaseButton alloc] init];
    [_tempView addSubview:_submitButton];
    [_submitButton setTitle:@"提交" forState:UIControlStateNormal];
    _submitButton.backgroundColor = BGCOLOR;
    [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _submitButton.layer.cornerRadius = 5;
    _submitButton.enabled = NO;
    [_submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.and.centerX.equalTo(_passwordTextfield);
        make.top.equalTo(_confirmPasswordTextfield.mas_bottom).with.offset(HDISTANCE);
    }];
    [_submitButton addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
}

- (void)setNavigationbar {
    QJLBaseLabel *label = [QJLBaseLabel LabelWithFrame:CGRectMake(0, 0, 100, 30) text:@"忘记密码" titleColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter font:[UIFont systemFontOfSize:19]];
    self.navigationItem.titleView = label;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
}

- (void)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)submitAction:(QJLBaseButton *)button {
    if ([_passwordTextfield.text isEqualToString:_confirmPasswordTextfield.text]) {
        //  http://qianjiale.doggadatachina.com/api/APIUserManage/APPResetPassWord?UserID=18112572968&NewPassword=e10adc3949ba59abbe56e057f20f883e
        NSString *tempStr = [NSString stringWithFormat:@"%@api/APIUserManage/APPResetPassWord?UserID=%@&NewPassword=%@", COMMONURL, _phoneTextfield.text, [MyMD5 md5:_passwordTextfield.text]];
        [NetWorkingTool getNetWorking:tempStr block:^(id result) {
            NSLog(@"忘记密码, 修改密码: %@", result[@"code"]);
            if ([result[@"code"] isEqualToString:@"1"]) {
                //  修改密码成功则返回登录页面
                [self dismissViewControllerAnimated:YES completion:NULL];
                
                //  写入本地
                [UserInformation saveUserName:_phoneTextfield.text Password:_passwordTextfield.text];
            } else {
            }
            _mes = result[@"text"];
//            [self showAlertWithMes:_mes];
        }];
    } else {
        _mes = @"前后密码不一致";
        [self showAlertWithMes:_mes];
    }
    
//    [self showAlertWithMes:_mes];
}

- (void)getVerificationCode:(QJLBaseButton *)button {
    //  http://qianjiale.doggadatachina.com/api/APIUserManage/SendVcode?UserID=
    NSString *tempStr = [NSString stringWithFormat:@"%@api/APIUserManage/SendVcode?UserID=%@", COMMONURL, _phoneTextfield.text];
    [NetWorkingTool getNetWorking:tempStr block:^(id result) {
        if ([result[@"code"] isEqualToString:@"1"]) {
            [_getVerifycodeButton setTitle:@"已发送..." forState:UIControlStateNormal];
            [_getVerifycodeButton setEnabled:NO];
            
            _mes = result[@"text"];
            [self showAlertWithMes:_mes];
            
            //  延时5s后设为可点击
            double delayInSeconds = 5.0;
            __weak ForgetPasswordViewController *blockSelf = self;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds *NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^{
                [blockSelf changeGetVerifyBtnStatus];
            });
            
        }
        
    }];
}

- (void)changeGetVerifyBtnStatus {
    [_getVerifycodeButton setEnabled:YES];
    [_getVerifycodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
}

#pragma mark    - 下一步
- (void)nextAction:(QJLBaseButton *)button {
    
    NSString *str = [NSString stringWithFormat:@"%@api/APIUserManage/GetRegVerificationByIOS?UserID=%@&RegVerificationCode=%@", COMMONURL, _phoneTextfield.text, _verifyTextfield.text];
    [NetWorkingTool getNetWorking:str block:^(id result) {
        NSLog(@"验证码: %@", result[@"code"]);
        if ([result[@"code"] isEqualToString:@"1"]) {
            _tempView.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
        } else {
            NSLog(@"验证码错误");
        }
    }];
    
    _tempView.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
    
}

//  弹出框提示信息
- (void)showAlertWithMes:(NSString *)mes {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:_mes message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
    
}

- (void)phoneFieldValueChange {
    VALUECHANGE(_phoneTextfield, _getVerifycodeButton);
}

- (void)verifyValueChange {
    VALUECHANGE(_verifyTextfield, _nextButton);
}

- (void)confirmValueChange {
    VALUECHANGE(_confirmPasswordTextfield, _submitButton);
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
