//
//  UIDigitButton.m
//  SDKDemo
//
//  Created by  Tim Lei on 10/21/15.
//  Copyright © 2015 FreeView. All rights reserved.
//

#import "UIDigitButton.h"
#import "SipCoreManager.h"

@implementation UIDigitButton

- (void)initUIDigitButton {
    _dtmf = FALSE;
    [self addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self
             action:@selector(touchUp:)
   forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
}

- (id)init {
    self = [super init];
    if (self) {
        [self initUIDigitButton];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUIDigitButton];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (self) {
        [self initUIDigitButton];
    }
    return self;
}

#pragma mark - Actions Functions

- (void)touchDown:(id)sender {
    if (_addressField && (!_dtmf || !linphone_core_in_call([SipCoreManager getLc]))) {
        NSString *newAddress = [NSString stringWithFormat:@"%@%c", _addressField.text, _digit];
        [_addressField setText:newAddress];
        linphone_core_play_dtmf([SipCoreManager getLc], _digit, -1);
    } else {
        linphone_core_send_dtmf([SipCoreManager getLc], _digit);
        linphone_core_play_dtmf([SipCoreManager getLc], _digit, 100);
    }
}

- (void)touchUp:(id)sender {
    linphone_core_stop_dtmf([SipCoreManager getLc]);
}

@end
