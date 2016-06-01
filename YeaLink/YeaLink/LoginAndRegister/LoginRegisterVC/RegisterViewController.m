//
//  RegisterViewController.m
//  YeaLink
//
//  Created by 李根 on 16/4/28.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "RegisterViewController.h"
#import "LoginViewController.h"
#import "HomepageViewController.h"

@interface RegisterViewController ()<UITextFieldDelegate, UIAlertViewDelegate>
@property(nonatomic, strong)QJLBaseButton *returnButton;
//@property(nonatomic, strong)QJLBaseButton *userButton;
@property(nonatomic, strong)UISegmentedControl *segControl;
@property(nonatomic, strong)QJLBaseTextfield *phoneNumberTextfield; //  手机号码
@property(nonatomic, strong)QJLBaseTextfield *verifyTextfield;  //  验证码
@property(nonatomic, strong)QJLBaseButton *getVerifyButton; //  获得验证码
@property(nonatomic, strong)QJLBaseButton *nextButton;  //  下一步
//@property(nonatomic, strong)QJLBaseButton *loginNowButton;  //  立即登录
@property(nonatomic, strong)QJLBaseView *tempView;  //  切换segmentcontrol视图
@property(nonatomic, strong)QJLBaseView *inputPasswordView;  //  第二个页面
@property(nonatomic, strong)QJLBaseTextfield *passwordTextfield;    //  输入密码
@property(nonatomic, strong)QJLBaseTextfield *confirmTextfield; //  确认密码
@property(nonatomic, strong)QJLBaseButton *registerButton;  //  注册按钮
@property(nonatomic, assign)BOOL isOwner;   //  0为个人注册, 1为业主注册
@property(nonatomic, strong)NSString *verifyCode;   //  验证码

@end

@implementation RegisterViewController
{
    NSTimer *_timer;
    UIAlertView *_alertView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    _isOwner = 0;
    
    [self getView];
    
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [_getVerifyButton setTitle:@"获取验证码" forState:UIControlStateNormal];
}

- (void)dealloc {
//    [super dealloc];
    
    [_timer invalidate];
    _timer = nil;
}

- (void)getView {
    _returnButton = [QJLBaseButton buttonWithType:UIButtonTypeCustom];
    _returnButton.frame = CGRectMake(25 * WID, 25 * HEI, 50 * WID, 50 * HEI);
    [self.view addSubview:self.returnButton];
    [_returnButton addTarget:self action:@selector(returnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_returnButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [_returnButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    
//    self.userButton = [[QJLBaseButton alloc] initWithFrame:CGRectMake(300 * WID, 25 * HEI, 50 * WID, 50 * HEI)];
//    [self.view addSubview:self.userButton];
    
    //  segmentControl
    self.segControl = [[UISegmentedControl alloc] initWithItems:@[@"个人注册", @"业主注册"]];
    self.segControl.frame = CGRectMake(25 * WID, 100 * HEI, WIDTH - 50 * WID, 50 * HEI);
    [self.view addSubview:self.segControl];
//    self.segControl.momentary = YES;
    self.segControl.tintColor = [UIColor colorWithRed:252 / 255.0 green:105 / 255.0 blue:93 / 255.0 alpha:1];
//    self.segControl.backgroundColor = [UIColor blueColor];
    self.segControl.selectedSegmentIndex = 0;
    [self.segControl addTarget:self action:@selector(changeView:) forControlEvents:UIControlEventValueChanged];
    
    self.phoneNumberTextfield = [[QJLBaseTextfield  alloc] initWithFrame:CGRectMake(25 * WID, 200 * HEI, 230 * WID, 50 * HEI)];
    [self.view addSubview:self.phoneNumberTextfield];
    self.phoneNumberTextfield.placeholder = @"请输入您的手机号码";
    self.phoneNumberTextfield.layer.borderColor = [UIColor colorWithRed:244 / 255.0 green:244 / 255.0 blue:244 / 255.0 alpha:1].CGColor;
    
    self.getVerifyButton = [QJLBaseButton buttonWithType:UIButtonTypeSystem];
    _getVerifyButton.frame = CGRectMake(260 * WID, 200 * HEI, 90 * WID, 50 * HEI);
    //    self.getVerifyButton = [[QJLBaseButton alloc] initWithFrame:CGRectMake(260 * WID, 200 * HEI, 90 * WID, 50 * HEI)];
    [self.view addSubview:self.getVerifyButton];
    [self.getVerifyButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    self.getVerifyButton.backgroundColor = [UIColor colorWithRed:221 / 255.0 green:221 / 255.0 blue:221 / 255.0 alpha:1];
    [self.getVerifyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.getVerifyButton addTarget:self action:@selector(getVerificationCode:) forControlEvents:UIControlEventTouchUpInside];
    self.getVerifyButton.layer.cornerRadius = 10;
    
    self.verifyTextfield = [[QJLBaseTextfield alloc] initWithFrame:CGRectMake(25 * WID, 275 * HEI, 325 * WID, 50 * HEI)];
    [self.view addSubview:self.verifyTextfield];
    self.verifyTextfield.placeholder = @"请输入您的验证码";
    self.verifyTextfield.layer.borderColor = [UIColor colorWithRed:244 / 255.0 green:244 / 255.0 blue:244 / 255.0 alpha:1].CGColor;
    
    //  segmentcontrol切换视图
    [self createTempView];
    
    
    self.nextButton = [QJLBaseButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:_nextButton];
    _nextButton.frame = CGRectMake(25 * WID, 350 * HEI, WIDTH - 50 * WID, 50 * HEI);
    [_nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [_nextButton setTitleColor:[UIColor colorWithRed:130 / 255.0 green:130 / 255.0 blue:130 / 255.0 alpha:1] forState:UIControlStateNormal];
    _nextButton.backgroundColor = [UIColor colorWithRed:221 / 255.0 green:221 / 255.0 blue:221 / 255.0 alpha:1];
    _nextButton.layer.cornerRadius = 10;
    [_nextButton addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
    
//    _loginNowButton = [QJLBaseButton buttonWithType:UIButtonTypeSystem];
//    _loginNowButton.frame = CGRectMake(150 * WID, 450 * HEI, 75 * WID, 50 * HEI);
//    [self.view addSubview:_loginNowButton];
//    //  设置下划线
//    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"立即登录"];
//    NSRange strRange = {0, [str length]};
//    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
//    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:strRange];
//    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:strRange];
//    [_loginNowButton setAttributedTitle:str forState:UIControlStateNormal];
//    [_loginNowButton addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
#pragma mark    - 输入密码页面
    _inputPasswordView = [[QJLBaseView alloc] initWithFrame:CGRectMake(WIDTH, 0, WIDTH, HEIGHT)];
    [self.view addSubview:_inputPasswordView];
    _inputPasswordView.backgroundColor = [UIColor whiteColor];
    
    self.returnButton= [[QJLBaseButton alloc] initWithFrame:CGRectMake(25 * WID, 25 * HEI, 50 * WID, 50 * HEI)];
    [_inputPasswordView addSubview:self.returnButton];
    [_returnButton addTarget:self action:@selector(secondReturnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    QJLBaseLabel *titleLabel = [[QJLBaseLabel alloc] initWithFrame:CGRectMake(137.5 * WID, 25 * HEI, 100 * WID, 50 * HEI)];
    titleLabel.text = @"输入密码";
    titleLabel.font = [UIFont systemFontOfSize:23];
    [_inputPasswordView addSubview:titleLabel];
    
    _passwordTextfield = [[QJLBaseTextfield alloc] initWithFrame:CGRectMake(50 * WID, 100 * HEI, WIDTH - 100 * WID, 50 * HEI)];
    [_inputPasswordView addSubview:_passwordTextfield];
    _passwordTextfield.placeholder = @"请输入6 - 16位的密码";
    _passwordTextfield.layer.borderWidth = 1;
    _passwordTextfield.layer.borderColor = [UIColor colorWithRed:209 / 255.0 green:209 / 255.0 blue:209 / 255.0 alpha:1].CGColor;
    _passwordTextfield.secureTextEntry = YES;
    
    _confirmTextfield = [[QJLBaseTextfield alloc] initWithFrame:CGRectMake(50 * WID, 200 * HEI, WIDTH - 100 * WID, 50 * HEI)];
    [_inputPasswordView addSubview:_confirmTextfield];
    _confirmTextfield.placeholder = @"请输入6 - 16位的确认密码";
    _confirmTextfield.layer.borderWidth = 1;
    _confirmTextfield.layer.borderColor = [UIColor colorWithRed:209 / 255.0 green:209 / 255.0 blue:209 / 255.0 alpha:1].CGColor;
    _confirmTextfield.secureTextEntry = YES;
    
    _registerButton = [QJLBaseButton buttonWithType:UIButtonTypeSystem];
    _registerButton.frame = CGRectMake(50 * WID, 300 * HEI, WIDTH - 100 * WID, 50 * HEI);
    [_inputPasswordView addSubview:_registerButton];
    [_registerButton setTitle:@"注册" forState:UIControlStateNormal];
    _registerButton.backgroundColor = [UIColor colorWithRed:252 / 255.0 green:105 / 255.0 blue:93 / 255.0 alpha:1];
    [_registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _registerButton.layer.cornerRadius = 10;
    [_registerButton addTarget:self action:@selector(registerAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
}
#pragma mark    - segment切换view
- (void)createTempView {
    if (_segControl.selectedSegmentIndex == 0) {
        _isOwner = 0;   //  index为0, 即是个人注册
        _phoneNumberTextfield.frame = CGRectMake(25 * WID, 200 * HEI, 230 * WID, 50 * HEI);
        _getVerifyButton.frame = CGRectMake(260 * WID, 200 * HEI, 90 * WID, 50 * HEI);
        _verifyTextfield.placeholder = @"请输入您的验证码";
    } else {
        _isOwner = 1;   //  业主注册
        _phoneNumberTextfield.frame = CGRectMake(25 * WID, 200 * HEI, 325 * WID, 50 * HEI);
        _getVerifyButton.frame = CGRectZero;
        _verifyTextfield.placeholder = @"请输入您的邀请码";
    }
    _verifyTextfield.delegate = self;
    
    NSLog(@"isOwner: %lu", _isOwner);
}

- (void)changeView:(UISegmentedControl *)segControl {
    [self createTempView];
    
}

- (void)backAction:(QJLBaseButton *)button {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)registerAction:(QJLBaseButton *)button {
    if ([_passwordTextfield.text isEqualToString:_confirmTextfield.text]) {
        if (_isOwner == 0) {
            //  http://qianjiale.doggadatachina.com/api/APIUserManage/APPUserRegisterByIOS?UserID=15851444615&PassWord=1&APPUserRole=1
            
            NSString *str = [NSString stringWithFormat:@"%@api/APIUserManage/APPUserRegisterByIOS?UserID=%@&PassWord=%@&APPUserRole=1", COMMONURL, _phoneNumberTextfield.text, [MyMD5 md5:_passwordTextfield.text]];
            [NetWorkingTool getNetWorking:str block:^(id result) {
                NSLog(@"个人注册code: %@", result[@"code"]);
                if ([result[@"code"] isEqualToString:@"1"]) {
                    [self dismissViewControllerAnimated:YES completion:^{
                        
                    }];
                } else {
                    NSLog(@"个人注册失败");
                }
            }];
        } else {
            NSString *str = [NSString stringWithFormat:@"%@api/APIUserManage/UserBindByIOS?UserID=%@&RegisterCode=%@&APPUserRole=2", COMMONURL, _phoneNumberTextfield.text, [MyMD5 md5:_passwordTextfield.text]];
            [NetWorkingTool getNetWorking:str block:^(id result) {
                NSLog(@"业主注册code: %@", result[@"code"]);
                if ([result[@"code"] isEqualToString:@"1"]) {
                    [self dismissViewControllerAnimated:YES completion:^{
                        
                    }];
                } else {
                    NSLog(@"业主注册失败");
                }
            }];
        }
        
    }
    
}

//  下一步页面   - 输入密码
- (void)nextAction:(QJLBaseButton *)button {
    //  先判断手机号和验证码是否正确, true则跳到第二页, 否则弹框提箱
    //  http://qianjiale.doggadatachina.com/api/APIUserManage/GetRegVerificationByIOS?UserID=15851444614&RegVerificationCode=909090
    
    NSString *str = [NSString stringWithFormat:@"%@api/APIUserManage/GetRegVerificationByIOS?UserID=%@&RegVerificationCode=%@", COMMONURL, _phoneNumberTextfield.text, _verifyTextfield.text];
    
    NSLog(@"%@", str);
    [NetWorkingTool getNetWorking:str block:^(id result) {
        NSLog(@"密码是否合法code: %@", result[@"code"]);
        if ([result[@"code"] isEqualToString:@"1"]) {
            _inputPasswordView.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
        } else {
            NSLog(@"验证码或邀请码错误");
        }
    }];
}

- (void)secondReturnAction:(QJLBaseButton *)button {
    
}

//  登录跳转
- (void)loginAction:(QJLBaseButton *)button {
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    [self presentViewController:loginVC animated:YES completion:^{
        NSLog(@"立即登录");
    }];
}

- (void)getVerificationCode:(QJLBaseButton *)button {
    if ([CheckFormatTool checkTelNumber:_phoneNumberTextfield.text]) {
        //  http://qianjiale.doggadatachina.com/api/APIUserManage/RegisterVerificationByIOS?UserID=15851444614
        NSString *str = [NSString stringWithFormat:@"%@api/APIUserManage/RegisterVerificationByIOS?UserID=%@", COMMONURL, _phoneNumberTextfield.text];
        NSLog(@"get verifycode: %@", str);
        [NetWorkingTool getNetWorking:str block:^(id result) {
            if (![result[@"code"] isEqualToString:@"1"]) {
                [self showInfowith:result[@"text"]];
            } else {
                [_getVerifyButton setTitle:@"验证码已发送" forState:UIControlStateNormal];
            }

            NSLog(@"请求验证码code: %@", result[@"code"]);  //  -2代表手机号已经注册
        }];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"手机号码错误" message:@"请输入正确的手机号码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        [alertView show];
    }
    
    /**
     *
     */
}


- (void)showInfowith:(NSString *)str {
    _alertView = [[UIAlertView alloc] initWithTitle:str message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    _alertView.delegate = self;
    _alertView.tag = 101;
    [_alertView show];
    _timer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(removeAlert) userInfo:nil repeats:NO];
    [_timer fire];
}

- (void)removeAlert {
    [_alertView removeFromSuperview];
}

- (void)returnAction:(UIButton *)button {
    NSLog(@"从注册页面返回");
//    [self dismissViewControllerAnimated:YES completion:^{
//        
//    }];
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
