//
//  MyViewController.m
//  YeaLink
//
//  Created by 李根 on 16/4/24.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "MyViewController.h"
#import "PersonCenterView.h"
#import "SettingViewController.h"
#import "SettingModel.h"
#import "SetWebViewController.h"
#import "ResetPasswordController.h"
#import "BindingCellController.h"

#import "ClearCache.h"


@interface MyViewController ()<UIAlertViewDelegate>
@property(nonatomic, strong)SettingViewController *settingVC;
@property(nonatomic, strong)SetWebViewController *setWebVC;
@property(nonatomic,strong)BindingCellController *bindingCellVC;;

@end

@implementation MyViewController
{
//    SetWebViewController *_setWebVC;
//    BindingCellController *_bindingCellVC;
//    SettingViewController *_settingVC;
    PersonCenterView *_personView;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataArrFirst = [NSMutableArray array];

    
    [self settingNavigationbar];
    
    
    [self questData];
    
    self.hud = [BaseProgressHUD showHUDAddedTo:self.view animated:YES];
    self.hud.labelText = @"loading";
}

- (void)settingNavigationbar {
    QJLBaseLabel *label = [QJLBaseLabel LabelWithFrame:CGRectMake(0, 0, 50 * WID, 30 * HEI) text:@"个人中心" titleColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter font:[UIFont systemFontOfSize:19]];
    self.navigationItem.titleView = label;
    self.navigationController.navigationBar.barTintColor = CUSTOMBLUE;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"clear cache" style:UIBarButtonItemStylePlain target:self action:@selector(clearCache:)];
}

- (void)clearCache:(id)sender {
    CGFloat cacheSize = [[ClearCache shareClearCache] clearCache];
    NSLog(@"cacheSize: %f", cacheSize);
    UIAlertView *aler = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"The cache is %.2fM", cacheSize] message:nil delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    [aler show];
    
    double delayTime = 2;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [aler dismissWithClickedButtonIndex:0 animated:YES];
    });
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSLog(@"clear Cache");
        [[ClearCache shareClearCache] removeCache];
    }
}

- (void)questData {
    
    //  /api/APIAppPersonalCenter/GetPersonalCenterList?UserID=18112572968
    NSString *str = [NSString stringWithFormat:@"%@/api/APIAppPersonalCenter/GetPersonalCenterList?UserID=%@", COMMONURL, [UserInformation userinforSingleton].usermodel.UserID];
    NSLog(@"%@", str);
    [NetWorkingTool getNetWorking:str block:^(id result) {
        NSArray *list1 = [SettingModel baseModelByArray:result[0][@"List1"]];
        NSArray *list2 = [SettingModel baseModelByArray:result[0][@"List2"]];
        NSArray *list3 = [SettingModel baseModelByArray:result[0][@"List3"]];
        NSArray *list4 = [SettingModel baseModelByArray:result[0][@"List4"]];
        NSArray *list5 = [SettingModel baseModelByArray:result[0][@"List5"]];
        self.dataArrFirst = [NSMutableArray arrayWithObjects:list1, list2, list3, list4, list5, nil];
        
        [self getValue];
        [self getView];
        
        [self.hud hide:YES];
    }];
    
}

- (void)getValue {
    _personView = [[PersonCenterView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    [self.view addSubview:_personView];
    
    _personView.arr = [NSMutableArray arrayWithArray:self.dataArrFirst];
    
    
}

- (void)getView {
    __weak MyViewController *blockSelf = self;
    
    _settingVC = [[SettingViewController alloc] init];
    _setWebVC = [[SetWebViewController alloc] init];
    ResetPasswordController *resetVC = [[ResetPasswordController alloc] init];
    _bindingCellVC = [[BindingCellController alloc] init];
    _personView.pushView = ^(NSInteger section, NSInteger userRole) {
        if (section == 1) {
            //  重置密码
            [blockSelf.navigationController pushViewController:resetVC animated:YES];
        } else if (section == 4) {
            //  设置
            [blockSelf.navigationController pushViewController:blockSelf.settingVC animated:YES];
        } else if (section == 2) {
            if (userRole == 1) {
                //  个人用户绑定小区
                [blockSelf.navigationController pushViewController:blockSelf.bindingCellVC animated:YES];
            } else {
                //  设置里点击Cell跳转的webview
                [blockSelf.navigationController pushViewController:blockSelf.setWebVC animated:YES];
            }
        } else {
            //  设置里点击Cell跳转的webview
            [blockSelf.navigationController pushViewController:blockSelf.setWebVC animated:YES];

        }
    };
    
    //  刷新数据
    _settingVC.refreshData = ^() {
        [blockSelf questData];
    };
    
    _bindingCellVC.refreshDataWithSwitchNeighbour = ^() {
        //  刷新用户信息
        [UserInformation questUserInformationWith:[UserInformation userinforSingleton].usermodel.UserID];
        [blockSelf questData];
        
    };
    
    _setWebVC.refreshDataPerson = ^() {
        [UserInformation questUserInformationWith:[UserInformation userinforSingleton].usermodel.UserID];
        [blockSelf questData];
    };
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
