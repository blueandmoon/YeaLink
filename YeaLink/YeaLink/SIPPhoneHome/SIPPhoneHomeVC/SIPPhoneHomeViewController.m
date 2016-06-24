//
//  SIPPhoneHomeViewController.m
//  YeaLink
//
//  Created by 李根 on 16/4/27.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "SIPPhoneHomeViewController.h"
#import "FVSIPSdk.h"
#import "WebKeyManager.h"

#import "UIAddressTextField.h"
#import "UIDigitButton.h"
#import "UIVideoButton.h"
#import "VideoView.h"

#import "ObseverCalling.h"  //

@interface SIPPhoneHomeViewController ()

@end

@implementation SIPPhoneHomeViewController
{
    VideoView *_mainView;
    BOOL _isCallOut;
//    LinphoneCall *_currentCall;
    QJLBaseImageView *_bgImage; //  背景图片
    QJLBaseImageView *_sceneryImage;    //  视频对讲窗口的占位图
    
}

- (instancetype)init {
    if (self = [super init]) {
//        _currentCall = nil;
        [ObseverCalling shareObseverCalling].currentCall = nil;
    }
    
    return self;
}

#pragma mark    - viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self settingNavigationbar];
    [self getView];
    
    //    if (![[SipCoreManager sharedManager] addAccountWithUserName:@"08" password:@"1234" domain:@"192.168.10.104" transport:kFVSIPTransportTcp]) {
    //        NSLog(@"Add account failed");
    //    }
    
}

#pragma mark    - navigationbar
- (void)settingNavigationbar {
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(leftAction:)];
    
    QJLBaseLabel *label = [QJLBaseLabel LabelWithFrame:CGRectMake(0, 0, 200 * WID, 30 * HEI) text:@"" titleColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter font:[UIFont systemFontOfSize:17]];
    self.navigationItem.titleView = label;
}

//  返回按钮
- (void)leftAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark    - 建立各个view
- (void)getView {
    
    //  新视图
    _mainView = [[VideoView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT)];
    [self.view addSubview:_mainView];
    _mainView.backgroundColor = [UIColor colorWithHex:0xf4f4f4];
    
    //  截图
    [_mainView.coverPhotoBtn addTarget:self action:@selector(getPhoto) forControlEvents:UIControlEventTouchUpInside];
    //  接听
    [_mainView.coverAnswerBtn addTarget:self action:@selector(answer:) forControlEvents:UIControlEventTouchUpInside];
    //  挂断
    [_mainView.coverDropBtn addTarget:self action:@selector(drop:) forControlEvents:UIControlEventTouchUpInside];
    //  解锁
    [_mainView.coverUnlockBtn addTarget:self action:@selector(unlock:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)backAction:(QJLBaseButton *)button {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)createAddressLabel {
    _addressLabel = [QJLBaseLabel LabelWithFrame:CGRectMake(0, 0, 200 * WID, 30 * HEI) text:@" " titleColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter font:[UIFont systemFontOfSize:17]];
    self.navigationItem.titleView = _addressLabel;
}

#pragma mark    -   拍照
- (void)getPhoto {
//    //  设置要截屏的图片的大小
//    UIGraphicsBeginImageContext(self.view.frame.size);
//    //  对哪个视图截图固定大小的图片
//    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
//    //  获取截图的图片对象
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    //  结束绘制图片
//    UIGraphicsEndImageContext();
//    //  保存到相册
//    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    
    CGSize size = _mainView.videoview.bounds.size;
    
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    CGRect rec = CGRectMake(50 * WID, 100 * HEI, WIDTH - 100 * WID, 200 * HEI);
    
    [self.view drawViewHierarchyInRect:rec afterScreenUpdates:YES];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //  保存到相册
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    
//    NSData * data = UIImagePNGRepresentation(image);
//    
//    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSLog(@"%@", path);
//    NSString *filename = [[path objectAtIndex:0] stringByAppendingPathComponent:@"foo.png"];
//    [data writeToFile:filename atomically:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark    - viewWillAppear
- (void)viewWillAppear:(BOOL)animated {
//    [self.navigationController setNavigationBarHidden:YES animated:animated];
    self.tabBarController.tabBar.hidden = YES;
    [super viewWillAppear:animated];
    
    //  3DTouch
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"isFrom3DTouchVideo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self createAddressLabel];
    
    ObseverCalling *observer = [ObseverCalling shareObseverCalling];
    
    observer.addVideoView = ^() {
        [[SipCoreManager sharedManager] setVideoView:_mainView.videoview videoPreview:nil];   //  设置视频view~~~~
    };
    
    observer.whenCallIdle = ^() {
        [self setEnableWith:YES];
        
        _addressLabel.text = @" ";
        
        [self setStatusView];
        _mainView.coverVideoView.image = [UIImage imageNamed:@"no_call_in.jpg"];
    };
    
    observer.whenInComingReceived = ^() {
        [self setEnableWith:YES];
    };
    
    observer.whenCallConnected = ^() {
        [_mainView.coverVideoView removeFromSuperview];
    };
    
    observer.whenCallEnd = ^() {
        NSLog(@"end");
        [_mainView.coverVideoView removeFromSuperview];
        [self setStatusView];
        [self setEnableWith:NO];
        _addressLabel.text = @" ";
        _mainView.coverVideoView.image = [UIImage imageNamed:@"end_call_in.jpg"];
        
        //  延时3s改变状态图片
        double delayInSeconds = 3.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds *NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^{
            _mainView.coverVideoView.image = [UIImage imageNamed:@"no_call_in.jpg"];
        });

    };
    
    observer.displayInComingCall = ^() {
        [self setStatusView]; //  ~~~~~~~~
        _mainView.coverVideoView.image = [UIImage imageNamed:@"is_calling_in.jpg"];
    };
    
    observer.beingForground = ^() {
        //  显示地址  //  ~~~~~~~~
        _addressLabel.text = [SipCoreManager getRemoteAddressViaCall:[ObseverCalling shareObseverCalling].currentCall];
        NSLog(@"%@", _addressLabel.text);
    };
    
    //
    [observer updateOnShow];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self drop:nil];
    [super viewWillDisappear:animated];
    
    // Remove observers
    [[ObseverCalling shareObseverCalling] removeObserver];
    
    _addressLabel.text = @" ";
}

#pragma mark    - 接听
- (void)answer:(id)sender {
//    [[SipCoreManager sharedManager] acceptCall:_currentCall];
    [[SipCoreManager sharedManager] acceptCall:[ObseverCalling shareObseverCalling].currentCall];
    [_mainView.answerBtn setEnabled:NO];
}

#pragma mark    - 挂断
- (void)drop:(id)sender {
    [[SipCoreManager sharedManager] hangupCall:[ObseverCalling shareObseverCalling].currentCall];
    _isCallOut = NO;
}

#pragma mark    - 开锁
- (void)unlock:(id)sender {
    [self performSelectorOnMainThread:@selector(answer:) withObject:nil waitUntilDone:YES]; //  先接听
    
    [[SipCoreManager sharedManager] sendDtmf:'#'];
    
    //  开锁后结束通话, 要有一个延时才能执行该方法
    double delayTime = 1.0;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self drop:nil];
    });
}

//  开锁之后直接挂断
- (void)hangupAction {
    [[SipCoreManager sharedManager] hangupCall:[ObseverCalling shareObseverCalling].currentCall];
    [_hangupButton setTitle:@"接听" forState:UIControlStateNormal];
}

- (void)setStatusView {
    //  设置图片前先设置frame, 否则图片失真, 怪哉
    [_mainView.coverVideoView removeFromSuperview];
    [_mainView.videoview addSubview:_mainView.coverVideoView];
    [_mainView.coverVideoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(_mainView.videoview);
        make.left.and.top.equalTo(_mainView.videoview);
    }];
}

//  设置是否允许点击
- (void)setEnableWith:(BOOL)enable {
    _mainView.coverPhotoBtn.enabled = enable;
    _mainView.coverSpeakerBtn.enabled = enable;
    _mainView.coverHFBtn.enabled = enable;
    _mainView.coverAnswerBtn.enabled = enable;
    _mainView.coverDropBtn.enabled = enable;
    _mainView.coverUnlockBtn.enabled = enable;
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
