//
//  HomepageViewController.m
//  YeaLink
//
//  Created by 李根 on 16/4/24.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "HomepageViewController.h"
#import "AreaModel.h"
#import "RegisterViewController.h"
#import "LoginViewController.h"
#import "ServiceModel.h"
#import "TestLoginViewController.h"
#import "WebViewController.h"
#import "BaseScrollView.h"
#import "UserModel.h"
#import "SIPLogin.h"
#import "SIPPhoneHomeViewController.h"
#import "WYScrollView.h"
#import "DeviceTableViewController.h"   //  扫描发现的蓝牙设备列表

@interface HomepageViewController ()<WYScrollViewNetDelegate>

@property(nonatomic, strong)UIScrollView *scrollView;
@property(nonatomic, strong)HomepageView *functionVIew;
@property(nonatomic, strong)ServiceView *serviceView;
@property(nonatomic, strong)AreaView *areaView;
@property(nonatomic, strong)EntranceGuardView *entranceGuardView;
@property(nonatomic, strong)BaseScrollView *adView;
@end

@implementation HomepageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.dataArrFirst = [NSMutableArray array];
    self.dataArrSecond = [NSMutableArray array];
    self.dataArrThird = [NSMutableArray array];
    
    //  展示菊花
    self.hud = [BaseProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.labelText = @"loading...";
    //  加载数据
    [self questData];
    //  设置导航栏
    [self createNavigationbar];
    
    //  判断是否登录
    NSString *username = [[NSUserDefaults standardUserDefaults] stringForKey:@"UserName"];
    NSString *password = [[NSUserDefaults standardUserDefaults] stringForKey:@"Password"];
    NSString *strURL = [NSString stringWithFormat:@"http://qianjiale.doggadatachina.com/api/APIUserManage/APPloginByIOS?UserID=%@&PassWord=%@", username, password];
    [NetWorkingTool getNetWorking:strURL block:^(id result) {
        if ([result[@"code"] isEqualToString:@"1"]) {
            NSLog(@"自动登录成功code: %@", result[@"code"]);
            //  同时登录全视通平台
            [SIPLogin loginSIP];
            //  接收用户信息
            //  http://qianjiale.doggadatachina.com/api/APIUserManage/ShowUserInfo?UserID=18112572968
            NSString *strURL = [NSString stringWithFormat:@"%@api/APIUserManage/ShowUserInfo?UserID=%@", COMMONURL, username];
            NSLog(@"strURL: %@",strURL);
            [NetWorkingTool getNetWorking:strURL block:^(id result) {
                UserInformation *userInfor = [UserInformation userinforSingleton];
                NSArray *arr = [UserModel baseModelByArray:result[@"list"]];
                userInfor.usermodel = arr[0];
                NSLog(@"userInfor.usermodel.UserID: %@, cityid: %@", userInfor.usermodel.UserID, userInfor.usermodel.CityID);
            }];
            
        } else {
            LoginViewController *loginVC = [[LoginViewController alloc] init];
            [self presentViewController:loginVC animated:NO completion:^{
                
            }];
        }
    }];
}

#pragma mark    请求数据
- (void)questData {
    /**
     *  地区数据
     *
     */
    NSString *str= [NSString stringWithFormat:@"%@api/APICityManage/GetCity", COMMONURL];
    [NetWorkingTool getNetWorking:str block:^(id result) {
        self.dataArrSecond = [AreaModel baseModelByArray:result[@"list"]];
        NSLog(@"%@", self.dataArrSecond);
    }];
    /**
     *  首页数据
     */
    [NetWorkingTool getNetWorking:@"http://qianjiale.doggadatachina.com/api/APIAppIndex/GetAppIndexSeviceListByIOS?CityID=320501&AuthoLevel=2&UserID=18112572968" block:^(id result) {
        //  轮播图
        self.dataArrThird = [ServiceModel baseModelByArray:result[@"AdvList"]];
        //  中部, 下部
        self.dataArrFirst = [ServiceModel baseModelByArray:result[@"ServiceList"]];
        
        [self getValue];
        [self getView];
    }];
    
    
}

#pragma mark    创建视图
/**
 *  在getView方法中进行视图的创建
 */
- (void)getView {
    [self.hud hide:YES];
    
    WebViewController *webVC = [[WebViewController alloc] init];
    _functionVIew.pushview = ^(){
        [self.navigationController pushViewController:webVC animated:NO];
    };
    self.serviceView.jumpView = ^() {
        [self.navigationController pushViewController:webVC animated:NO];
    };
    
    //  跳转到测试账号登录页面
    SIPPhoneHomeViewController *sipVC = [[SIPPhoneHomeViewController alloc] init];
    //  蓝牙页面
    DeviceTableViewController *deviceVC = [[DeviceTableViewController alloc] init];
    _entranceGuardView.jump = ^(NSInteger section) {
        if (section == 0) {
            NSLog(@"蓝牙页面");
//            [self presentViewController:deviceVC animated:YES completion:^{
//                
//            }];
            [self.navigationController pushViewController:deviceVC animated:YES];
        } else {
            [self presentViewController:sipVC animated:YES completion:^{
            }];
        }
        
            
    };
    
}

#pragma mark    导航栏设置
- (void)createNavigationbar {
    self.navigationController.navigationBar.translucent = NO;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50 * WID, 30 * HEI)];
    label.text = @"千家乐";
    //    label.textColor = [UIColor blueColor];
    self.navigationItem.titleView = label;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Local32"] style:UIBarButtonItemStylePlain target:self action:@selector(localclick:)];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"door32"] style:UIBarButtonItemStylePlain target:self action:@selector(functionclick:)];
    
}

#pragma mark    门禁
- (void)functionclick:(id)sender {
    if (_entranceGuardView.hidden == NO) {
        _entranceGuardView.hidden = YES;
    } else {
        self.entranceGuardView.hidden = NO;
    }
}

- (void)localclick:(id)sender {
    if (_areaView.hidden == NO) {
        _areaView.hidden = YES;
    } else {
        _areaView.hidden = NO;
    }
}

#pragma mark    传值
- (void)getValue {
    //  轮播图
//    _adView = [[BaseScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 170 * HEI)];
//    _adView.arr= self.dataArrThird;
//    [self.view addSubview:_adView];
//    _adView.arr = [NSMutableArray array];
//    _adView.backgroundColor = [UIColor whiteColor];
    
    WYScrollView *wyScrollView = [[WYScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 170 * HEI) WithNetImages:self.dataArrThird];
    [self.view addSubview:wyScrollView];
    wyScrollView.AutoScrollDelay = 3;
    wyScrollView.netDelagate = self;
    
    //  中部图标
    self.functionVIew = [[HomepageView alloc] initWithFrame:CGRectMake(0, 173 * HEI, WIDTH, 160 * HEI)];
    [self.view addSubview:_functionVIew];
    
    self.functionVIew.tempArr = [NSMutableArray array];
    self.functionVIew.tempArr = self.dataArrFirst;

    //  下部图标
    self.serviceView = [[ServiceView alloc] initWithFrame:CGRectMake(0, 335 * HEI, WIDTH, 160 * HEI)];
    [self.view addSubview:self.serviceView];
    self.serviceView.tempArr = self.dataArrFirst;
    
    //  地区
    self.areaView = [[AreaView alloc] initWithFrame:CGRectMake(0, 0, 80 * WID, 270 * HEI)];
    [self.view addSubview:self.areaView];
    self.areaView.arr = self.dataArrSecond;
    _areaView.hidden = YES;
    
    //  门禁
    self.entranceGuardView = [[EntranceGuardView alloc] initWithFrame:CGRectMake(255 * WID, 0, 120 * WID, 270 * HEI)];
    [self.view addSubview:self.entranceGuardView];
    _entranceGuardView.hidden = YES;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didSelectedNetImageAtIndex:(NSInteger)index {
    NSLog(@"index: %ld", index);
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
