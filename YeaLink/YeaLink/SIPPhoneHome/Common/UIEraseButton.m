//
//  UIEraseButton.m
//  SDKDemo
//
//  Created by  Tim Lei on 10/24/15.
//  Copyright © 2015 FreeView. All rights reserved.
//

#import "UIEraseButton.h"

@implementation UIEraseButton
- (void)initUIEraseButton {
    [self addTarget:self action:@selector(touchDown:) forControlEvents:UIControlEventTouchDown];
}

- (id)init {
    self = [super init];
    if (self) {
        [self initUIEraseButton];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUIEraseButton];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (self) {
        [self initUIEraseButton];
    }
    return self;
}

- (void)dealloc {
    _addressField = nil;
}

#pragma mark - Action Functions

- (void)touchDown:(id)sender {
    if ([_addressField.text length] > 0) {
        [_addressField setText:[_addressField.text substringToIndex:[_addressField.text length] - 1]];
    }
}

#pragma mark - UILongTouchButtonDelegate Functions

- (void)onRepeatTouch {
}

- (void)onLongTouch {
    [_addressField setText:@""];
}

@end
