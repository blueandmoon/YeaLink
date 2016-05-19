//
//  SIPPhoneHomeViewController.m
//  YeaLink
//
//  Created by 李根 on 16/4/27.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "SIPPhoneHomeViewController.h"
#import "FVSIPSdk.h"
#import "UIAddressTextField.h"
#import "UIDigitButton.h"
#import "UIVideoButton.h"
//#import "SettingsViewController.h"
#import "WebKeyManager.h"


@interface SIPPhoneHomeViewController ()

@end

@implementation SIPPhoneHomeViewController
{
    BOOL _isCallOut;
    LinphoneCall *_currentCall;
    QJLBaseImageView *_bgImage; //  背景图片
    QJLBaseImageView *_sceneryImage;    //  视频对讲窗口的占位图
}

- (instancetype)init {
    if (self = [super init]) {
        _currentCall = nil;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self questData];
    [self getView];
    
    //    if (![[SipCoreManager sharedManager] addAccountWithUserName:@"08" password:@"1234" domain:@"192.168.10.104" transport:kFVSIPTransportTcp]) {
    //        NSLog(@"Add account failed");
    //    }
}

- (void)questData {
    
}
#pragma mark    - 建立各个view
- (void)getView {
//    //  背景图片
//    _bgImage = [[QJLBaseImageView alloc] initWithImage:[UIImage imageNamed:@"bgImage"]];
//    [self.view addSubview:_bgImage];
//    _bgImage.frame = CGRectMake(0, 0, WIDTH, HEIGHT);
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    
    //  播放视频的view
    _videoView = [[QJLBaseView alloc] initWithFrame:CGRectMake(0, 100 * HEI, WIDTH, 200 * HEI)];
//    _videoView.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:_videoView];
//    _videoView.alpha = 0.5;
    
    [self createAddressLabel];
//    [self createSettingButton];
    [self createFunctionButton];
    
    //  返回按钮
    QJLBaseButton *button = [QJLBaseButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:button];
    [button setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    button.frame = CGRectMake(10, 30, 20, 20);
    [button addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)backAction:(QJLBaseButton *)button {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)createAddressLabel {
    self.addressTextfield = [[QJLBaseTextfield alloc] initWithFrame:CGRectMake(50 * WID, 25 * HEI, 200 * WID, 50 * HEI)];
    [self.view addSubview:self.addressTextfield];
    self.addressTextfield.layer.borderWidth = 0;
    _addressTextfield.text = @"某某单元";
    _addressTextfield.enabled = NO;
}

- (void)createFunctionButton {
    self.photoButton = [[QJLBaseButton alloc] initWithFrame:CGRectMake(50 * WID, 325 * HEI, 50 * WID, 50 * HEI)];
    [self.view addSubview:self.photoButton];
//    self.photoButton.layer.borderWidth = 1;
//    [_photoButton setTitle:@"拍照" forState:UIControlStateNormal];
//    _photoButton.backgroundColor = [UIColor grayColor];
    [_photoButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"cameraIcon"]] forState:UIControlStateNormal];
    [_photoButton addTarget:self action:@selector(getPhoto) forControlEvents:UIControlEventTouchUpInside];
    
#pragma mark    - 免提对讲
    _handsfreeButton = [UISpeakerButton buttonWithType:UIButtonTypeCustom];
    _handsfreeButton.frame = CGRectMake(150 * WID, 325 * HEI, 50 * WID, 50 * HEI);
    [self.view addSubview:_handsfreeButton];
//    self.handsfreeButton.layer.borderWidth = 1;
    [_handsfreeButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"ic_incall_speaker_off"]] forState:UIControlStateNormal];
    [_handsfreeButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"ic_incall_speaker_on"]] forState:UIControlStateSelected];
    
    _intercomButton = [UIMicroButton buttonWithType:UIButtonTypeCustom];
    _intercomButton.frame = CGRectMake(250 * WID, 325 * HEI, 50 * WID, 50 * HEI);
    [self.view addSubview:self.intercomButton];
//    self.intercomButton.layer.borderWidth = 1;
    [_intercomButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"ic_incall_micro_on"]] forState:UIControlStateNormal];
    [_intercomButton setImage:[UIImage imageNamed:[NSString stringWithFormat:@"ic_incall_micro_off"]] forState:UIControlStateSelected];
    
    //  开锁
    _unlockButton = [QJLBaseButton buttonWithType:UIButtonTypeCustom];
    _unlockButton.frame = CGRectMake(50 * WID, 385 * HEI, WIDTH - 100 * WID, 50 * HEI);
    [self.view addSubview:self.unlockButton];
//    self.unlockButton.layer.borderWidth = 1;
    [_unlockButton setTitle:@"开锁" forState:UIControlStateNormal];
    _unlockButton.backgroundColor = [UIColor colorWithRed:52 / 255.0 green:152 / 255.0 blue:219 / 255.0 alpha:1];
    [_unlockButton addTarget:self action:@selector(unlockBUttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    //  挂断
    _hangupButton = [QJLBaseButton buttonWithType:UIButtonTypeCustom];
    _hangupButton.frame = CGRectMake(50 * WID, 445 * HEI, WIDTH - 100 * WID, 50 * HEI);
    [self.view addSubview:self.hangupButton];
//    self.hangupButton.layer.borderWidth = 1;
    _hangupButton.backgroundColor = [UIColor colorWithRed:52 / 255.0 green:152 / 255.0 blue:219 / 255.0 alpha:1];
    [_hangupButton setTitle:@"接听" forState:UIControlStateNormal];
    [_hangupButton addTarget:self action:@selector(answerAction:) forControlEvents:UIControlEventTouchUpInside];
//    _isSelected = 0;
    
    
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
    
    CGSize size = _videoView.bounds.size;
    
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
    
    [_hangupButton setTitle:@"接听" forState:UIControlStateNormal];
    // Update on show
    LinphoneCall *call = linphone_core_get_current_call([SipCoreManager getLc]);
    LinphoneCallState state = (call != NULL) ? linphone_call_get_state(call) : 0;
    [self callUpdate:call state:state];
    
#pragma mark    - 这里放置视频view
    // Set windows (warn memory leaks)
    [[SipCoreManager sharedManager] setVideoView:_videoView videoPreview:nil];
    
    // Set observer
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(registrationUpdate:)
                                                 name:kFVSIPRegistrationUpdate
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(callUpdateEvent:)
                                                 name:kFVSIPCallUpdate
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(coreUpdateEvent:)
                                                 name:kFVSIPCoreUpdate
                                               object:nil];
    LinphoneProxyConfig *cfg = NULL;
    linphone_core_get_default_proxy([SipCoreManager getLc], &cfg);
    [self updateRegisterStatus:cfg];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
    
    // Remove observers
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kFVSIPCallUpdate object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kFVSIPCoreUpdate object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kFVSIPRegistrationUpdate object:nil];
}

#pragma mark - UI Helpers

- (void) initViewComponents {
    [[self navigationItem] setTitle:@"Home"];
    
    //Set background color for keypad
    UIColor *backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"dial_background_texture"]];
    [self.view setBackgroundColor:backgroundColor];
    
    //Don't display keypad of system for textfield
//    _addressField.inputView = [[UIView alloc]initWithFrame:CGRectZero];
    
//    [_zeroButton setDigit:'0'];
//    [_oneButton setDigit:'1'];
//    [_twoButton setDigit:'2'];
//    [_threeButton setDigit:'3'];
//    [_fourButton setDigit:'4'];
//    [_fiveButton setDigit:'5'];
//    [_sixButton setDigit:'6'];
//    [_sevenButton setDigit:'7'];
//    [_eightButton setDigit:'8'];
//    [_nineButton setDigit:'9'];
//    [_starButton setDigit:'*'];
//    [_sharpButton setDigit:'#'];
    
//#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_6_0 // attributed string only available since iOS6
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
//        // fix placeholder bar color in iOS7
//        UIColor *color = [UIColor grayColor];
//        NSAttributedString *placeHolderString =
//        [[NSAttributedString alloc] initWithString:NSLocalizedString(@"enter.address", @"Enter an address")
//                                        attributes:@{NSForegroundColorAttributeName : color}];
//        _addressField.attributedPlaceholder = placeHolderString;
//    }
//#endif
//}

    //  呼叫按钮, 无关
//- (IBAction)callButtonPressed:(id)sender {
//    NSString *address = [_addressField text];
//    NSString *displayName = nil;
//    
//    if ([address length] == 0) {
//        const MSList *logs = linphone_core_get_call_logs([SipCoreManager getLc]);
//        while (logs) {
//            LinphoneCallLog *log = logs->data;
//            if (linphone_call_log_get_dir(log) == LinphoneCallOutgoing) {
//                LinphoneProxyConfig *def_proxy = NULL;
//                LinphoneAddress *to = linphone_call_log_get_to(log);
//                const char *domain = linphone_address_get_domain(to);
//                char *bis_address = NULL;
//                
//                linphone_core_get_default_proxy([SipCoreManager getLc], &def_proxy);
//                
//                // if the 'to' address is on the default proxy, only present the username
//                if (def_proxy) {
//                    const char *def_domain = linphone_proxy_config_get_domain(def_proxy);
//                    if (def_domain && domain && !strcmp(domain, def_domain)) {
//                        bis_address = ms_strdup(linphone_address_get_username(to));
//                    }
//                }
//                
//                if (bis_address == NULL) {
//                    bis_address = linphone_address_as_string_uri_only(to);
//                }
//                
//                [_addressField setText:[NSString stringWithUTF8String:bis_address]];
//                ms_free(bis_address);
//                // return after filling the address, let the user confirm the call by pressing again
//                return;
//            }
//            logs = ms_list_next(logs);
//        }
//    }
//    
//    if ([address length] > 0) {
//        _isCallOut = YES;
//        [[SipCoreManager sharedManager] call:address displayName:displayName transfer:FALSE];
//    }
//}
//#pragma mark    - 挂断按钮
//- (IBAction)hangupButtonPressed:(id)sender {
//    [[SipCoreManager sharedManager] hangupCall:_currentCall];
//    _isCallOut = NO;
}
#pragma mark    - 接听按钮
//- (IBAction)acceptButtonPressed:(id)sender {
//    [[SipCoreManager sharedManager] acceptCall:_currentCall];
//    
//    [_acceptCallButton setEnabled:NO];
//    [_callStatusLabel setText:NSLocalizedString(@"status.in.call", nil)];
//}

- (void)answerAction:(UIButton *)button {
    _isSelected = !_isSelected;
    if (_isSelected == 1) {
        NSLog(@"接听中");
        [_hangupButton setTitle:@"挂断" forState:UIControlStateNormal];
//        [_hangupButton setEnabled:NO];
        

        [[SipCoreManager sharedManager] acceptCall:_currentCall];
        //  这行代码有什么不妥吗?, 不注掉就会崩
//        NSLog(@"~~~~~~%@", _currentCall);
    } else {
        NSLog(@"挂断了");
        [_hangupButton setTitle:@"接听" forState:UIControlStateNormal];
        [[SipCoreManager sharedManager] hangupCall:_currentCall];
    }
    
//    if ([button.currentTitle isEqualToString:@"接听"]) {
//        [_hangupButton setTitle:@"挂断" forState:UIControlStateNormal];
//        [_hangupButton setEnabled:NO];
//        
//        [[SipCoreManager sharedManager] acceptCall:_currentCall];
//    } else {
//        [_hangupButton setTitle:@"接听" forState:UIControlStateNormal];
//        [[SipCoreManager sharedManager] hangupCall:_currentCall];
//    }
    
}
#pragma mark    - 开锁按钮
//- (IBAction)unlockButtonPressed:(id)sender {
//    [[SipCoreManager sharedManager] sendDtmf:'#'];
//    //    [[WebKeyManager sharedManager] unlockDoor:0  completionBlock:^(NSError* error) {
//    //        NSLog(@"%@", error);
//    //    }];
//}

- (void)unlockBUttonPressed:(UIButton *)button {
    [[SipCoreManager sharedManager] sendDtmf:'#'];
//    _unlockButton.backgroundColor = [UIColor blackColor];
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(hangupAction) userInfo:nil repeats:NO];
//    [[WebKeyManager sharedManager] unlockDoor:0  completionBlock:^(NSError* error) {
//            NSLog(@"%@", error);
//        }];
    }
//  开锁之后直接挂断
- (void)hangupAction {
    [[SipCoreManager sharedManager] hangupCall:_currentCall];
    [_hangupButton setTitle:@"接听" forState:UIControlStateNormal];
}

#pragma mark    - 设置按钮
//- (IBAction)settingsButtonPressed:(id)sender {
//    SettingsViewController *settingsController = [[SettingsViewController alloc] initWithStyle:UITableViewStyleGrouped];
//    [self.navigationController pushViewController:settingsController animated:YES];
//}

#pragma mark - Event Functions

- (void)registrationUpdate:(NSNotification *)notif {
    LinphoneRegistrationState state = [[notif.userInfo objectForKey:kFVSIPState] intValue];
    LinphoneProxyConfig *cfg = [[notif.userInfo objectForKey:kFVSIPConfig] pointerValue];
    // Only report bad credential issue
    if (state == LinphoneRegistrationFailed &&
        [UIApplication sharedApplication].applicationState == UIApplicationStateBackground &&
        linphone_proxy_config_get_error(cfg) == LinphoneReasonBadCredentials) {
        //TODO:Notify registration error. Bad credentials
    }
    
    [self updateRegisterStatus:cfg];
}

- (void)onGlobalStateChanged:(NSNotification *)notif {
    LinphoneGlobalState state = (LinphoneGlobalState)[[[notif userInfo] valueForKey:kFVSIPState] integerValue];
    static BOOL already_shown = NO;
    if (state == LinphoneGlobalOn && !already_shown) {
        LinphoneProxyConfig *conf = NULL;
        linphone_core_get_default_proxy([SipCoreManager getLc], &conf);
        if (conf == NULL) {
            already_shown = YES;
            //TODO:update phone status
        }
    }
}

#pragma mark    - 呼叫状态更新事件
- (void)callUpdateEvent:(NSNotification *)notif {
    LinphoneCall *call = [[notif.userInfo objectForKey:kFVSIPCall] pointerValue];
    LinphoneCallState state = [[notif.userInfo objectForKey:kFVSIPState] intValue];
    [self callUpdate:call state:state];
}

- (void)coreUpdateEvent:(NSNotification *)notif {
}
#pragma mark    呼叫更新状态方法
- (void)callUpdate:(LinphoneCall *)call state:(LinphoneCallState)state {
    LinphoneCore *lc = [SipCoreManager getLc];
    NSLog(@"call state:%d", state);
    switch (state) {
        case LinphoneCallIncomingReceived:
        case LinphoneCallOutgoingInit:
        case LinphoneCallOutgoingProgress:{
            if (linphone_core_get_calls_nb(lc) > 0 && _currentCall == nil) {
                [self displayIncomingCall:call];
            }
            break;
        }
        case LinphoneCallOutgoingEarlyMedia:
            NSLog(@"LinphoneCallOutgoingEarlyMedia");
            break;
        case LinphoneCallIncomingEarlyMedia:
            if ([UIApplication sharedApplication].applicationState != UIApplicationStateBackground) {
                [[SipCoreManager sharedManager] acceptEarlyMedia:_currentCall];
            }
            break;
        case LinphoneCallOutgoingRinging:
//            [_callStatusLabel setText:NSLocalizedString(@"status.ringing", nil)];
            break;
        case LinphoneCallConnected:
        case LinphoneCallStreamsRunning: {
//            [_callStatusLabel setText:NSLocalizedString(@"status.in.call", nil)];
            // check video
            if (linphone_call_params_video_enabled(linphone_call_get_current_params(call))) {
                [self displayVideoCall];
            } else {
                const LinphoneCallParams *param = linphone_call_get_current_params(call);
                const FVSIPCallAppData *callAppData =
                (__bridge const FVSIPCallAppData *)(linphone_call_get_user_pointer(call));
                if (state == LinphoneCallStreamsRunning && callAppData->videoRequested &&
                    linphone_call_params_low_bandwidth_enabled(param)) {
                    // too bad video was not enabled because low bandwidth
                    callAppData->videoRequested = FALSE; /*reset field*/
                }
//                [_avatarImageView setHidden:NO];
//                [_videoRecordButton update];
            }
            break;
        }
        case LinphoneCallUpdatedByRemote: {
            const LinphoneCallParams *current = linphone_call_get_current_params(call);
            const LinphoneCallParams *remote = linphone_call_get_remote_params(call);
            
            /* remote wants to add video */
            if (linphone_core_video_enabled(lc) && !linphone_call_params_video_enabled(current) &&
                linphone_call_params_video_enabled(remote) && !linphone_core_get_video_policy(lc)->automatically_accept) {
                linphone_core_defer_call_update(lc, call);
                //[self displayAskToEnableVideoCall:call];
                LinphoneCallParams *paramsCopy =
                linphone_call_params_copy(linphone_call_get_current_params(call));
                linphone_call_params_enable_video(paramsCopy, TRUE);
                linphone_core_accept_call_update([SipCoreManager getLc], call, paramsCopy);
                linphone_call_params_destroy(paramsCopy);
//                [_avatarImageView setHidden:YES];
            } else if (linphone_call_params_video_enabled(current) && !linphone_call_params_video_enabled(remote)) {
                
            }
            break;
        }
        case LinphoneCallPausing:
        case LinphoneCallPaused:
        case LinphoneCallPausedByRemote: {
            //Call paused?
            break;
        }
        case LinphoneCallEnd:
        case LinphoneCallError: {
//            [_inCallView setHidden:YES];
            _isCallOut = NO;
            _currentCall = nil;
            break;
        }
        default:
            break;
    }
}

- (void)displayIncomingCall:(LinphoneCall *)call {
    LinphoneCallLog *callLog = linphone_call_get_call_log(call);
    if (!linphone_call_log_get_call_id(callLog)) {
        return;
    }
    
    _currentCall = call;
    
//    [_acceptCallButton setEnabled:YES];
    
    //if ([UIApplication sharedApplication].applicationState != UIApplicationStateBackground)
    {
//        [_callStatusLabel setText:_isCallOut?NSLocalizedString(@"status.ringing", nil):NSLocalizedString(@"status.call.incoming", nil)];
//        [_inCallView setHidden:NO];
        [_addressTextfield setText:[SipCoreManager getRemoteAddressViaCall:_currentCall]];
    }
    
    if ([UIApplication sharedApplication].applicationState != UIApplicationStateBackground) {
        [[SipCoreManager sharedManager] acceptEarlyMedia:_currentCall];
//        [_avatarImageView setHidden:YES];
    }
}

- (void)displayVideoCall {
    if (linphone_core_self_view_enabled([SipCoreManager getLc])) {
//        [_videoPreview setHidden:FALSE];
    } else {
//        [_videoPreview setHidden:TRUE];
    }
//    [_avatarImageView setHidden:YES];
    
    LinphoneCall *call = linphone_core_get_current_call([SipCoreManager getLc]);
    // linphone_call_params_get_used_video_codec return 0 if no video stream enabled
    if (call != NULL && linphone_call_params_get_used_video_codec(linphone_call_get_current_params(call))) {
        linphone_call_set_next_video_frame_decoded_callback(call, nil, (__bridge void *)(self));
    }
}

#pragma mark - UI Helpers
- (void) updateRegisterStatus:(LinphoneProxyConfig *)config {
    
    LinphoneRegistrationState state = LinphoneRegistrationNone;
    NSString *message = nil;
    
    if (config == NULL) {
        state = LinphoneRegistrationNone;
        if (linphone_core_is_network_reachable([SipCoreManager getLc]))
            message = NSLocalizedString(@"registration.status.noaccount", nil);
        else
            message = NSLocalizedString(@"registration.status.none", nil);
    } else {
        state = linphone_proxy_config_get_state(config);
        switch (state) {
            case LinphoneRegistrationOk:
                linphone_core_enable_video([SipCoreManager getLc], true, true);
//                [_statusImageView setImage:[UIImage imageNamed:@"registered"]];
                message = NSLocalizedString(@"registration.status.ok", nil);
                break;
            case LinphoneRegistrationNone:
            case LinphoneRegistrationCleared:
                message = NSLocalizedString(@"registration.status.none", nil);
//                [_statusImageView setImage:[UIImage imageNamed:@"unregistered"]];
                break;
            case LinphoneRegistrationFailed:
                message = NSLocalizedString(@"registration.status.fail", nil);
//                [_statusImageView setImage:[UIImage imageNamed:@"unregistered"]];
                break;
            case LinphoneRegistrationProgress:
                message = NSLocalizedString(@"registration.status.inprogress", nil);
//                [_statusImageView setImage:[UIImage imageNamed:@"unregistered"]];
                break;
            default:
                break;
        }
    }
    
//    [_numberLabel setText:message];
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
