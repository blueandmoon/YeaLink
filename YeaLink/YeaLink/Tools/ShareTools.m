//
//  ShareTools.m
//  YeaLink
//
//  Created by 李根 on 16/6/17.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "ShareTools.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDKUI.h>


//  短信
#import <MessageUI/MessageUI.h>

#pragma mark    - 迁移~~~
//#import <ShareSDKUI/SSUIEditorViewStyle.h>
//  分享
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

//  腾讯开发平台(对应qq和qq空间) SDK文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//  微信SDK头文件
#import "WXApi.h"

//  新浪微博SDK头文件
#import "WeiboSDK.h"
//  新浪微博SDK需要在项目Build Settings中的Other Linker Flags添加"-ObjC"

@interface ShareTools ()<MFMessageComposeViewControllerDelegate>

@end

@implementation ShareTools
{
    UIViewController *_currentVC;
}
+ (instancetype)shareMyLove {
    static ShareTools *share;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [[ShareTools alloc] init];
    });
    
    return share;
}

- (instancetype)init {
    if (self = [super init]) {
//        self begin
    }
    return self;
}

+ (void)shareWithText:(NSString *)text images:(id)image urlStr:(NSString *)urlStr title:(NSString *)title type:(NSInteger *)type {
    
    //创建分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:text images:image url:[NSURL URLWithString:urlStr] title:title type:SSDKContentTypeAuto];
//    [shareParams SSDKSetupShareParamsByText:@"分享sinaweibo"
//                                     images:nil //传入要分享的图片
//                                        url:[NSURL URLWithString:@"http://write.blog.csdn.net/postlist"]
//                                      title:@"我的博客"
//                                       type:SSDKContentTypeAuto];
    
//    - (void)SSDKSetupShareParamsByText:(NSString *)text
//images:(id)images
//url:(NSURL *)url
//title:(NSString *)title
//type:(SSDKContentType)type;
    //进行分享
    [ShareSDK share:(int)type //传入分享的平台类型
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
         // 回调处理....}];
         NSLog(@"=============& %lu", (unsigned long)state);
         if (state == 1) {
             UIAlertView *aler = [[UIAlertView alloc] initWithTitle:@"share success!" message:nil delegate:self cancelButtonTitle:@"YES" otherButtonTitles:nil, nil];
             [aler show];
         }
     }];

}

- (void)sendSMSWithText:(NSString *)text withViewController:(UIViewController *)currentVC {
    _currentVC = currentVC;
    
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
    
    ShareTools *shar = [[ShareTools alloc] init];
    if (messageClass != nil) {
        //  check wheather the current device is configurd for sending SMS Messages
        if ([messageClass canSendText]) {
            [shar displaySMSComposeMessageWithViewController:(UIViewController *)currentVC];
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Your device don't support SMS function!" message:nil delegate:self cancelButtonTitle:@"YES" otherButtonTitles:nil, nil];
        [alert show];
    }
    
}

- (void)displaySMSComposeMessageWithViewController:(UIViewController *)currentVC {
//    ShareTools *shar = [[ShareTools alloc] init];
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    NSString *smsBody = [NSString stringWithFormat:@"I am you!"];
    messageController.body = smsBody;
    
    [currentVC presentViewController:messageController animated:YES completion:nil];

//    shar.displaySMS();
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
//    ShareTools *shar = [[ShareTools alloc] init];
    
//    shar.dismissSMS();
    [_currentVC dismissViewControllerAnimated:YES completion:nil];
    NSLog(@"%d", result);
}

+ (void)goToShareWithText:(NSString *)title url:(NSURL *)url {
    
    //    [[ShareTools shareMyLove] sendSMSWithText:@"I am you~" withViewController:self];
    NSLog(@"title: %@, url: %@", title, url);

    //1、创建分享参数
    NSString *imageUrl = [NSString stringWithFormat:@"%@/Imgs//logo.jpg", COMMONURL];
    NSArray* imageArray = @[imageUrl];

    //  （注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    if (imageArray) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:[NSString stringWithFormat:@"%@%@", title, url]
                                         images:imageArray
                                            url:url
                                          title:title
                                           type:SSDKContentTypeAuto];
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                 items:nil
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       
                       switch (state) {
                           case SSDKResponseStateSuccess:
                           {
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           default:
                               break;
                       }
                   }
         ];}
    
}

+ (void)registerShare {
    //  设置ShareSDK的appKey
    [ShareSDK registerApp:@"130229393985c" activePlatforms:@[
                                                             @(SSDKPlatformTypeSinaWeibo),
                                                             @(SSDKPlatformTypeWechat),
                                                             @(SSDKPlatformTypeCopy),
                                                             @(SSDKPlatformTypeQQ)]
                 onImport:^(SSDKPlatformType platformType) {
                     switch (platformType) {
                         case SSDKPlatformTypeWechat:
                             [ShareSDKConnector connectWeChat:[WXApi class]];
                             break;
                         case SSDKPlatformTypeQQ:
                             [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                             break;
                         case SSDKPlatformTypeSinaWeibo:
                             [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                             break;
                         default:
                             break;
                     }
                 } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
                     switch (platformType) {
                         case SSDKPlatformTypeSinaWeibo:
                             //  设置新浪微博应用信息, 其中authType设置为使用SSO+Web形式授权
                             [appInfo SSDKSetupSinaWeiboByAppKey:@"2531681836" appSecret:@"b9d2781af7dff50fd644368fc66e1e4d" redirectUri:@"http://www.go2family.com" authType:SSDKAuthTypeBoth];
                             break;
                             //  微信分享等待审核中
                         case SSDKPlatformTypeWechat:
                             [appInfo SSDKSetupWeChatByAppId:@"wxf9f0ebd174b6a9cf" appSecret:@"453de1bee5c96216e72fb103ee2cf995"];
                             break;
                             //  qq
                         case SSDKPlatformTypeQQ:
                             [appInfo SSDKSetupQQByAppId:@"1105241900" appKey:@"EdY0xRX12b09xYKL" authType:SSDKAuthTypeBoth];
                             break;
                         case SSDKPlatformTypeSMS:
                             //  短信
                             //                                                                [appInfo ssdk];
                         default:
                             break;
                     }
                 }];
}


@end
