//
//  Constants+Config.h
//  FVSIPSdk
//
//  Created by  Tim Lei on 11/25/15.
//  Copyright © 2015 FreeView. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Account Preference Keys
 */
extern NSString * const kPreferenceUsername;
extern NSString * const kPreferenceUerId;
extern NSString * const kPreferencePassword;
extern NSString * const kPreferenceDomain;
extern NSString * const kPreferenceProxy;
extern NSString * const kPreferenceTransport;
extern NSString * const kPreferencePort;
extern NSString * const kPreferenceRandomPort;
extern NSString * const kPreferenceUseIPv6;
extern NSString * const kPreferenceOutboundProxy;
extern NSString * const kPreferenceExpire;
extern NSString * const kPreferencePushNotification;
extern NSString * const kPreferenceSubstitute;
extern NSString * const kPreferencePrefix;
extern NSString * const kPreferenceAVPF;
extern NSString * const kPreferenceHA1;
extern NSString * const kPreferenceRegExpires; //default:600

/**
 *  Stun settings  (Firewall policy)
 */
extern NSString * const kPreferenceStun;
extern NSString * const kPreferenceICE;
extern NSString * const kPreferenceTunnelMode;
extern NSString * const kPreferenceTunnelAddress;
extern NSString * const kPreferenceTunnelPort;

/**
 *  Audio settings
 */
extern NSString * const kPreferenceAudioPort;//eg: 4000 - 5000

/**
 *  Video settings
 */
extern NSString * const kPreferenceVideoPort;  //eg: 5000 - 6000
extern NSString * const kPreferenceVideoPreferredFPS;
extern NSString * const kPreferenceVideoPreferredSize;
extern NSString * const kPreferenceStartVideo;
extern NSString * const kPreferenceAcceptVideo;
extern NSString * const kPreferenceSelfVideo;
extern NSString * const kPreferencePreview;
extern NSString * const kPreferenceVideoPreset;
extern NSString * const kPreferenceVideoCapture;
extern NSString * const kPreferenceVideoDisplay;

/**
 *  Transfer settings
 */
extern NSString * const kPreferenceAdaptiveRateControl;
extern NSString * const kPreferenceUploadBandwidth;
extern NSString * const kPreferenceDwonlaodBandwidth;

/**
 *  App settings
 */
extern NSString * const kPreferenceBackgroundMode;
extern NSString * const kPreferenceStartAtBoot;

@interface Constants_Config : NSObject

@end
