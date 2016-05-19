//
//  AVPlayerView.m
//  YeaLink
//
//  Created by 李根 on 16/4/27.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "AVPlayerView.h"

@interface AVPlayerView ()
@property(nonatomic, retain)AVPlayer *player;
@property(nonatomic, strong)QJLBaseView *playerView;

@end

@implementation AVPlayerView

- (void)createView {
    _playerView = [[QJLBaseView alloc] initWithFrame:CGRectMake( 0, 0, self.frame.size
                                                                .width, self.frame.size.height)];
    [self addSubview:_playerView];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"lizhi" ofType:@"mp4"];
    NSURL *url = [NSURL fileURLWithPath:path];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:url];
    _player = [AVPlayer playerWithPlayerItem:playerItem];
    
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:_player];
    playerLayer.frame = CGRectMake(0, 0, self.playerView.frame.size.width, self.playerView.frame.size.height);
    [self.playerView.layer addSublayer:playerLayer];
    [self addSubview:_playerView];
#pragma mark    - 先不播放
//    [_player play];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
