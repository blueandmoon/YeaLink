//
//  ShowViewController.m
//  YeaLink
//
//  Created by 李根 on 16/4/24.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "ShowViewController.h"
#import "ShowWebViewController.h"
#import "ShowView.h"

#define SETHIDDEN \
if (_showView.hidden == YES) {  \
    _showView.hidden = NO;  \
} else {    \
    _showView.hidden = YES; \
}


#define SAVESELECT(select) \
[[NSUserDefaults standardUserDefaults] setObject:select forKey:@"rightShowTitle"];  \
[[NSUserDefaults standardUserDefaults] synchronize];    \

@interface ShowViewController ()
@property(nonatomic, strong)ShowView *showView;
@property(nonatomic, strong)NSString *defaultVillage;   //  默认小区
@property(nonatomic, strong)QJLBaseButton *rightBtn;    //  右边按钮

@end

@implementation ShowViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"selectPhoto"] isEqualToString:@"1"]) {
        [self getHtmlWithstr:@"show/showindex"];
    }
    
    //  个人用户显示默认城市, 业主为默认小区
    if ([[UserInformation userinforSingleton].usermodel.APPUserRole isEqualToString:@"1"]) {    //  个人用户
        [_rightBtn setTitle:@"默认城市" forState:UIControlStateNormal];
        SAVESELECT(@"默认城市");
        
        } else {
            [_rightBtn setTitle:@"默认小区" forState:UIControlStateNormal];
            SAVESELECT(@"默认小区");
//            [self questData];
        }
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataArrFirst = [NSMutableArray array];
    
    _rightBtn = [QJLBaseButton buttonCustomFrame:CGRectMake(0, 0, 100, 30) title:@"" currentTitleColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBtn];
    _rightBtn.font = [UIFont systemFontOfSize:13];
    _rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_rightBtn addTarget:self action:@selector(villageClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self getValue];
    
    [self settingNavigationbar];
    
    self.backNative = ^() {
        
    };
    
    
}

- (void)getValue {
    _showView = [[ShowView alloc] initWithFrame:CGRectMake(255 * WID, 0, 170 * WID, 150 * HEI)];
    [self.view addSubview:_showView];
    _showView.backgroundColor = [UIColor redColor];
    _showView.hidden = YES;
    _showView.arr = [NSMutableArray array];
    
}

- (void)click:(id)sender {
    
}

/*
- (void)questData {
    __weak ShowViewController *blockSelf = self;
    NSString *strUrl = [NSString stringWithFormat:@"%@/api/APIVillageManage/BindVillageList?UserID=%@", COMMONURL, [UserInformation userinforSingleton].usermodel.UserID];
    NSLog(@"业主信息接口: %@", strUrl);
    [NetWorkingTool getNetWorking:strUrl block:^(id result) {
        
        self.dataArrFirst = [OwnerModel baseModelByArray:result[@"List"]];
        OwnerModel *model = self.dataArrFirst[0];
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:model.VName style:UIBarButtonItemStylePlain target:self action:@selector(villageClick:)];
        _rightBtn.titleLabel.text = model.VName;
        [_rightBtn addTarget:self action:@selector(villageClick:) forControlEvents:UIControlEventTouchUpInside];
        
        //  保存信息
        [blockSelf saveRightTitleWith:model.VName];
    }];
    
}
*/

- (void)saveRightTitleWith:(id)sender {
    //  保存信息
    [[NSUserDefaults standardUserDefaults] setObject:sender forKey:@"rightShowTitle"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)villageClick:(id)sender {
    __weak ShowViewController *blockSelf = self;
    
    [self.view bringSubviewToFront:_showView];
    
    SETHIDDEN;
    
    if ([UserInformation userinforSingleton].usermodel.APPUserRole.integerValue == 1) {
        _showView.arr= @[@"全国", @"默认城市"];
    } else {
        _showView.arr = @[@"全国", @"默认城市", @"默认小区"];
    }
    //  要传的值
     NSArray *takeArr = @[@"all", @"C", @"V"];
    _showView.selectVillage = ^(NSString *select) {
//        [blockSelf saveRightTitleWith:select];
        
        for (NSInteger i = 0; i < blockSelf.showView.arr.count; i++) {
            if ([blockSelf.showView.arr[i] isEqualToString:select]) {
                NSString *jsStr = [blockSelf.wv stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"SearchShow('%@');", takeArr[i]]];
                NSLog(@"jsStr: %@", jsStr);
            }
            
            SETHIDDEN;
            
            
        }
        blockSelf.navigationItem.rightBarButtonItem.title = select;
        [blockSelf.rightBtn setTitle:select forState:UIControlStateNormal];
    };
    
}

- (void)settingNavigationbar {
    __weak ShowViewController *blockSelf = self;
    QJLBaseLabel *label = [QJLBaseLabel LabelWithFrame:CGRectMake(0, 0, 200 * WID, 30 * HEI) text:@"秀场" titleColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter font:[UIFont systemFontOfSize:19]];
    self.navigationItem.titleView = label;
    self.navigationController.navigationBar.barTintColor = CUSTOMBLUE;
    self.takeStr = ^(NSString *currentTitle) {
        label.text = currentTitle;
        
        NSString *currentURL = blockSelf.wv.request.URL.absoluteString;
        if ([currentURL rangeOfString:@"showindex?"].location != NSNotFound) {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_rightBtn];
        } else {
            blockSelf.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"share"] style:UIBarButtonItemStylePlain target:blockSelf action:@selector(share:)];
        }
    };
    label.numberOfLines = 0;
    [label sizeToFit];
    
    self.changeShowLeftButton = ^(NSString *typeStr) {
        if ([typeStr rangeOfString:@"showindex?"].location != NSNotFound) {
            //  在秀场主页面
            blockSelf.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"camera"] style:UIBarButtonItemStylePlain target:blockSelf action:@selector(leftAction:)];
//            [blockSelf.rightBtn setTitle:[[NSUserDefaults standardUserDefaults] objectForKey:@"rightShowTitle"] forState:UIControlStateNormal];
            
        } else {
            blockSelf.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:blockSelf action:@selector(back:)];
//            blockSelf.navigationItem.rightBarButtonItem.title = @"";
        }
    };
//    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"camera"] style:UIBarButtonItemStylePlain target:self action:@selector(leftAction:)];
    
}

- (void)share:(id)sender {
    
    //  获取当前页面的标题
    NSString *title = [self.wv stringByEvaluatingJavaScriptFromString:@"document.title"];
//    _takeStr(title);
    //    NSLog(@"当前页面标题title:%@", title);
    
    //  获取当前页面的链接, 向发现和秀场
    NSString *currentURL = self.wv.request.URL.absoluteString;
    NSLog(@"currentURL---url-%@--", currentURL);
    
    [ShareTools goToShareWithText:title url:[NSURL URLWithString:currentURL]];
}

- (void)back:(id)sender {
    self.backforH5(self.wv);
}

- (void)leftAction:(id)sender {
    //  Show/SendShowWords
    [UserInformation userinforSingleton].strURL = @"Show/SendShowWords";
    ShowWebViewController *showWebVC = [[ShowWebViewController alloc] init];
    [self.navigationController pushViewController:showWebVC animated:YES];
//    [self presentViewController:findWebVC animated:YES completion:^{
//        
//    }];
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
