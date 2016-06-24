//
//  AppDelegate.m
//  YeaLink
//
//  Created by 李根 on 16/4/24.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "AppDelegate.h"
#import "LeadViewController.h"
#import "HomepageViewController.h"
#import "FindViewController.h"
#import "MyViewController.h"
#import "ShowViewController.h"
#import "NewsViewController.h"
#import "NetworkState.h"
#import "LoginViewController.h"
#import "UIImage+Oricon.h"
#import "ReportVersionInfo.h"
#import "SIPPhoneHomeViewController.h"
#import "ObseverCalling.h"

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
    
    homePageNaVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"首页" image:[UIImage imageNamed:@"homeg-1"] tag:1000];
    
    findNaVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"发现" image:[UIImage imageNamed:@"search-1"] tag:1001];
//    UIImage *image = [UIImage originImage:[UIImage imageNamed:@"Msg32"] scaleToSize:CGSizeMake(32, 32)];
    showNaVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"秀场" image:[UIImage imageNamed:@"showg-1"] tag:1002];
    newsNaVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"消息" image:[UIImage imageNamed:@"Msg-1"] tag:1003];
    myNaVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"我的" image:[UIImage imageNamed:@"user-1"] tag:1004];
    
    

    UITabBarController *tab = [[UITabBarController alloc] init];
    tab.viewControllers = @[homePageNaVC, findNaVC, showNaVC, newsNaVC, myNaVC];
    
    //  引导页
    NSString *currenVersion = [ReportVersionInfo getVersionInfo];
    NSUserDefaults *userdef = [NSUserDefaults standardUserDefaults];
    LeadViewController *leadVC = [[LeadViewController alloc] init];
    NSLog(@"currentVersion: %@", [userdef objectForKey:@"currenVersion"]);
    if (![[userdef objectForKey:@"currenVersion"] isEqualToString:currenVersion]) {
        NSLog(@"开始引导页");
        [userdef setObject:currenVersion forKey:@"currenVersion"];
        [userdef synchronize];
        self.window.rootViewController = leadVC;
    } else {
        self.window.rootViewController = tab;
    }
    leadVC.changeRootVC = ^() {
        self.window.rootViewController = tab;
    };
    
    
    
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
    
    //  注册分享
    [ShareTools registerShare];
    
    // 设置应用程序右上角的"通知图标"Badge
//    app.applicationIconBadgeNumber = 0;  // 根据逻辑设置
    
    //  设定不是从相册返回
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"selectPhoto"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //  3DTouch
    [self configShortcutItems];
    UIApplicationShortcutItem *shortcutItem = [launchOptions valueForKey:UIApplicationLaunchOptionsShortcutItemKey];
    //  如果是从快捷选项标签启动app, 则根据不同标识执行不同操作, 然后返回NO, 防止调用- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler
    
    if (shortcutItem) {
        //  判断先前我们设置的快捷选项标签唯一标识, 根据不同标识执行不同操作
        if ([shortcutItem.type isEqualToString:@"com.huize.video"]) {
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"entranceType" object:nil userInfo:@{@"type": @"com.huize.video"}];
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isFrom3DTouchVideo"];
        } else {
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"entranceType" object:nil userInfo:@{@"type": @"com.huize.blueTooth"}];
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isFrom3DTouchBlueTooth"];
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        return NO;
    }
    
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

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    return UIInterfaceOrientationMaskPortrait;
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
//            [_mainViewController displayIncomingCall:call];
            [[ObseverCalling shareObseverCalling] displayIncomingCall:call];
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

#pragma - mark  - 3DTouch
- (void)configShortcutItems {
    
    NSMutableArray *shortcutItems = [NSMutableArray array];
    UIApplicationShortcutIcon *videoIcon = [UIApplicationShortcutIcon iconWithTemplateImageName:@"video"];
    UIApplicationShortcutItem *videoItem = [[UIApplicationShortcutItem alloc] initWithType:@"com.huize.video" localizedTitle:@"video" localizedSubtitle:nil icon:videoIcon userInfo:nil];
    
    UIApplicationShortcutIcon *blueToothIcon = [UIApplicationShortcutIcon iconWithTemplateImageName:@"blueTooth"];
    UIApplicationShortcutItem *blueToothItem = [[UIApplicationShortcutItem alloc] initWithType:@"com.huize.blueTooth" localizedTitle:@"blueTooth" localizedSubtitle:nil icon:blueToothIcon userInfo:nil];
    
    [shortcutItems addObjectsFromArray:@[videoItem, blueToothItem]];
    [[UIApplication sharedApplication] setShortcutItems:shortcutItems];
}

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler {
    
    if ([shortcutItem.type isEqualToString:@"com.huize.video"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"entranceType" object:nil userInfo:@{@"type": @"com.huize.video"}];
        NSLog(@"3DTouch:1");
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"entranceType" object:nil userInfo:@{@"type": @"com.huize.blueTooth"}];
        NSLog(@"3DTouch:2");
    }

}

@end
