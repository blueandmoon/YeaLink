//
//  QJLBaseViewController.m
//  YeaLink
//
//  Created by 李根 on 16/4/24.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "QJLBaseViewController.h"

@interface QJLBaseViewController ()

@end

@implementation QJLBaseViewController

- (instancetype)init {
    if (self == [super init]) {
        //  会影响导航栏上所有除返回以外的按钮
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //  定位
    [UserLocation shareGpsManager];
    
}

- (void)questData {
    
}

- (void)newData {
    
}

- (void)getView {
    
}

- (void)getValue {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"did receive Memory Warning!");
    [ReportMemory reportCurrentMemory];
//    NSLog(@"~~~~~~~~~~~%@~~~~~~~~~~~%d", (int)OSMemoryNotificationLevelNormal);
    [self addObserver:self forKeyPath:UIApplicationDidReceiveMemoryWarningNotification options:0 || 1 context:nil];
    
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
