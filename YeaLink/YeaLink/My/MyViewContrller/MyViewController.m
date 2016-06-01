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

//  测试分享
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDKUI.h>

@interface MyViewController ()

@end

@implementation MyViewController
{
    BindingCellController *_bindingCellVC;
    SettingViewController *_settingVC;
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

    //  测试分享功能
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"分享" style:UIBarButtonItemStylePlain target:self action:@selector(shareAction:)];
    
}

- (void)shareAction:(id)sender {
    //1、创建分享参数
    NSArray* imageArray = @[[UIImage imageNamed:@"back"]];
    //  （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    if (imageArray) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"分享内容"
                                         images:imageArray
                                            url:[NSURL URLWithString:COMMONURL]
                                          title:@"分享标题"
                                           type:SSDKContentTypeAuto];
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                 items:nil
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       
                       switch (state) {
                           case SSDKResponseStateSuccess:
                           {
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           default:
                               break;
                       }
                   }
         ];}
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
    SetWebViewController *setWebVC = [[SetWebViewController alloc] init];
    ResetPasswordController *resetVC = [[ResetPasswordController alloc] init];
    _bindingCellVC = [[BindingCellController alloc] init];
    _personView.pushView = ^(NSInteger section, NSInteger userRole) {
        if (section == 1) {
            //  重置密码
            [blockSelf.navigationController pushViewController:resetVC animated:YES];
        } else if (section == 4) {
            //  设置
            [blockSelf.navigationController pushViewController:_settingVC animated:YES];
        } else if (section == 2) {
            if (userRole == 1) {
                //  个人用户绑定小区
                [blockSelf.navigationController pushViewController:_bindingCellVC animated:YES];
            } else {
                //  设置里点击Cell跳转的webview
                [blockSelf.navigationController pushViewController:setWebVC animated:YES];
            }
        } else {
            //  设置里点击Cell跳转的webview
            [blockSelf.navigationController pushViewController:setWebVC animated:YES];

        }
    };
    
    //  刷新数据
    _settingVC.refreshData = ^() {
        [blockSelf questData];
    };
    
    _bindingCellVC.refreshDataWithSwitchNeighbour = ^() {
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
