//
//  GifView.h
//  YeaLink
//
//  Created by 李根 on 16/6/1.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "QJLBaseView.h"
#import <ImageIO/ImageIO.h>

@interface GifView : QJLBaseView {
    CGImageSourceRef gif;   //  保存gif动画
    NSDictionary *gifProperties;    //  保存gif动画属性
    size_t index;   //  gif动画播放开始的帧序号
    size_t count;   //  gif 动画的总帧数
    NSTimer *timer; //  播放gif动画所使用的timer;
}

//  处理gif数据
- (void)loadData:(NSData *)_data;  

//  将动图加到父视图上
+ (void)showGifViewWithSuperview:(UIView *)view;

@end
