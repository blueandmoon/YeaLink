//
//  ShareTools.h
//  YeaLink
//
//  Created by 李根 on 16/6/17.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareTools : NSObject

@property(nonatomic, strong)ShareTools *shar;

+ (instancetype)shareMyLove;

//  注册分享
+ (void)registerShare;

/**
 *  分享参数
 *
 *  @param text   分享文本
 *  @param image  图片
 *  @param urlStr 链接
 *  @param title  标题
 *  @param type   类型    qq为qq分享 24, wx为微信分享 22, sms为短信分享 19
 */
+ (void)shareWithText:(NSString *)text images:(id)image urlStr:(NSString *)urlStr title:(NSString *)title type:(NSInteger *)type;

- (void)sendSMSWithText:(NSString *)text withViewController:(UIViewController *)currentVC;

//  分享完整版
+ (void)goToShareWithText:(NSString *)title url:(NSURL *)url;



@end
