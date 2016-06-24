//
//  HomepageViewController.m
//  YeaLink
//
//  Created by 李根 on 16/4/24.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "HomepageViewController.h"
#import "AreaModel.h"
#import "ServiceModel.h"
#import "UserModel.h"

#import "BaseScrollView.h"
#import "WYScrollView.h"
#import "LeftView.h"

#import "RegisterViewController.h"
#import "LoginViewController.h"
#import "TestLoginViewController.h"
#import "WebViewController.h"
#import "SIPPhoneHomeViewController.h"
#import "DeviceTableViewController.h"   //  扫描发现的蓝牙设备列表
#import "BindingCellController.h"   //  绑定小区
#import "AccessControlController.h" //  门禁开门

#import "SIPLogin.h"

@interface HomepageViewController ()<WYScrollViewNetDelegate, CLLocationManagerDelegate>

@property(nonatomic, strong)BaseScrollView *scrollView;
@property(nonatomic, strong)HomepageView *functionVIew;
@property(nonatomic, strong)ServiceView *serviceView;
@property(nonatomic, strong)AreaView *areaView;
@property(nonatomic, strong)EntranceGuardView *entranceGuardView;
@property(nonatomic, strong)BaseScrollView *adView;

@end

@implementation HomepageViewController
{
    CLLocationManager *_locationManager;
    LoginViewController *_loginVC;
    LeftView *_leftview;
    WYScrollView *_wyScrollView;
}

- (instancetype)init {
    if (self = [super init]) {
        
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark    - ViewWillAppear
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    self.tabBarController.tabBar.hidden = NO;
}

#pragma mark    - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.dataArrFirst = [NSMutableArray array];
    self.dataArrSecond = [NSMutableArray array];
    self.dataArrThird = [NSMutableArray array];
    
    //  配合3DTouch跳转页面的, 无后台情况下
    SIPPhoneHomeViewController *sipVC = [[SIPPhoneHomeViewController alloc] init];
    DeviceTableViewController *deviceVC = [[DeviceTableViewController alloc] init];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isFrom3DTouchVideo"] isEqualToString:@"1"]) {
        [self.navigationController pushViewController:sipVC animated:NO];
    } else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isFrom3DTouchBlueTooth"] isEqualToString:@"1"]) {
        [self.navigationController pushViewController:deviceVC animated:NO];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(entranceType:) name:@"entranceType" object:nil];
    
    //  创建视图
    [self createView];
    //  加载数据
    [self questData];
    //  设置导航栏
    [self createNavigationbar];
    //  展示菊花    放在最下面, 才会出现, 要不会被遮住
    self.hud = [BaseProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.frame = CGRectMake(100 * WID, 200 * HEI, 100 * WID, 100 * HEI);
    self.hud.labelText = @"loading...";
}
#pragma mark    - 自动登录
- (void)autoLogin {
    __weak HomepageViewController *blockSelf = self;
    _loginVC = [[LoginViewController alloc] init];
    
    UINavigationController *loginNaVC = [[UINavigationController alloc] initWithRootViewController:_loginVC];
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"UserName"] == nil) {
        [self presentViewController:loginNaVC animated:NO completion:NULL];
    } else {
        
    //  判断是否登录
    NSString *username = [[NSUserDefaults standardUserDefaults] stringForKey:@"UserName"];
    NSString *password = [[NSUserDefaults standardUserDefaults] stringForKey:@"Password"];
    NSString *strURL = [NSString stringWithFormat:@"%@api/APIUserManage/APPloginByIOS?UserID=%@&PassWord=%@", COMMONURL, username, password];
    NSLog(@"自动登录接口: %@", strURL);
    [NetWorkingTool getNetWorking:strURL block:^(id result) {
        if ([result[@"code"] isEqualToString:@"1"]) {
            NSLog(@"自动登录成功code: %@", result[@"code"]);
            //  同时登录全视通平台
            [SIPLogin loginSIP];
        
            [UserInformation questUserInformationWith:username];
            NSLog(@"自动登录成功");
            [UserInformation userinforSingleton].doSomething = ^() {
                //  登录成功, 请求首页数据
                [self getHomepageData];
            };
        } else {
            [self presentViewController:_loginVC animated:NO completion:NULL];
        }
    }];
    }
    _loginVC.afterLoginSuccessToGetHomepageData = ^() {
        [blockSelf getHomepageData];
    };
}

#pragma mark    请求数据
- (void)questData {
    //  地区数据
    [self getAreaData];
    //  自动登录, 成功则获取首页数据
    [self autoLogin];
}

- (void)getAreaData {
    NSString *str= [NSString stringWithFormat:@"%@api/APICityManage/GetCity", COMMONURL];
    [NetWorkingTool getNetWorking:str block:^(id result) {
        self.dataArrSecond = [AreaModel baseModelByArray:result[@"list"]];
    }];
}

- (void)getHomepageData {
    NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
    NSString *cityID = [userdef objectForKey:@"cityID"];
    NSString *authoLevel = [userdef objectForKey:@"APPUserRole"];
    NSString *userID = [userdef objectForKey:@"UserID"];
    NSString *tempStr = [NSString stringWithFormat:@"%@api/APIAppIndex/GetAppIndexSeviceListByIOS?CityID=%@&AuthoLevel=%@&UserID=%@", COMMONURL, cityID, authoLevel, userID];
    //  @"http://qianjiale.doggadatachina.com/api/APIAppIndex/GetAppIndexSeviceListByIOS?CityID=320501&AuthoLevel=2&UserID=18112572968"
    NSLog(@"首页接口tempStr: %@", tempStr);
    [NetWorkingTool getNetWorking:tempStr block:^(id result) {
        //  轮播图
        self.dataArrThird = [ServiceModel baseModelByArray:result[@"AdvList"]];
        //  中部, 下部
        self.dataArrFirst = [ServiceModel baseModelByArray:result[@"ServiceList"]];
        
        [self getValue];
        [self getView];
        
        [self.hud hide:YES];
    }];
}

#pragma mark    - 设置导航栏
- (void)createNavigationbar {
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = CUSTOMBLUE;
    __weak HomepageViewController *blockSelf = self;
    
    QJLBaseLabel *label = [QJLBaseLabel LabelWithFrame:CGRectMake(0, 0, 50 * WID, 30 * HEI) text:@"千家乐" titleColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter font:[UIFont systemFontOfSize:19]];
    //    label.textColor = [UIColor blueColor];
    self.navigationItem.titleView = label;
    
    _leftview = [[LeftView alloc] initWithFrame:CGRectMake(0, 0, 90 * WID, 30 * HEI)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_leftview];
    _leftview.label.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"cityName"];
    _leftview.tapAction = ^() {
        [blockSelf localclick];
    };
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"doorg-1"] style:UIBarButtonItemStylePlain target:self action:@selector(functionclick:)];
    
    //  会影响导航栏上所有除返回以外的按钮, 执行顺序会有影响
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    //  要在上面代码之后设置才起作用
    _leftview.backgroundColor = CUSTOMBLUE;
}

#pragma mark    门禁
- (void)functionclick:(id)sender {
    if (_entranceGuardView.hidden == NO) {
        _entranceGuardView.hidden = YES;
    } else {
        self.entranceGuardView.hidden = NO;
    }
}

- (void)localclick {
    if (_areaView.hidden == NO) {
        _areaView.hidden = YES;
        [_areaView.tableView reloadData];
    } else {
        _areaView.hidden = NO;
    }
}

- (void)createView {
    //  轮播图
    _wyScrollView = [[WYScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 170 * HEI) WithNetImages:self.dataArrThird];
    [self.view addSubview:_wyScrollView];
    _wyScrollView.AutoScrollDelay = 3;
    _wyScrollView.netDelagate = self;
    
    //  中部图标
    self.functionVIew = [[HomepageView alloc] initWithFrame:CGRectMake(0, 173 * HEI, WIDTH, 160 * HEI)];
    [self.view addSubview:_functionVIew];
    self.functionVIew.tempArr = [NSMutableArray array];
//    self.functionVIew.tempArr = self.dataArrFirst;
    
    //  下部图标
    self.serviceView = [[ServiceView alloc] initWithFrame:CGRectMake(0, 335 * HEI, WIDTH, 160 * HEI)];
    [self.view addSubview:self.serviceView];
    self.serviceView.tempArr = [NSMutableArray array];
//    self.serviceView.tempArr = self.dataArrFirst;
    
    //  地区
    self.areaView = [[AreaView alloc] initWithFrame:CGRectMake(0, 0, 80 * WID, 270 * HEI)];
    [self.view addSubview:self.areaView];
//    self.areaView.arr = self.dataArrSecond;
    _areaView.hidden = YES;
    
    //  门禁
    self.entranceGuardView = [[EntranceGuardView alloc] initWithFrame:CGRectMake(255 * WID, 0, 120 * WID, 270 * HEI)];
    [self.view addSubview:self.entranceGuardView];
    _entranceGuardView.hidden = YES;
    
}

#pragma mark    传值
- (void)getValue {
    //  轮播图
    //  先从父视图移除, 否则会创建多次
    [_wyScrollView removeFromSuperview];
//    [self.view addSubview:_wyScrollView];
    _wyScrollView = [[WYScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 170 * HEI) WithNetImages:self.dataArrThird];
    [self.view addSubview:_wyScrollView];
    _wyScrollView.AutoScrollDelay = 3;
    _wyScrollView.netDelagate = self;
    
    //  中部图标
    self.functionVIew.tempArr = [NSMutableArray array];
    self.functionVIew.tempArr = self.dataArrFirst;
    
    //  下部图标
    self.serviceView.tempArr = [NSMutableArray array];
    self.serviceView.tempArr = self.dataArrFirst;
    
    //  地区
    [self.view addSubview:self.areaView];
    self.areaView.arr = self.dataArrSecond;
    
    //  将门禁列表视图总是放在表层
    [self.view bringSubviewToFront:_entranceGuardView];
}

#pragma mark    -   跳转视图
/**
 *  在getView方法中进行视图的创建
 */
- (void)getView {
    [self.hud hide:YES];
    
    
    //  解决block的循环引用警告问题
    __weak HomepageViewController *blockSelf = self;
    
    WebViewController *webVC = [[WebViewController alloc] init];
    
    UINavigationController *homeNavi = [[UINavigationController alloc] initWithRootViewController:webVC];
    
    _functionVIew.pushview = ^(){
        [blockSelf presentViewController:homeNavi animated:YES completion:^{
            [webVC createWebviewWithURL:[UserInformation userinforSingleton].strURL];
            
        }];
    };
    
    AccessControlController *accessVC = [[AccessControlController alloc] init];
    _functionVIew.pushViewToAccessControl = ^() {
        [blockSelf.navigationController pushViewController:accessVC animated:YES];
    };
    self.serviceView.jumpView = ^() {
        [blockSelf presentViewController:homeNavi animated:YES completion:^{
            [webVC createWebviewWithURL:[UserInformation userinforSingleton].strURL];
        }];
    };
    
    //  跳转到测试账号登录页面
    SIPPhoneHomeViewController *sipVC = [[SIPPhoneHomeViewController alloc] init];
//    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isFrom3DTouchVideo"] isEqualToString:@"1"]) {
//        [self.navigationController pushViewController:sipVC animated:YES];
//    }
    //  蓝牙页面
    DeviceTableViewController *deviceVC = [[DeviceTableViewController alloc] init];
    _entranceGuardView.jump = ^(NSInteger section) {
        if (section == 0) {
//            NSLog(@"蓝牙页面");
            //            [self presentViewController:deviceVC animated:YES completion:^{
            //
            //            }];
            [blockSelf.navigationController pushViewController:deviceVC animated:YES];
        } else {
            [blockSelf.navigationController pushViewController:sipVC animated:YES];
//            [self presentViewController:sipVC animated:YES completion:^{
//            }];
        }
    };
    
    //  如果非业主, 跳到绑定业主页面
    BindingCellController *bindingVC = [[BindingCellController alloc] init];
    _functionVIew.pushBindingView = ^(){
        [blockSelf.navigationController pushViewController:bindingVC animated:YES];
    };
    bindingVC.refreshDataWithSwitchNeighbour = ^() {
        [UserInformation questUserInformationWith:[UserInformation userinforSingleton].usermodel.UserID];
    };
    
    _areaView.setLeftNavigationItem = ^(AreaModel *model) {
        _leftview.label.text = model.cityName;
        [self getHomepageData];
    };
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didSelectedNetImageAtIndex:(NSInteger)index {
    NSLog(@"index: %ld", index);
}

#pragma mark    - 接收3DTouch传来的值
- (void)entranceType:(NSNotification *)notice {
    SIPPhoneHomeViewController *sipVC = [[SIPPhoneHomeViewController alloc] init];
    DeviceTableViewController *blueToothVC = [[DeviceTableViewController alloc] init];
    
    if ([notice.userInfo[@"type"] isEqualToString:@"com.huize.video"]) {
        [self.navigationController pushViewController:sipVC animated:YES];
    } else {
        [self.navigationController pushViewController:blueToothVC animated:YES];
    }
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
