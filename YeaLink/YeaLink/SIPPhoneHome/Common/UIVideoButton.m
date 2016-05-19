//
//  UIVideoButton.m
//  SDKDemo
//
//  Created by  Tim Lei on 10/24/15.
//  Copyright © 2015 FreeView. All rights reserved.
//

#import "UIVideoButton.h"
#import "FVSIPCallAppData.h"
#include "linphone/linphonecore.h"

@implementation UIVideoButton {
    BOOL last_update_state;
}

- (void)initUIVideoButton {
    last_update_state = FALSE;
}

- (id)init {
    self = [super init];
    if (self) {
        [self initUIVideoButton];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (self) {
        [self initUIVideoButton];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUIVideoButton];
    }
    return self;
}

- (void)onOn {
    LinphoneCore *lc = [SipCoreManager getLc];
    
    if (!linphone_core_video_enabled(lc))
        return;
    
    [self setEnabled:FALSE];
    [_waitView startAnimating];
    
    LinphoneCall *call = linphone_core_get_current_call([SipCoreManager getLc]);
    if (call) {
        FVSIPCallAppData *callAppData = (__bridge FVSIPCallAppData *)linphone_call_get_user_pointer(call);
        callAppData->videoRequested =
        TRUE; /* will be used later to notify user if video was not activated because of the linphone core*/
        LinphoneCallParams *call_params = linphone_call_params_copy(linphone_call_get_current_params(call));
        linphone_call_params_enable_video(call_params, TRUE);
        linphone_core_update_call(lc, call, call_params);
        linphone_call_params_destroy(call_params);
    } else {
        NSLog(@"Cannot toggle video button, because no current call");
    }
}

- (void)onOff {
    LinphoneCore *lc = [SipCoreManager getLc];
    
    if (!linphone_core_video_enabled(lc))
        return;
    
    [self setEnabled:FALSE];
    [_waitView startAnimating];
    
    LinphoneCall *call = linphone_core_get_current_call([SipCoreManager getLc]);
    if (call) {
        LinphoneCallParams *call_params = linphone_call_params_copy(linphone_call_get_current_params(call));
        linphone_call_params_enable_video(call_params, FALSE);
        linphone_core_update_call(lc, call, call_params);
        linphone_call_params_destroy(call_params);
    } else {
        NSLog(@"Cannot toggle video button, because no current call");
    }
}

- (bool)onUpdate {
    bool video_enabled = false;
    LinphoneCore *lc = [SipCoreManager getLc];
    LinphoneCall *currentCall = linphone_core_get_current_call(lc);
    if (linphone_core_video_supported(lc)) {
        if (linphone_core_video_enabled(lc) && currentCall && !linphone_call_media_in_progress(currentCall) &&
            linphone_call_get_state(currentCall) == LinphoneCallStreamsRunning) {
            video_enabled = TRUE;
        }
    }
    
    [self setEnabled:video_enabled];
    if (last_update_state != video_enabled)
        [_waitView stopAnimating];
    if (video_enabled) {
        video_enabled = linphone_call_params_video_enabled(linphone_call_get_current_params(currentCall));
    }
    last_update_state = video_enabled;
    
    return video_enabled;
}

@end
