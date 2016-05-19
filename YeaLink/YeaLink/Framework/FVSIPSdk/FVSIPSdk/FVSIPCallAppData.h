//
//  FVSIPCallAppData.h
//  FVSIPSdk
//
//  Created by  Tim Lei on 11/11/15.
//  Copyright © 2015 FreeView. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FVSIPCallAppData : NSObject {
@public
    BOOL batteryWarningShown;
    UILocalNotification *notification;
    NSMutableDictionary *userInfos;
    BOOL videoRequested; /*set when user has requested for video*/
    NSTimer* timer;
};

@end
