//
//  AppDelegate.m
//  YeaLink
//
//  Created by 李根 on 16/4/24.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "AppDelegate.h"
#import "HomepageViewController.h"
#import "FindViewController.h"
#import "MyViewController.h"
#import "ShowViewController.h"
#import "NewsViewController.h"
#import "NetworkState.h"
#import "LoginViewController.h"
#import "UIImage+Oricon.h"

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


@interface AppDelegate () {
@private
    UIBackgroundTaskIdentifier _bgStartId;
    BOOL _startedInBackground;
}

@end

@interface AppDelegate ()<UITabBarControllerDelegate>


@end

@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [NetworkState checkNetworkState];   //  检测网络状态
    
    HomepageViewController *homePageVC = [[HomepageViewController alloc] init];
    FindViewController *findVC = [[FindViewController alloc] init];
    ShowViewController *showVC = [[ShowViewController alloc] init];
    NewsViewController *newsVC = [[NewsViewController alloc] init];
    MyViewController *myVC = [[MyViewController alloc] init];
    
    UINavigationController *homePageNaVC = [[UINavigationController alloc] initWithRootViewController:homePageVC];
    UINavigationController *findNaVC = [[UINavigationController alloc] initWithRootViewController:findVC];
    UINavigationController *showNaVC = [[UINavigationController alloc] initWithRootViewController:showVC];
    UINavigationController *newsNaVC = [[UINavigationController alloc] initWithRootViewController:newsVC];
    UINavigationController *myNaVC = [[UINavigationController alloc] initWithRootViewController:myVC];
    
    homePageNaVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:[UIImage imageNamed:@"Home32"] tag:1000];
    
    findNaVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"发现" image:[UIImage imageNamed:@"Search32"] tag:1001];
    showNaVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"秀场" image:[UIImage imageNamed:@"Show32"] tag:1002];
    newsNaVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"消息" image:[UIImage imageNamed:@"Msg32"] tag:1003];
    myNaVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:[UIImage imageNamed:@"User32"] tag:1004];
    
    
//    [tab presentViewController:loginVC animated:YES completion:^{
//        
//    }];
    UITabBarController *tab = [[UITabBarController alloc] init];
    tab.viewControllers = @[homePageNaVC, findNaVC, showNaVC, newsNaVC, myNaVC];
    self.window.rootViewController = tab;
    
//    tab.tabBar.tintColor = [UIColor grayColor];
    
    
    tab.delegate = self;
    tab.selectedIndex = 0;
    
    
#pragma mark    - SIP
    
    UIApplication *app = [UIApplication sharedApplication];
    UIApplicationState state = app.applicationState;
    
    SipCoreManager *sharedMgr = [SipCoreManager sharedManager];
    
    BOOL background_mode = [SipCoreConfig getBackgroundModeEnable];
    BOOL start_at_boot = [SipCoreConfig getStartAtBootEnable];
    
    UIUserNotificationType notifTypes =
    UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    
    NSSet *categories =
    [NSSet setWithObjects:[self getCallNotificationCategory], nil];
    UIUserNotificationSettings *userSettings =
    [UIUserNotificationSettings settingsForTypes:notifTypes categories:categories];
    [app registerUserNotificationSettings:userSettings];
    [app registerForRemoteNotifications];
    
    if (state == UIApplicationStateBackground) {
        // we've been woken up directly to background;
        if (!start_at_boot || !background_mode) {
            // autoboot disabled or no background, and no push: do nothing and wait for a real launch
            /*output a log with NSLog, because the ortp logging system isn't activated yet at this time*/
            NSLog(@"Linphone launch doing nothing because start_at_boot or background_mode are not activated.", NULL);
            return YES;
        }
    }
    
    _bgStartId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        NSLog(@"Background task for application launching expired.");
        [[UIApplication sharedApplication] endBackgroundTask:_bgStartId];
    }];
    
    signal(SIGPIPE, SIG_IGN);
    [sharedMgr startSipCore];
    
//    [[UINavigationBar appearance] setBarTintColor:NavigationBar_Bar_Tint_Color];
//    [[UINavigationBar appearance] setTitleTextAttributes: [AppTheme navigationTitleAttributes]];
//    [[UINavigationBar appearance] setTintColor:NavigationBar_Tint_Color];
    
    NSDictionary *remoteNotif = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (remoteNotif) {
        NSLog(@"PushNotification from launch received.");
        [self processRemoteNotification:remoteNotif];
    }
    
    if (_bgStartId != UIBackgroundTaskInvalid)
        [[UIApplication sharedApplication] endBackgroundTask:_bgStartId];
    
    [self.window makeKeyAndVisible];
    
#pragma mark    - ShareSDK分享
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
                                                                [appInfo SSDKSetupSinaWeiboByAppKey:@"3745736124" appSecret:@"faf8ad15e9375aab29976de2d1893555" redirectUri:@"http://www.sharesdk.cn" authType:SSDKAuthTypeBoth];
                                                                break;
                                                                //  微信分享等待审核中
                                                                case SSDKPlatformTypeWechat:
                                                                [appInfo SSDKSetupWeChatByAppId:@"    com.huize.*" appSecret:@"d376575e8ebd6599e7b706a94e366872"];
                                                                break;
                                                                //  qq
                                                                case SSDKPlatformTypeQQ:
                                                                [appInfo SSDKSetupQQByAppId:@"1105430634" appKey:@"1o4BUs6itbzgazMX" authType:SSDKAuthTypeBoth];
                                                                break;
                                                            default:
                                                                break;
                                                        }
                                                    }];
    
    
    
    //  设定不是从相册返回
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"selectPhoto"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    NSLog(@"%@", NSStringFromSelector(_cmd));
    LinphoneCore *lc = [SipCoreManager getLc];
    LinphoneCall *call = linphone_core_get_current_call(lc);
    
    if (call) {
        /* save call context */
        SipCoreManager *instance = [SipCoreManager sharedManager];
        instance->currentCallContextBeforeGoingBackground.call = call;
        instance->currentCallContextBeforeGoingBackground.cameraIsEnabled = linphone_call_camera_enabled(call);
        
        const LinphoneCallParams *params = linphone_call_get_current_params(call);
        if (linphone_call_params_video_enabled(params)) {
            linphone_call_enable_camera(call, false);
        }
    }
    
    if (![[SipCoreManager sharedManager] resignActive]) {
    }

    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    NSLog(@"%@", NSStringFromSelector(_cmd));
    [[SipCoreManager sharedManager] enterBackgroundMode];
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    if (_startedInBackground) {
        _startedInBackground = FALSE;
        //Update Main UI
    }
    SipCoreManager *instance = [SipCoreManager sharedManager];
    
    [instance becomeActive];
    
    LinphoneCore *lc = [SipCoreManager getLc];
    LinphoneCall *call = linphone_core_get_current_call(lc);
    
    if (call) {
        if (call == instance->currentCallContextBeforeGoingBackground.call) {
            const LinphoneCallParams *params = linphone_call_get_current_params(call);
            if (linphone_call_params_video_enabled(params)) {
                linphone_call_enable_camera(call, instance->currentCallContextBeforeGoingBackground.cameraIsEnabled);
            }
            instance->currentCallContextBeforeGoingBackground.call = 0;
        } else if (linphone_call_get_state(call) == LinphoneCallIncomingReceived || linphone_call_get_state(call) == LinphoneCallStreamsRunning) {
            [_mainViewController displayIncomingCall:call];
            // in this case, the ringing sound comes from the notification.
            // To stop it we have to do the iOS7 ring fix...
            [self fixRing];
        }
        NSLog(@"linphone_call_get_state(call) ==== %d",linphone_call_get_state(call));
    }

}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (UIUserNotificationCategory *)getCallNotificationCategory {
    UIMutableUserNotificationAction *answer = [[UIMutableUserNotificationAction alloc] init];
    answer.identifier = kNotificationIdentifierAnswer;
    answer.title = NSLocalizedString(@"Answer", nil);
    answer.activationMode = UIUserNotificationActivationModeForeground;
    answer.destructive = NO;
    answer.authenticationRequired = YES;
    
    UIMutableUserNotificationAction *decline = [[UIMutableUserNotificationAction alloc] init];
    decline.identifier = kNotificationIdentifierDecline;
    decline.title = NSLocalizedString(@"Decline", nil);
    decline.activationMode = UIUserNotificationActivationModeBackground;
    decline.destructive = YES;
    decline.authenticationRequired = NO;
    
    NSArray *localRingActions = @[ decline, answer ];
    
    UIMutableUserNotificationCategory *localRingNotifAction = [[UIMutableUserNotificationCategory alloc] init];
    localRingNotifAction.identifier = kNotificationIdentifierIncomingCall;
    [localRingNotifAction setActions:localRingActions forContext:UIUserNotificationActionContextDefault];
    [localRingNotifAction setActions:localRingActions forContext:UIUserNotificationActionContextMinimal];
    
    return localRingNotifAction;
}

- (void)processRemoteNotification:(NSDictionary *)userInfo {
    
    NSDictionary *aps = [userInfo objectForKey:@"aps"];
    
    if (aps != nil) {
        NSDictionary *alert = [aps objectForKey:@"alert"];
        if (alert != nil) {
            NSString *loc_key = [alert objectForKey:@"loc-key"];
            /*if we receive a remote notification, it is probably because our TCP background socket was no more working.
             As a result, break it and refresh registers in order to make sure to receive incoming INVITE or MESSAGE*/
            LinphoneCore *lc = [SipCoreManager getLc];
            if (linphone_core_get_calls(lc) == NULL) { // if there are calls, obviously our TCP socket shall be working
                linphone_core_set_network_reachable(lc, FALSE);
                [SipCoreManager sharedManager].connectivity = none; /*force connectivity to be discovered again*/
                [[SipCoreManager sharedManager] refreshRegisters];
                if (loc_key != nil) {
                    
                    NSString *callId = [userInfo objectForKey:@"call-id"];
                    if (callId != nil) {
                        [[SipCoreManager sharedManager] addPushCallId:callId];
                    } else {
                        NSLog(@"PushNotification: does not have call-id yet, fix it !");
                    }
                    
                    if ([loc_key isEqualToString:@"IC_MSG"]) {
                        [self fixRing];
                    }
                }
            }
        }
    }
}

- (void)fixRing {
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        // iOS7 fix for notification sound not stopping.
        // see http://stackoverflow.com/questions/19124882/stopping-ios-7-remote-notification-sound
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    }
}


@end
