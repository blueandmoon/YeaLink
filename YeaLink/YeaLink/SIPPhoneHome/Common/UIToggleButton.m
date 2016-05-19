//
//  UIToggleButton.m
//  SDKDemo
//
//  Created by  Tim Lei on 10/24/15.
//  Copyright © 2015 FreeView. All rights reserved.
//

#import "UIToggleButton.h"

@implementation UIToggleButton

- (void)initUIToggleButton {
    [self update];
    [self addTarget:self action:@selector(touchUp:) forControlEvents:UIControlEventTouchUpInside];
}

- (id)init {
    self = [super init];
    if (self) {
        [self initUIToggleButton];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initUIToggleButton];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    self = [super initWithCoder:decoder];
    if (self) {
        [self initUIToggleButton];
    }
    return self;
}

#pragma mark -

- (void)touchUp:(id)sender {
    [self toggle];
}

- (bool)toggle {
    if (self.selected) {
        self.selected = !self.selected;
        [self onOff];
    } else {
        self.selected = !self.selected;
        [self onOn];
    }
    return self.selected;
}

- (void)setOn {
    if (!self.selected) {
        [self toggle];
    }
}

- (void)setOff {
    if (self.selected) {
        [self toggle];
    }
}

- (bool)update {
    self.selected = [self onUpdate];
    return self.selected;
}

#pragma mark - UIToggleButtonDelegate Functions

- (void)onOn {
    /*[NSException raise:NSInternalInconsistencyException
     format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];*/
}

- (void)onOff {
    /*[NSException raise:NSInternalInconsistencyException
     format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];*/
}

- (bool)onUpdate {
    /*[NSException raise:NSInternalInconsistencyException
     format:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)];*/
    return false;
}

@end
