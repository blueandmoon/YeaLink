//
//  GifView.m
//  YeaLink
//
//  Created by 李根 on 16/6/1.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "GifView.h"

@implementation GifView
{
    GifView *_showGifView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)loadData:(NSData *)_data {
    
    //  kCGImagePropertyGIFLoopCount loopCount (播放次数): 有些gif播放到一定次数就停止了, 如果为0就代表一直循环播放
    gifProperties = [NSDictionary dictionaryWithObject:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:0] forKey:(NSString *)kCGImagePropertyGIFLoopCount] forKey:(NSString *)kCGImagePropertyGIFDictionary];
    
    gif = CGImageSourceCreateWithData((CFDataRef)_data, (CFDictionaryRef) gifProperties);
    count = CGImageSourceGetCount(gif);
    
    //  解决重复调用timer的问题
    if (timer) {
        [timer invalidate];
        timer = nil;
    }
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(play) userInfo:nil repeats:YES];
    [timer fire];
    
    
}

- (void)play {
    index ++;
    index = index % count;
    
    //  获取图像
    CGImageRef ref = CGImageSourceCreateImageAtIndex(gif, index, (CFDictionaryRef)gifProperties);
    
    self.layer.contents = (__bridge id)ref;
    CFRelease(ref);
}

- (void)removeFromSuperview {
    NSLog(@"removeFromSuperview");
    [timer invalidate];
    timer = nil;
    [super removeFromSuperview];
}

- (void)dealloc {
    NSLog(@"dealloc");
    CFRelease(gif);
    //    [super dealloc];
}

- (void)showGifViewWithSuperview:(UIView *)view {
        NSString *dataPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"YeaLink"] ofType:@"gif"];
        NSData *data = [[NSData alloc] initWithContentsOfFile:dataPath];
    
    [_showGifView removeFromSuperview];
        //  展示gif动图
        _showGifView = [[GifView alloc] init];
        [view addSubview:_showGifView];
        _showGifView.contentMode = UIViewContentModeScaleAspectFit;
        [_showGifView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(view);
            make.size.mas_equalTo(CGSizeMake(100 * WID, 100 * HEI));
        }];
        [_showGifView loadData:data];
    
    
}

- (void)showGifView {
    
    NSString *dataPath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"YeaLink"] ofType:@"gif"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:dataPath];
    [self loadData:data];
}

@end
