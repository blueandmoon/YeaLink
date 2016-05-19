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

@interface MyViewController ()

@end

@implementation MyViewController
{
    PersonCenterView *_personView;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataArrFirst = [NSMutableArray array];

    
    [self settingNavigationbar];
    
    [self questData];
}

- (void)settingNavigationbar {
    QJLBaseLabel *label = [QJLBaseLabel LabelWithFrame:CGRectMake(0, 0, 50 * WID, 30 * HEI) text:@"个人中心" titleColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter font:[UIFont systemFontOfSize:19]];
    self.navigationItem.titleView = label;
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
    }];
    
}

- (void)getValue {
    _personView = [[PersonCenterView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    [self.view addSubview:_personView];
    
    _personView.arr = [NSMutableArray arrayWithArray:self.dataArrFirst];
    
    
}

- (void)getView {
    SettingViewController *settingVC = [[SettingViewController alloc] init];
//    _personView.pushView = ^() {
//        [self.navigationController pushViewController:settingVC animated:YES];
//    };
    
    SetWebViewController *setWebVC = [[SetWebViewController alloc] init];
//    _personView.jumpView = ^() {
////        [self.navigationController pushViewController:setWebVC animated:YES];
//        [self presentViewController:setWebVC animated:YES completion:^{
//            
//        }];
//    };
    
    _personView.pushView = ^(NSInteger section) {
        NSLog(@"section: %ld", section);
        if (section < 4) {
            [self.navigationController pushViewController:setWebVC animated:YES];
        } else {
            [self.navigationController pushViewController:settingVC animated:YES];
        }
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
