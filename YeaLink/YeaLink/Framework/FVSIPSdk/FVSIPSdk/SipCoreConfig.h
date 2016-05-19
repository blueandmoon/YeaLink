//
//  SipCoreConfig.h
//  FVSIPSdk
//
//  Created by  Tim Lei on 12/29/15.
//  Copyright © 2015 FreeView. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SipCoreConfig : NSObject

/**
 *  Audio
 */
+ (BOOL) getPcmuEnable;
+ (void) setPcmuEnable:(BOOL) enable;
+ (BOOL) getPcmaEnable;
+ (void) setPcmaEnable:(BOOL) enable;
+ (BOOL) getSpeedx8Enable;
+ (void) setSpeedx8Enable:(BOOL) enable;
+ (BOOL) getSpeedx16Enable;
+ (void) setSpeedx16Enable:(BOOL) enable;
+ (BOOL) getOpus48Enable;
+ (void) setOpus48Enable:(BOOL) enable;
+ (BOOL) getSilk16Enable;
+ (void) setSilk16Enable:(BOOL) enable;
+ (BOOL) getAccEld16Enable;
+ (void) setAccEld16Enable:(BOOL) enable;
+ (BOOL) getAccEld22Enable;
+ (void) setAccEld22Enable:(BOOL) enable;
+ (BOOL) getAccEld32Enable;
+ (void) setAccEld32Enable:(BOOL) enable;
+ (BOOL) getAccEld44Enable;
+ (void) setAccEld44Enable:(BOOL) enable;
+ (BOOL) getAccEld48Enable;
+ (void) setAccEld48Enable:(BOOL) enable;
+ (BOOL) getG722Enable;
+ (void) setG722Enable:(BOOL) enable;
+ (BOOL) getGsmEnable;
+ (void) setGsmEnable:(BOOL) enable;
+ (BOOL) getILbcEnable;
+ (void) setILbcEnable:(BOOL) enable;
+ (BOOL) getISacEnable;
+ (void) setISacEnable:(BOOL) enable;

/**
 *  Video
 */
+ (BOOL) getVideoEnable;
+ (void) setVideoEnable:(BOOL) enable;
+ (BOOL) getMpeg4Enable;
+ (void) setMpeg4Enable:(BOOL) enable;
+ (BOOL) getH264Enable;
+ (void) setH264Enable:(BOOL) enable;
+ (BOOL) getVP8Enable;
+ (void) setVP8Enable:(BOOL) enable;

/**
 *  Network
 */
+ (BOOL) getIceEnable;
+ (void) setIceEnable:(BOOL) enable;
+ (void) setStunServer:(NSString*) serverAddr;
+ (NSString*) getStunServer;
+ (NSString*) getSipTransport;
+ (NSInteger) getAudioPort;
+ (void) setAudioPort:(NSInteger) port;
+ (void) setAudioPortRange:(NSInteger) minPort maxPort:(NSInteger) maxPort;
+ (NSString*) getAudioPortRange;//@"minPort-maxPort"
+ (NSInteger) getVideoPort;
+ (void) setVideoPort:(NSInteger) port;
+ (void) setVideoPortRange:(NSInteger) minPort maxPort:(NSInteger) maxPort;
+ (NSString*) getVideoPortRange; //@"minPort-maxPort"
+ (NSInteger) getSipPort;
+ (void) setSipPort:(NSInteger) port;
+ (BOOL) getIPv6Enable;
+ (void) setIPv6Enable:(BOOL) enable;
+ (void) setMediaEncryption:(NSString*) encryption;
+ (NSString*) getMediaEncryption;

/**
 *  Sip Account
 */
+ (NSDictionary*) getSipAccount;

/**
 *  Call
 */
+ (BOOL) getSendInbandDTMFEnable;
+ (void) setSendInbandDTMFEnable:(BOOL) enable;
+ (BOOL) getSendSIPInfoDTMFEnable;
+ (void) setSendSIPInfoDTMFEnable:(BOOL) enable;

/**
 *  Application && Advanced
 */
+ (BOOL) getDebugModeEnable;
+ (void) setDebugModeEnable:(BOOL) enable;
+ (BOOL) getBackgroundModeEnable;
+ (void) setBackgroundModeEnable:(BOOL) enable;
+ (BOOL) getStartAtBootEnable;
+ (void) setStartAtBootEnable:(BOOL) enable;
+ (NSInteger) getSipExpire;
+ (void) setSipExpire:(NSInteger) expire;

@end
