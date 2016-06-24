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

#define LDISTANCE 25 * WID
#define HDISTANCE 25 * HEI

@interface RegisterViewController ()<UITextFieldDelegate, UIAlertViewDelegate>
@property(nonatomic, strong)QJLBaseButton *returnButton;
@property(nonatomic, strong)UISegmentedControl *segControl;
@property(nonatomic, strong)QJLBaseTextfield *phoneNumberTextfield; //  手机号码
@property(nonatomic, strong)QJLBaseTextfield *verifyTextfield;  //  验证码
@property(nonatomic, strong)QJLBaseButton *getVerifyButton; //  获得验证码
@property(nonatomic, strong)QJLBaseButton *nextButton;  //  下一步
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
    
    [self setNavigationbar];
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

- (void)setNavigationbar {
    QJLBaseLabel *label = [QJLBaseLabel LabelWithFrame:CGRectMake(0, 0, 50, 30) text:@"注册" titleColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter font:[UIFont systemFontOfSize:19]];
    self.navigationItem.titleView = label;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
}

- (void)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getView {
    
    //  segmentControl
    self.segControl = [[UISegmentedControl alloc] initWithItems:@[@"个人注册", @"业主注册"]];
    [self.view addSubview:self.segControl];
    self.segControl.tintColor = SEGCONTROLCOLOR;
    self.segControl.selectedSegmentIndex = 0;
    [_segControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(HDISTANCE);
        make.left.equalTo(self.view).with.offset(LDISTANCE);
        make.right.equalTo(self.view).with.offset(-LDISTANCE);
        make.height.mas_equalTo(50 * HEI);
    }];
    [self.segControl addTarget:self action:@selector(changeView:) forControlEvents:UIControlEventValueChanged];
    
    self.phoneNumberTextfield = [[QJLBaseTextfield  alloc] init];
    [self.view addSubview:self.phoneNumberTextfield];
    self.phoneNumberTextfield.placeholder = @"请输入您的手机号码";
    self.phoneNumberTextfield.layer.borderColor = BORDERCOLOR.CGColor;
    [_phoneNumberTextfield addTarget:self action:@selector(valueChange) forControlEvents:UIControlEventAllEditingEvents];
    
    self.getVerifyButton = [QJLBaseButton buttonWithType:UIButtonTypeSystem];
    _getVerifyButton.frame = CGRectMake(260 * WID, 200 * HEI, 90 * WID, 50 * HEI);
    [self.view addSubview:self.getVerifyButton];
    _getVerifyButton.enabled = NO;
    [self.getVerifyButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    _getVerifyButton.layer.cornerRadius = 5;
    self.getVerifyButton.backgroundColor = BGCOLOR;
    [self.getVerifyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.getVerifyButton addTarget:self action:@selector(getVerificationCode:) forControlEvents:UIControlEventTouchUpInside];
    
    //  segmentcontrol切换视图
    [self createTempView];
    
    self.verifyTextfield = [[QJLBaseTextfield alloc] init];
    [self.view addSubview:self.verifyTextfield];
    self.verifyTextfield.placeholder = @"请输入您的验证码";
    self.verifyTextfield.layer.borderColor = BORDERCOLOR.CGColor;
    [_verifyTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(_segControl);
        make.top.equalTo(_phoneNumberTextfield.mas_bottom).with.offset(HDISTANCE);
        make.centerX.equalTo(_segControl);
    }];
    [_verifyTextfield addTarget:self action:@selector(verifyValueChange) forControlEvents:UIControlEventAllEditingEvents];
    
    
    self.nextButton = [QJLBaseButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:_nextButton];
    _nextButton.frame = CGRectMake(25 * WID, 350 * HEI, WIDTH - 50 * WID, 50 * HEI);
    [_nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [_nextButton setTitleColor:[UIColor colorWithRed:130 / 255.0 green:130 / 255.0 blue:130 / 255.0 alpha:1] forState:UIControlStateNormal];
    _nextButton.backgroundColor = BGCOLOR;
    _nextButton.layer.cornerRadius = 5;
    _nextButton.enabled = NO;
    [_nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(_segControl);
        make.centerX.equalTo(_segControl);
        make.top.equalTo(_verifyTextfield.mas_bottom).with.offset(HDISTANCE);
    }];
    [_nextButton addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
    
#pragma mark    - 输入密码页面
    _inputPasswordView = [[QJLBaseView alloc] initWithFrame:CGRectMake(WIDTH, 0, WIDTH, HEIGHT)];
    [self.view addSubview:_inputPasswordView];
    _inputPasswordView.backgroundColor = [UIColor whiteColor];
    
    _passwordTextfield = [[QJLBaseTextfield alloc] init];
    [_inputPasswordView addSubview:_passwordTextfield];
    _passwordTextfield.placeholder = @"请输入6 - 16位的密码";
    _passwordTextfield.layer.borderWidth = 1;
    _passwordTextfield.layer.borderColor = BORDERCOLOR.CGColor;
    _passwordTextfield.secureTextEntry = YES;
    [_passwordTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(_verifyTextfield);
        make.centerX.equalTo(_inputPasswordView);
        make.top.equalTo(_inputPasswordView).with.offset(HDISTANCE);
    }];
    
    _confirmTextfield = [[QJLBaseTextfield alloc] init];
    [_inputPasswordView addSubview:_confirmTextfield];
    _confirmTextfield.placeholder = @"请输入6 - 16位的确认密码";
    _confirmTextfield.layer.borderWidth = 1;
    _confirmTextfield.layer.borderColor = BORDERCOLOR.CGColor;
    _confirmTextfield.secureTextEntry = YES;
    [_confirmTextfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.and.centerX.equalTo(_passwordTextfield);
        make.top.equalTo(_passwordTextfield.mas_bottom).with.offset(HDISTANCE);
    }];
    [_confirmTextfield addTarget:self action:@selector(confirmValueChange) forControlEvents:UIControlEventAllEditingEvents];
    
    _registerButton = [QJLBaseButton buttonWithType:UIButtonTypeSystem];
    [_inputPasswordView addSubview:_registerButton];
    [_registerButton setTitle:@"注册" forState:UIControlStateNormal];
    _registerButton.backgroundColor = BGCOLOR;
    [_registerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _registerButton.layer.cornerRadius = 5;
    _registerButton.enabled = NO;
    [_registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.and.centerX.equalTo(_confirmTextfield);
        make.top.equalTo(_confirmTextfield.mas_bottom).with.offset(HDISTANCE);
    }];
    [_registerButton addTarget:self action:@selector(registerAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
}
#pragma mark    - segment切换view
- (void)createTempView {
    if (_segControl.selectedSegmentIndex == 0) {
        _isOwner = 0;   //  index为0, 即是个人注册

        [_phoneNumberTextfield mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(230 * WID, 50 * HEI));
            make.left.equalTo(self.view).with.offset(LDISTANCE);
            make.top.equalTo(_segControl.mas_bottom).with.offset(HDISTANCE);
            
        }];
        
        [_getVerifyButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.and.height.equalTo(_phoneNumberTextfield);
            make.left.equalTo(_phoneNumberTextfield.mas_right).with.offset(5 * WID);
            make.right.equalTo(self.view).with.offset(-LDISTANCE);
        }];
        
        _verifyTextfield.placeholder = @"请输入您的验证码";
    } else {
        _isOwner = 1;   //  业主注册
        
        [_phoneNumberTextfield mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.and.centerX.equalTo(_segControl);
            make.top.equalTo(_segControl.mas_bottom).with.offset(HDISTANCE);
            make.left.equalTo(_segControl);
            
        }];

        [_getVerifyButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerY.and.height.equalTo(_phoneNumberTextfield);
            make.left.equalTo(_phoneNumberTextfield.mas_right).with.offset(5 * WID);
            make.right.equalTo(self.view).with.offset(-LDISTANCE);
        }];
        
        _verifyTextfield.placeholder = @"请输入您的邀请码";
    }
    _verifyTextfield.delegate = self;
    
//    NSLog(@"isOwner: %lu", _isOwner);
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

#pragma mark    - 下一步
- (void)nextAction:(QJLBaseButton *)button {
    //  先判断手机号和验证码是否正确, true则跳到第二页, 否则弹框提箱
    
    
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
    
//    _inputPasswordView.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
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
                _getVerifyButton.enabled = NO;
                _getVerifyButton.backgroundColor = BGCOLOR;
                double delayTime = 3.0;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    _getVerifyButton.enabled = YES;
                    _getVerifyButton.backgroundColor = SEGCONTROLCOLOR;
                    [_getVerifyButton setTitle:@"获取验证码" forState:UIControlStateNormal];
                });
            }

            NSLog(@"请求验证码code: %@", result[@"code"]);  //  -2代表手机号已经注册
        }];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"手机号码错误" message:@"请输入正确的手机号码" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
        [alertView show];
    }
    
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

- (void)valueChange {
    if (_segControl.selectedSegmentIndex == 0) {
        VALUECHANGE(_phoneNumberTextfield, _getVerifyButton);
    }
}

- (void)verifyValueChange {
    VALUECHANGE(_verifyTextfield, _nextButton);
}

- (void)confirmValueChange {
    VALUECHANGE(_confirmTextfield, _registerButton);
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
