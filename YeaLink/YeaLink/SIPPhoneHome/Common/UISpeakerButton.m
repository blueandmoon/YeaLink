//
//  UISpeakerButton.m
//  SDKDemo
//
//  Created by  Tim Lei on 10/24/15.
//  Copyright © 2015 FreeView. All rights reserved.
//
#import <AudioToolbox/AudioToolbox.h>
#import "UISpeakerButton.h"

#include "linphone/linphonecore.h"

@implementation UISpeakerButton
#pragma clang diagnostic ignored "-Wdeprecated"

#pragma mark - Static Functions

static void audioRouteChangeListenerCallback(void *inUserData,					  // 1
                                             AudioSessionPropertyID inPropertyID, // 2
                                             UInt32 inPropertyValueSize,		  // 3
                                             const void *inPropertyValue		  // 4
) {
    if (inPropertyID != kAudioSessionProperty_AudioRouteChange)
        return; // 5
    UISpeakerButton *button = (__bridge UISpeakerButton *)inUserData;
    [button update];
}

- (void)initUISpeakerButton {
    AudioSessionInitialize(NULL, NULL, NULL, NULL);
    OSStatus lStatus = AudioSessionAddPropertyListener(kAudioSessionProperty_AudioRouteChange,
                                                       audioRouteChangeListenerCallback, (__bridge void *)(self));
    if (lStatus) {
        NSLog(@"cannot register route change handler [%d]", (int)lStatus);
    }
}

- (id)init {
    self = [super init];
    if (self) {
        [self initUISpeakerButton];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUISpeakerButton];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (self) {
        [self initUISpeakerButton];
    }
    return self;
}

- (void)dealloc {
    OSStatus lStatus = AudioSessionRemovePropertyListenerWithUserData(
                                                                      kAudioSessionProperty_AudioRouteChange, audioRouteChangeListenerCallback, (__bridge void *)(self));
    if (lStatus) {
        NSLog(@"cannot un register route change handler [%d]", (int)lStatus);
    }
}

#pragma mark - UIToggleButtonDelegate Functions

- (void)onOn {
    [[SipCoreManager sharedManager] setSpeakerEnabled:TRUE];
}

- (void)onOff {
    [[SipCoreManager sharedManager] setSpeakerEnabled:FALSE];
}

- (bool)onUpdate {
    [self setEnabled:[[SipCoreManager sharedManager] allowSpeaker]];
    return [[SipCoreManager sharedManager] speakerEnabled];
}

@end
