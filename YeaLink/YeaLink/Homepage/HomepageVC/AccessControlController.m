//
//  AccessControlController.m
//  YeaLink
//
//  Created by 李根 on 16/6/7.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "AccessControlController.h"
#import <MessageUI/MessageUI.h>
#import "DeviceTableViewController.h"
#import "SIPPhoneHomeViewController.h"

#import "AccessControlView.h"
#import "DropDownListView.h"
#import "DropListView.h"

#import "OwnerModel.h"

#import "OwnerInfor.h"  //  业主信息
#import "ShareTools.h"
#import "ObseverCalling.h"

@interface AccessControlController ()<MFMessageComposeViewControllerDelegate>
@property(nonatomic, strong)VisitorView *visitorView;   //  访客密码
@property(nonatomic, strong)AccessControlView *accessView;
@property(nonatomic, strong)DropDownListView *dropListView; //  门禁开门下拉列表
@property(nonatomic, strong)DropListView *dropView; //  访客密码下拉列表
@property(nonatomic, strong)NSMutableArray *ownerArr;  //  业主信息

@property(nonatomic, strong)void(^setAddress)();    //  设置地址栏显示
@end

@implementation AccessControlController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    ObseverCalling *obser = [ObseverCalling shareObseverCalling];
    
    obser.addVideoView = ^() {};
    obser.whenCallIdle = ^() {};
    obser.whenInComingReceived = ^() {
        _accessView.videoBtn.slideBtn.backgroundColor = CUSTOMBLUE;
        _accessView.videoBtn.slideBtn.enabled = YES;
    };
    obser.whenCallConnected = ^() {};
    obser.whenCallEnd = ^() {};
    obser.displayInComingCall = ^() {};
    obser.beingForground = ^() {};
    
    [obser updateOnShow];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self settingNavigationbar];

    self.view.userInteractionEnabled = YES;
    
    [self questData];
    
    
}

#pragma mark    - 请求数据
- (void)questData {
    __weak AccessControlController *blockSelf = self;
    _ownerArr = [NSMutableArray array];
//    _ownerArr = [OwnerInfor getOwnerInfor];
//    NSLog(@"_________%lu", arr.count);
    NSString *strUrl = [NSString stringWithFormat:@"%@/api/APIVillageManage/BindVillageList?UserID=%@", COMMONURL, [UserInformation userinforSingleton].usermodel.UserID];
    NSLog(@"业主信息接口: %@", strUrl);
    [NetWorkingTool getNetWorking:strUrl block:^(id result) {
        
        _ownerArr = [OwnerModel baseModelByArray:result[@"List"]];
        
        //  如果没有默认选择, 就自动默认存储第一个为默认小区
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"defaultVillage"] == nil) {
            [UserInformation saveOwnerInforToLocalWithModel:_ownerArr[0]];
        }

        self.setAddress();
        [self getView];
    }];
    
    self.setAddress = ^() {
        OwnerModel *model = blockSelf.ownerArr[0];
        blockSelf.accessView.addressField.text = model.VName;
    };

}

#pragma mark    - NavigationBar
- (void)settingNavigationbar {
    QJLBaseLabel *label = [QJLBaseLabel LabelWithFrame:CGRectMake(0, 0, 50 * WID, 30 * HEI) text:@"门禁开门" titleColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter font:[UIFont systemFontOfSize:21]];
    self.navigationItem.titleView = label;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
    
    [self createView];
}

- (void)createDropListViewWith:(DropDownListView *)dropView WithFrame:(CGRect)rect {
    __weak AccessControlController *blockSelf = self;
    
    [dropView removeFromSuperview];
    dropView = [[DropDownListView alloc] initWithFrame:rect];
    [blockSelf.view addSubview:dropView];
    [dropView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(blockSelf.accessView.view);
        make.top.equalTo(blockSelf.accessView.view.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(rect.size.width, rect.size.height));
    }];
    
    dropView.arr = [NSMutableArray array];
    dropView.arr = blockSelf.ownerArr;
    
    dropView.selectVillage = ^() {
        [dropView removeFromSuperview];
    };
}

- (void)createView {
    __weak AccessControlController *blockSelf = self;
    
    _accessView = [[AccessControlView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT - 49 - 64)];
    [self.view addSubview:_accessView];
    _accessView.backgroundColor = [UIColor colorWithHex:0xf4f4f4];
    
    _accessView.clickAddress = ^() {
        
            [blockSelf.dropListView removeFromSuperview];
            _dropListView = [[DropDownListView alloc] initWithFrame:CGRectMake(0, 0, 225 * WID, 100 * HEI)];
            [blockSelf.view addSubview:blockSelf.dropListView];
            [blockSelf.dropListView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(blockSelf.accessView.view);
                make.top.equalTo(blockSelf.accessView.view.mas_bottom);
                make.size.mas_equalTo(CGSizeMake(225 * WID, 100 * HEI));
            }];
            
            blockSelf.dropListView.arr = [NSMutableArray array];
            blockSelf.dropListView.arr = blockSelf.ownerArr;
        
            blockSelf.dropListView.selectVillage = ^() {
                [blockSelf.dropListView removeFromSuperview];
            };
    };
    
    
    
#pragma mark    - 功能模块
    SIPPhoneHomeViewController *sipVC = [[SIPPhoneHomeViewController alloc] init];
    _accessView.videoBtn.slideBtn.operate = ^() {
        
        [blockSelf.navigationController pushViewController:sipVC animated:YES];

    };
    
    DeviceTableViewController *deviceVC = [[DeviceTableViewController alloc] init];
    _accessView.blueToothBtn.slideBtn.operate = ^() {
        [blockSelf.navigationController pushViewController:deviceVC animated:YES];
    };
    _accessView.passwordBtn.slideBtn.operate = ^() {
        //  遮盖视图
        [blockSelf.accessView.coverView removeFromSuperview];
        blockSelf.accessView.coverView = [[QJLBaseView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
        [blockSelf.view.window addSubview:blockSelf.accessView.coverView];
        blockSelf.accessView.coverView.backgroundColor = [UIColor lightGrayColor];
        blockSelf.accessView.coverView.alpha = 0.6;
        
        //  访客密码视图
        [blockSelf.visitorView removeFromSuperview];
        blockSelf.visitorView = [[VisitorView alloc] init];
        [blockSelf.view.window addSubview:blockSelf.visitorView];
        blockSelf.visitorView.layer.cornerRadius = 7;
        blockSelf.visitorView.clipsToBounds = YES;
        blockSelf.visitorView.backgroundColor = [UIColor whiteColor];
        [blockSelf.visitorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(300 * WID, 300 * HEI));
            make.centerX.equalTo(blockSelf.view);
            make.centerY.equalTo(blockSelf.view).with.offset(-blockSelf.view.frame.size.height / 10);
        }];
        
        [blockSelf.visitorView.wechatBtn.topBtn addTarget:blockSelf action:@selector(wechatClick:) forControlEvents:UIControlEventTouchUpInside];
        [blockSelf.visitorView.qqBtn.topBtn addTarget:blockSelf action:@selector(qqClick:) forControlEvents:UIControlEventTouchUpInside];
        [blockSelf.visitorView.smsBtn.topBtn addTarget:blockSelf action:@selector(smsClick:) forControlEvents:UIControlEventTouchUpInside];
        
        blockSelf.visitorView.removeView = ^() {
            [blockSelf.accessView.coverView removeFromSuperview];
            [blockSelf.visitorView removeFromSuperview];
        };
        
        blockSelf.visitorView.selectVillage = ^() {
            [blockSelf.dropView removeFromSuperview];
            _dropView = [[DropListView alloc] initWithFrame:CGRectMake(0, 0, 235 * WID, 100 * HEI)];
            [blockSelf.visitorView addSubview:blockSelf.dropView];
            [blockSelf.dropView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(blockSelf.visitorView.coverAddressView);
                make.top.equalTo(blockSelf.visitorView.coverAddressView.mas_bottom);
                make.size.mas_equalTo(CGSizeMake(235 * WID, 100 * HEI));
            }];
            
            blockSelf.dropView.arr = [NSMutableArray array];
            blockSelf.dropView.arr = blockSelf.ownerArr;
            
            blockSelf.dropView.selectVillage = ^() {
                [blockSelf.dropView removeFromSuperview];
                NSArray *arr = [UserInformation getEightPassword];
                OwnerModel *model = arr[0];
                NSString *randomPassword = arr[1];
                
                blockSelf.visitorView.addressField.text = [NSString stringWithFormat:@"%@%@栋", model.VName, model.BID];
                blockSelf.visitorView.entranceField.text = [NSString stringWithFormat:@"%@室", model.RID];
                blockSelf.visitorView.randomLabel.text = randomPassword;
            };
            
            //  显示下拉框的标题
            blockSelf.dropView.showTitle = ^(OwnerModel *model) {
                blockSelf.visitorView.entranceField.text = [NSString stringWithFormat:@"%@室", model.RID];
                blockSelf.visitorView.addressField.text = [NSString stringWithFormat:@"%@%@栋", model.VName, model.BID];
            };

        };
    };
    
    
}

#pragma mark    - 分享
- (void)wechatClick:(id)sender {
    [ShareTools shareWithText:self.visitorView.randomLabel.text images:nil urlStr:nil title:nil type:22];
}

- (void)qqClick:(id)sender {
    [ShareTools shareWithText:self.visitorView.randomLabel.text images:nil urlStr:nil title:nil type:24];
}
#pragma mark    - 短信分享
- (void)smsClick:(id)sender {
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
    
    if (messageClass != nil) {
        //  check wheather the current device is configurd for sending SMS Messages
        if ([messageClass canSendText]) {
            [self displaySMSComposeMessage];
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Your device don't support SMS function!" message:nil delegate:self cancelButtonTitle:@"YES" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)displaySMSComposeMessage {
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    NSString *smsBody = [NSString stringWithFormat:@"千家乐访客密码: %@\n, 今日有效!", self.visitorView.randomLabel.text];
    messageController.body = smsBody;
    
    //  要先移除视图, 否则有bug
    [self.accessView.coverView removeFromSuperview];
    [self.visitorView removeFromSuperview];
    [self presentViewController:messageController animated:YES completion:nil];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    [self dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"%d", result);
}

- (void)backAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getView {
    
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
