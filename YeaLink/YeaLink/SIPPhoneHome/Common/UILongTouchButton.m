//
//  UILongTouchButton.m
//  SDKDemo
//
//  Created by  Tim Lei on 10/21/15.
//  Copyright © 2015 FreeView. All rights reserved.
//

#import "UILongTouchButton.h"

@implementation UILongTouchButton 

#pragma mark - Lifecycle Functions

- (void)initUILongTouchButton {
    [self addTarget:self action:@selector(___touchDown:) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self
             action:@selector(___touchUp:)
   forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
}

- (id)init {
    if (self = [super init]) {
        [self initUILongTouchButton];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self initUILongTouchButton];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super initWithCoder:decoder]) {
        [self initUILongTouchButton];
    }
    
    return self;
}

- (void)dealloc {
    [self removeTarget:self action:@selector(___touchDown:) forControlEvents:UIControlEventTouchDown];
    [self removeTarget:self
                action:@selector(___touchUp:)
      forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
}

#pragma mark - Touch Event

- (void)___touchDown:(id)sender {
    [self performSelector:@selector(doLongTouch) withObject:nil afterDelay:0.5];
}

- (void)___touchUp:(id)sender {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(doLongTouch) object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(doRepeatTouch) object:nil];
}

- (void)doLongTouch {
    [self onLongTouch];
    [self onRepeatTouch];
    [self performSelector:@selector(doRepeatTouch) withObject:nil afterDelay:0.1];
}

- (void)doRepeatTouch {
    [self onRepeatTouch];
    [self performSelector:@selector(doRepeatTouch) withObject:nil afterDelay:0.1];
}

#pragma mark - UILongTouchButtonDelegate

- (void)onRepeatTouch {
}

- (void)onLongTouch {
}

@end
