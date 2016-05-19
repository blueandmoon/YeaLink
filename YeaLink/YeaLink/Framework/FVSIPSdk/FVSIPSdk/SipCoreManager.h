//
//  SipCoreManager.h
//  FVSIPSdk
//
//  Created by  Tim Lei on 11/9/15.
//  Copyright © 2015 FreeView. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SystemConfiguration/SCNetworkReachability.h>
#include "linphone/linphonecore.h"
#import <UIKit/UIKit.h>

typedef enum _TunnelMode {
    tunnel_off = 0,
    tunnel_on,
    tunnel_wwan,
    tunnel_auto
} TunnelMode;

typedef enum _Connectivity {
    wifi,
    wwan,
    none
} Connectivity;

struct NetworkReachabilityContext {
    BOOL testWifi;
    BOOL testWWan;
    void (*networkStateChanged) (Connectivity newConnectivity);
};

/* Application specific call context */
typedef struct _CallContext {
    LinphoneCall* call;
    bool_t cameraIsEnabled;
} CallContext;

@interface SipCoreManager : NSObject {
@public
    CallContext currentCallContextBeforeGoingBackground;
}

/**
 * Returns the shared singleton
 */
+ (instancetype)sharedManager;

@property (nonatomic, assign) BOOL speakerEnabled;
@property (nonatomic, assign) BOOL bluetoothAvailable;
@property (nonatomic, assign) BOOL bluetoothEnabled;

@property Connectivity connectivity;
@property (nonatomic, assign) TunnelMode tunnelMode;

@property (nonatomic, strong) NSData *pushNotificationToken;
@property (readonly) BOOL wasRemoteProvisioned;

@property (copy) void (^silentPushCompletion)(UIBackgroundFetchResult);

+ (NSString *)getPreferenceForCodec: (const char*) name withRate: (int) rate;
+ (BOOL)isCodecSupported: (const char*)codecName;
+ (NSSet *)unsupportedCodecs;
+ (NSString*)getRemoteAddressViaCall:(LinphoneCall*) call;
/**
 *  To get current user agent name.
 *
 *  @return name of user agent.
 */
+ (NSString *)getUserAgent;

/**
 *  Call out with peer address.
 *
 *  @param address     peer address
 *  @param displayName display name
 *  @param transfer    transfer description
 */
- (void)call:(NSString *)address displayName:(NSString*)displayName transfer:(BOOL)transfer;

/**
 *  Accept a call via call id.
 *
 *  @param callid identifier of a call.
 */
- (void)acceptCallForCallId:(NSString *)callid;

/**
 *  Accept a call via LinphoneCall
 *
 *  @param call instance of linphone call
 */
- (void)acceptCall:(LinphoneCall *)call;

/**
 *  Accept a early media for call via LinphoneCall
 *
 *  @param call instance of linphone call
 */
- (void)acceptEarlyMedia:(LinphoneCall *)call;

/**
 *  Hangup a call via LinphoneCall
 *
 *  @param call instance of linphone call
 */
- (void)hangupCall:(LinphoneCall *)call;

/**
 *  Set video view handle
 *
 *  @param videoView    The view to display remote video
 *  @param videoPreview The view to display self video
 */
- (void)setVideoView:(id) videoView  videoPreview:(id) videoPreview;

/**
 *  Mic Enable
 */
- (void)muteMic:(BOOL) bMuted;
- (BOOL)isMicMuted;

/**
 *  Send dtmf
 *
 *  @param Dtmf
 */
- (void)sendDtmf:(char) dtmf;

/**
 *  Call handlers
 */
- (void)addPushCallId:(NSString *)callid;
- (BOOL)popPushCallID:(NSString *)callId;

/**
 *  Handler for application enter background/foreground
 */
- (void)refreshRegisters;
- (BOOL)resignActive;
- (void)becomeActive;
- (BOOL)enterBackgroundMode;

/**
 *  To get speaker status
 *
 *  @return YES allow speaker or NO
 */
- (BOOL)allowSpeaker;

/**
 *  To get current sip core instance.
 *
 *  @return Current sip core instance.
 */
+ (LinphoneCore *)getLc;

/**
 *  Start/Destroy sip core.
 */
- (void)startSipCore;
- (void)destroySipCore;

/**
 *  Enable/Disable logs.
 *
 *  @param enabled flag of logs, set to be YES if you want to enbale logs or NO.
 */
- (void)setLogsEnabled:(BOOL)enabled;

/**
 *  <#Description#>
 *
 *  @param username    <#username description#>
 *  @param displayName <#displayName description#>
 *  @param userID      <#userID description#>
 *  @param password    <#password description#>
 *  @param domain      <#domain description#>
 *  @param proxyServer <#proxyServer description#>
 *  @param transport   <#transport description#>
 *
 *  @return <#return value description#>
 */
- (BOOL)addAccountWithUserName:(NSString*)username
                   displayName:(NSString*)displayName
                        userId:(NSString*)userID
                      password:(NSString*)password
                        domain:(NSString*)domain
                   proxyServer:(NSString*)proxyServer
                     transport:(NSString*)transport;
/**
 *  Add account(proxy config) to SIP core.
 *
 *  @param userName  SIP user name;
 *  @param password  Password of user
 *  @param domain    SIP server Domain or IPAddress
 *  @param transport SIP transport  "UDP" , "TCP" or "TLS"
 */
- (BOOL)addAccountWithUserName:(NSString*) userName
                       password:(NSString*) password
                         domain:(NSString*) domain
                      transport:(NSString*) transport;

/**
 *  Remove all accounts from SIP core.
 */
- (void)removeAllAccounts;

@end
