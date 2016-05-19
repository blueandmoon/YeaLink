//
//  UIMicroButton.m
//  SDKDemo
//
//  Created by  Tim Lei on 10/24/15.
//  Copyright © 2015 FreeView. All rights reserved.
//

#import "UIMicroButton.h"

@implementation UIMicroButton

- (void)onOn {
    [[SipCoreManager sharedManager] muteMic:YES];
}

- (void)onOff {
    [[SipCoreManager sharedManager] muteMic:NO];
}

- (bool)onUpdate {
    return [[SipCoreManager sharedManager] isMicMuted];
}


@end
