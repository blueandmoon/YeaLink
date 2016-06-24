//
//  ObseverCalling.h
//  YeaLink
//
//  Created by 李根 on 16/6/22.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^BLOCK)();
@interface ObseverCalling : NSObject
@property(nonatomic, assign)LinphoneCall *currentCall;

@property(nonatomic, strong)BLOCK addVideoView; //  加视频view
@property(nonatomic, strong)BLOCK whenCallIdle;
@property(nonatomic, strong)BLOCK whenInComingReceived;
@property(nonatomic, strong)BLOCK whenCallConnected;
@property(nonatomic, strong)BLOCK whenCallEnd;
@property(nonatomic, strong)BLOCK displayInComingCall;
@property(nonatomic, strong)BLOCK beingForground;

+ (instancetype)shareObseverCalling;

- (void)updateOnShow;

- (void)removeObserver;

- (void)displayIncomingCall:(LinphoneCall *)call;

@end
