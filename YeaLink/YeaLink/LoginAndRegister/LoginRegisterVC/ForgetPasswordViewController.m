//
//  ForgetPasswordViewController.m
//  YeaLink
//
//  Created by 李根 on 16/4/29.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "ForgetPasswordViewController.h"

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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self getView];
}

- (void)getView {
    _phoneTextfield = [[QJLBaseTextfield  alloc] initWithFrame:CGRectMake(25 * WID, 100 * HEI, 230 * WID, 50 * HEI)];
    [self.view addSubview:_phoneTextfield];
    _phoneTextfield.placeholder = @"请输入您的手机号码";
    _phoneTextfield.layer.borderColor = [UIColor colorWithRed:244 / 255.0 green:244 / 255.0 blue:244 / 255.0 alpha:1].CGColor;
    
    _getVerifycodeButton = [QJLBaseButton buttonWithType:UIButtonTypeSystem];
    _getVerifycodeButton.frame = CGRectMake(260 * WID, 100 * HEI, 90 * WID, 50 * HEI);
    //    self.getVerifyButton = [[QJLBaseButton alloc] initWithFrame:CGRectMake(260 * WID, 200 * HEI, 90 * WID, 50 * HEI)];
    [self.view addSubview:_getVerifycodeButton];
    [_getVerifycodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    _getVerifycodeButton.backgroundColor = [UIColor colorWithRed:221 / 255.0 green:221 / 255.0 blue:221 / 255.0 alpha:1];
    [_getVerifycodeButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_getVerifycodeButton addTarget:self action:@selector(getVerificationCode:) forControlEvents:UIControlEventTouchUpInside];
    _getVerifycodeButton.layer.cornerRadius = 10;
    
    self.verifyTextfield = [[QJLBaseTextfield alloc] initWithFrame:CGRectMake(25 * WID, 175 * HEI, 325 * WID, 50 * HEI)];
    [self.view addSubview:self.verifyTextfield];
    self.verifyTextfield.placeholder = @"请输入您的验证码";
    self.verifyTextfield.layer.borderColor = [UIColor colorWithRed:244 / 255.0 green:244 / 255.0 blue:244 / 255.0 alpha:1].CGColor;
    
    _nextButton = [QJLBaseButton buttonWithType:UIButtonTypeSystem];
    [self.view addSubview:_nextButton];
    _nextButton.frame = CGRectMake(25 * WID, 250 * HEI, WIDTH - 50 * WID, 50 * HEI);
    [_nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [_nextButton setTitleColor:[UIColor colorWithRed:130 / 255.0 green:130 / 255.0 blue:130 / 255.0 alpha:1] forState:UIControlStateNormal];
    _nextButton.backgroundColor = [UIColor colorWithRed:221 / 255.0 green:221 / 255.0 blue:221 / 255.0 alpha:1];
    _nextButton.layer.cornerRadius = 10;
    [_nextButton addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //  过度页面
    _tempView = [[QJLBaseView alloc] initWithFrame:CGRectMake(WIDTH, 0, WIDTH, HEIGHT)];
    [self.view addSubview:_tempView];
    _tempView.backgroundColor = [UIColor whiteColor];
    
    QJLBaseLabel *titleLabel = [[QJLBaseLabel alloc] initWithFrame:CGRectMake(150 * WID, 25 * HEI, 100 * WID, 50 * HEI)];
    [self.view addSubview:titleLabel];
    titleLabel.text = @"忘记密码";
    titleLabel.font = [UIFont systemFontOfSize:17];
    
    _passwordTextfield = [[QJLBaseTextfield alloc] initWithFrame:CGRectMake(50 * WID, 100 * HEI, WIDTH - 100 * WID, 50 * HEI)];
    [_tempView addSubview:_passwordTextfield];
    _passwordTextfield.placeholder = @"请输入6 - 16位的密码";
    _passwordTextfield.layer.borderWidth = 1;
    _passwordTextfield.layer.borderColor = [UIColor colorWithRed:209 / 255.0 green:209 / 255.0 blue:209 / 255.0 alpha:1].CGColor;
    _passwordTextfield.secureTextEntry = YES;
    
    _confirmPasswordTextfield = [[QJLBaseTextfield alloc] initWithFrame:CGRectMake(50 * WID, 175 * HEI, WIDTH - 100 * WID, 50 * HEI)];
    [_tempView addSubview:_confirmPasswordTextfield];
    _confirmPasswordTextfield.placeholder = @"请输入6 - 16位的确认密码";
    _confirmPasswordTextfield.layer.borderWidth = 1;
    _confirmPasswordTextfield.layer.borderColor = [UIColor colorWithRed:209 / 255.0 green:209 / 255.0 blue:209 / 255.0 alpha:1].CGColor;
    _confirmPasswordTextfield.secureTextEntry = YES;
    
    _submitButton = [[QJLBaseButton alloc] initWithFrame:CGRectMake(50 * WID, 250 * HEI, WIDTH - 100 * WID, 50 * HEI)];
    [_tempView addSubview:_submitButton];
    [_submitButton setTitle:@"提交" forState:UIControlStateNormal];
    _submitButton.backgroundColor = [UIColor colorWithRed:252 / 255.0 green:105 / 255.0 blue:93 / 255.0 alpha:1];
    [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _submitButton.layer.cornerRadius = 10;
    [_submitButton addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
}

- (void)submitAction:(QJLBaseButton *)button {
    NSLog(@"提交");
}

- (void)getVerificationCode:(QJLBaseButton *)button {
    
}

- (void)nextAction:(QJLBaseButton *)button {
#pragma mark    - 验证验证码的
    //  http://qianjiale.doggadatachina.com/api/APIUserManage/GetRegVerificationByIOS?UserID=15851444614&RegVerificationCode=909090
    NSString *str = [NSString stringWithFormat:@"%@api/APIUserManage/GetRegVerificationByIOS?UserID=%@&RegVerificationCode=%@", COMMONURL, _phoneTextfield.text, _verifyTextfield.text];
    [NetWorkingTool getNetWorking:str block:^(id result) {
        NSLog(@"验证码: %@", result[@"code"]);
        if ([result[@"code"] isEqualToString:@"1"]) {
            _tempView.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
        } else {
            NSLog(@"验证码错误");
        }
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
