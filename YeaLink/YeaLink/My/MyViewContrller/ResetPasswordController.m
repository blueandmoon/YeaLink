//
//  ResetPasswordController.m
//  YeaLink
//
//  Created by 李根 on 16/5/19.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "ResetPasswordController.h"

#define WDISTANCE 20 * WID
#define HDISTANCE 15 * HEI

@interface ResetPasswordController ()

@end

@implementation ResetPasswordController
{
    QJLBaseTextfield *_oldPasswordField;
    QJLBaseTextfield *_newPasswordField;
    QJLBaseTextfield *_confirmPasswordField;
    QJLBaseButton *_submitBtn;
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    self.navigationController.navigationBar.translucent = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    _confirmPasswordField.text = nil;
    _oldPasswordField.text = nil;
    _newPasswordField.text = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self settingNavigetionbar];
    [self getValue];
}

- (void)settingNavigetionbar {
    QJLBaseLabel *label = [QJLBaseLabel LabelWithFrame:CGRectMake(0, 0, 50 * WID, 30 * HEI) text:@"重置密码" titleColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter font:[UIFont systemFontOfSize:19]];
    self.navigationItem.titleView = label;
    self.navigationController.navigationBar.barTintColor = CUSTOMBLUE;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(leftAction:)];
    
}

- (void)leftAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getValue {
    _oldPasswordField = [QJLBaseTextfield textfieldCustomWithFrame:CGRectZero placeholderText:@"请输入您的原密码" textAlignment:NSTextAlignmentLeft titlecolor:[UIColor blackColor] font:[UIFont systemFontOfSize:17]];
    [self.view addSubview:_oldPasswordField];
    _oldPasswordField.layer.borderColor = [UIColor colorWithRed:209 / 255.0 green:209 / 255.0 blue:209 / 255.0 alpha:1].CGColor;
    _oldPasswordField.layer.borderWidth = 1;
    _oldPasswordField.layer.cornerRadius = 5;
    _oldPasswordField.secureTextEntry = YES;
    [_oldPasswordField setValue:[NSNumber numberWithInt:15] forKey:@"paddingTop"];
    [_oldPasswordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(WDISTANCE);
        make.top.equalTo(self.view).with.offset(50 * HEI);
        make.height.mas_equalTo(50 * HEI);
        make.right.equalTo(self.view).with.offset(-WDISTANCE);
    }];
    
    _newPasswordField = [QJLBaseTextfield textfieldCustomWithFrame:CGRectZero placeholderText:@"请输入您的新密码" textAlignment:NSTextAlignmentLeft titlecolor:[UIColor blackColor] font:[UIFont systemFontOfSize:17]];
    [self.view addSubview:_newPasswordField];
    _newPasswordField.layer.borderColor = [UIColor colorWithRed:209 / 255.0 green:209 / 255.0 blue:209 / 255.0 alpha:1].CGColor;
    _newPasswordField.layer.borderWidth = 1;
    _newPasswordField.layer.cornerRadius = 5;
    _newPasswordField.secureTextEntry = YES;
    [_newPasswordField setValue:[NSNumber numberWithInt:15] forKey:@"paddingTop"];
    [_newPasswordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(WDISTANCE);
        make.top.equalTo(_oldPasswordField.mas_bottom).with.offset(HDISTANCE);
        make.size.equalTo(_oldPasswordField);
    }];
    
    _confirmPasswordField = [QJLBaseTextfield textfieldCustomWithFrame:CGRectZero placeholderText:@"请再次输入您的新密码" textAlignment:NSTextAlignmentLeft titlecolor:[UIColor blackColor] font:[UIFont systemFontOfSize:17]];
    [self.view addSubview:_confirmPasswordField];
    _confirmPasswordField.layer.borderColor = [UIColor colorWithRed:209 / 255.0 green:209 / 255.0 blue:209 / 255.0 alpha:1].CGColor;
    _confirmPasswordField.layer.borderWidth = 1;
    _confirmPasswordField.layer.cornerRadius = 5;
    _confirmPasswordField.secureTextEntry = YES;
    [_confirmPasswordField setValue:[NSNumber numberWithInt:15] forKey:@"paddingTop"];
    [_confirmPasswordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(WDISTANCE);
        make.top.equalTo(_newPasswordField.mas_bottom).with.offset(HDISTANCE);
        make.size.equalTo(_oldPasswordField);
    }];
    
    _submitBtn = [QJLBaseButton buttonCustomFrame:CGRectZero title:@"提交" currentTitleColor:[UIColor whiteColor]];
    [self.view addSubview:_submitBtn];
    _submitBtn.layer.cornerRadius = 5;
    _submitBtn.backgroundColor = [UIColor colorWithRed:252 / 255.0 green:105 / 255.0 blue:93 / 255.0 alpha:1];
    [_submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).with.offset(WDISTANCE);
        make.top.equalTo(_confirmPasswordField.mas_bottom).with.offset(30 * HEI);
        make.size.equalTo(_oldPasswordField);
    }];
    [_submitBtn addTarget:self action:@selector(submitAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)submitAction:(id)sender {
//    修改密码
//http://qianjiale.doggadatachina.com/api/APIUserManage/APPResetPassWord?UserID=18112572968&NewPassword=e10adc3949ba59abbe56e057f20f883e
    
    __block NSString *mes = nil;  //  alertview 的提示信息
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"Password"] isEqualToString:[MyMD5 md5:_oldPasswordField.text]]) {
        if ([_newPasswordField.text isEqualToString:_confirmPasswordField.text]) {
            if ([CheckFormatTool checkPassword:_newPasswordField.text]) {
                NSString *str = [NSString stringWithFormat:@"%@api/APIUserManage/APPResetPassWord?UserID=%@&NewPassword=%@", COMMONURL, [UserInformation userinforSingleton].usermodel.UserID, [MyMD5 md5:_newPasswordField.text]];
                NSLog(@"%@", str);
                [NetWorkingTool getNetWorking:str block:^(id result) {
                    NSLog(@"%@", result);
                    if ([result[@"code"] isEqualToString:@"1"]) {
                        NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
                        [userdef setObject:[MyMD5 md5:_newPasswordField.text] forKey:@"Password"];
                    }
                    mes = result[@"text"];
                    [self showAlertViewWithTitle:mes];
                }];
            } else {
                mes = @"请输入6到20位的密码数字组合密码!";
            }
        } else {
            mes = @"密码输入不一致!";
        }
    } else {
        mes = @"原密码输入错误!";
    }
    
    [self showAlertViewWithTitle:mes];
    
}
//  显示提示信息
- (void)showAlertViewWithTitle:(NSString *)mes {
    if (mes) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:mes message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if ([alertView.title isEqualToString:@"修改成功"]) {
        [self.navigationController popViewControllerAnimated:YES];
    }
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
