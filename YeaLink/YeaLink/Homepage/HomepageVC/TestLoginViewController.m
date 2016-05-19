//
//  TestLoginViewController.m
//  YeaLink
//
//  Created by 李根 on 16/5/3.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "TestLoginViewController.h"
#import "WebUserAPI.h"
#import "WebKeyCaseAPI.h"
#import "WebKeyManager.h"

#import "SIPPhoneHomeViewController.h"

static NSString* const loginServerAddress = @"120.25.212.198:9700";
static NSString* const serviceAddress = @"120.25.212.198:21664";

static NSString* const kUsernameStoreIdentifier = @"username";
static NSString* const kDeveloerCodeStoreIdentifier = @"developerCode";

@interface TestLoginViewController ()

@end

@implementation TestLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor orangeColor];
    
    [[SipCoreManager sharedManager] removeAllAccounts];
    
    [self createView];
    
#pragma mark    - 把开发者账号存到本地了
    NSUserDefaults* userDef = [NSUserDefaults standardUserDefaults];
    NSString* username = [userDef objectForKey:kUsernameStoreIdentifier];
    NSString* developerCode = [userDef objectForKey:kDeveloerCodeStoreIdentifier];;
    if (username == nil) {
        username = @"testxr3";
        //  A32F265D-6C46-469E-A1DC-74E5E67A523C
        developerCode = @"A32F265D-6C46-469E-A1DC-74E5E67A523C";
        
        //save default value
        [userDef setObject:username forKey:kUsernameStoreIdentifier];
        [userDef setObject:developerCode forKey:kDeveloerCodeStoreIdentifier];
        [userDef synchronize];
    }
    
    [_acctTextField setText:username];
    [_developerCodeTextField setText:developerCode];
    
    _loginButton.layer.borderWidth = 1.0;
    _loginButton.layer.borderColor = [UIColor colorWithHex:0xECF1F2].CGColor;
    _loginButton.layer.cornerRadius = 5.0;
    [_loginButton addTarget:self action:@selector(LoginBUttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    //  返回按钮
    QJLBaseButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:button];
    [button setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    button.frame = CGRectMake(10, 30, 20, 20);
    [button addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)backAction:(QJLBaseButton *)button {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
#pragma mark    - 创建view
- (void)createView {
    _acctTextField = [[UITextField alloc] initWithFrame:CGRectMake(100, 100, 100, 50)];
    [self.view addSubview:_acctTextField];
    
    _developerCodeTextField = [[UITextField alloc] initWithFrame:CGRectMake(100, 200, 100, 50)];
    [self.view addSubview:_developerCodeTextField];
    
    _loginButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _loginButton.frame = CGRectMake(100, 300, 100, 50);
    [self.view addSubview:_loginButton];
    _loginButton.backgroundColor = [UIColor cyanColor];
    [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
}

- (void)LoginBUttonPressed:(UIButton *)button {
    WebUserAPI* wuApi = [[WebUserAPI alloc] initWithLoginSeverAddress:loginServerAddress andServiceAddr:serviceAddress developerCode:_developerCodeTextField.text];
    
    [wuApi loginWithName:_acctTextField.text completionBlock:^(NSError* error, LoginResponse* response) {
        if (error) {
            NSLog(@"%@", error);
        } else {
            //parser from response.scope
            NSString* tenantCode = @"T320508000000001";
            [[WebKeyManager sharedManager] getWebKeys:serviceAddress
                                             username:_acctTextField.text
                                           tenantCode:tenantCode
                                            tokenType:response.tokenType
                                          accessToken:response.accessToken
                                      completionBlock:^(NSError* error) {
                                          if (error) {
                                              NSLog(@"%@", error);
                                          } else {
                                              NSUserDefaults* userDef = [NSUserDefaults standardUserDefaults];
                                              
                                              //save default value
                                              [userDef setObject:_acctTextField.text forKey:kUsernameStoreIdentifier];
                                              [userDef setObject:_developerCodeTextField.text forKey:kDeveloerCodeStoreIdentifier];
                                              [userDef synchronize];
                                              //    这行有什么用?
//                                              [self dismissViewControllerAnimated:YES completion:nil];
                                          }
//                                          NSLog(@"-----response.tokenType: %@, -----response.accessToken: %@", response.tokenType, response.accessToken);
                                      }];
        
            //  登录跳转, 放这里怎么样?
            SIPPhoneHomeViewController *sipVC = [[SIPPhoneHomeViewController alloc] init];
            [self presentViewController:sipVC animated:NO completion:^{
                
            }];
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
