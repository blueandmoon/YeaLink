//
//  ObseverCalling.m
//  YeaLink
//
//  Created by 李根 on 16/6/22.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "ObseverCalling.h"

@implementation ObseverCalling
{
//    BOOL _isCallOut;
//    LinphoneCall *_currentCall;
}

+ (instancetype)shareObseverCalling {
    static ObseverCalling *obser;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obser = [[ObseverCalling alloc] init];
    });
    return obser;
}

- (void)updateOnShow {
    // Update on show
    LinphoneCall *call = linphone_core_get_current_call([SipCoreManager getLc]);
    LinphoneCallState state = (call != NULL) ? linphone_call_get_state(call) : 0;
    [self callUpdate:call state:state];
    
#pragma mark    - 这里放置视频view
    // Set windows (warn memory leaks)
    
    self.addVideoView();
//    [[SipCoreManager sharedManager] setVideoView:_mainView.videoview videoPreview:nil];   //  设置视频view~~~~
    
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

#pragma mark    - 呼叫更新状态
- (void)callUpdate:(LinphoneCall *)call state:(LinphoneCallState)state {
    
    LinphoneCore *lc = [SipCoreManager getLc];
    
    switch (state) {
        case LinphoneCallIdle: {
            
            self.whenCallIdle();
            
//            [self setEnableWith:YES];
            
//            _addressLabel.text = @" ";    //  ~~~~~~~
            
//            [self setStatusView]; //  ~~~~~~
//            _mainView.coverVideoView.image = [UIImage imageNamed:@"no_call_in.jpg"];  //  ~~~~~~~
            
        } break;
        case LinphoneCallIncomingReceived: {
            self.whenInComingReceived();
            
//            [self setEnableWith:YES]; //  ~~~~~~~~~~
            
//            NSLog(@"+++++++++++++++++++");
        } ;
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
                if (_currentCall != nil) {
                    [[SipCoreManager sharedManager] acceptEarlyMedia:_currentCall];
                }
            }
            break;
        case LinphoneCallOutgoingRinging:
            //            [_callStatusLabel setText:NSLocalizedString(@"status.ringing", nil)];
            break;
        case LinphoneCallConnected: {
            self.whenCallConnected();
//            [_mainView.coverVideoView removeFromSuperview];   //  ~~~~~~
            
        } break;
        case LinphoneCallStreamsRunning: {
            //            [_callStatusLabel setText:NSLocalizedString(@"status.in.call", nil)];
            // check video
            if (linphone_call_params_video_enabled(linphone_call_get_current_params(call))) {
                [self displayVideoCall];  //  ~~~~~~~
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
        case LinphoneCallEnd: {
            self.whenCallEnd();
//            [_mainView.coverVideoView removeFromSuperview];   //  ~~~~~~
//            [self setStatusView];
//            [self setEnableWith:NO];
//            _addressLabel.text = @" ";
//            _mainView.coverVideoView.image = [UIImage imageNamed:@"end_call_in.jpg"];
            
//            //  延时3s改变状态图片    //  ~~~~~~~
//            double delayInSeconds = 3.0;
//            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds *NSEC_PER_SEC);
//            dispatch_after(popTime, dispatch_get_main_queue(), ^{
//                _mainView.coverVideoView.image = [UIImage imageNamed:@"no_call_in.jpg"];
//            });
            
        };
        case LinphoneCallError: {
            //            [_inCallView setHidden:YES];
//            _isCallOut = NO;
            _currentCall = nil;
            break;
        }
        default:
            break;
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

- (void)displayIncomingCall:(LinphoneCall *)call {
    //    [self setEnableWith:YES];
    
    self.displayInComingCall();
//    [self setStatusView]; //  ~~~~~~~~
//    _mainView.coverVideoView.image = [UIImage imageNamed:@"is_calling_in.jpg"];
    
    
    LinphoneCallLog *callLog = linphone_call_get_call_log(call);
    if (!linphone_call_log_get_call_id(callLog)) {
        return;
    }
    
    _currentCall = call;
    
    if ([UIApplication sharedApplication].applicationState != UIApplicationStateBackground)
    {
        self.beingForground();
//        //  显示地址  //  ~~~~~~~~
//        _addressLabel.text = [SipCoreManager getRemoteAddressViaCall:_currentCall];
//        NSLog(@"%@", _addressLabel.text);
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

#pragma mark    - remove observer
- (void)removeObserver {
    // Remove observers
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kFVSIPCallUpdate object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kFVSIPCoreUpdate object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kFVSIPRegistrationUpdate object:nil];
    
}






@end
