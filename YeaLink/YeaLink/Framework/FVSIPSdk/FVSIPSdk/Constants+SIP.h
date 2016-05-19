//
//  Constants+SIP.h
//  FVSIPSdk
//
//  Created by  Tim Lei on 11/11/15.
//  Copyright © 2015 FreeView. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kPreferenceDebugEnable;

/**
 *  Sip notification parameters
 */
extern NSString *const kFVSIPState;
extern NSString *const kFVSIPConfig;
extern NSString *const kFVSIPCall;
extern NSString *const kFVSIPMessage;
extern NSString *const kFVSIPMessageRoom;
extern NSString *const kFVSIPCallId;
extern NSString *const kFVSIPFromAddress;
extern NSString *const kFVSIPRemoteURI;

extern NSString *const kNotificationIdentifierAnswer;
extern NSString *const kNotificationIdentifierDecline;
extern NSString *const kNotificationIdentifierIncomingCall;

#define kCallId "Call-ID"

/**
 *  Call notification name
 */
extern NSString *const kFVSIPCoreUpdate;
extern NSString *const kFVSIPDisplayStatusUpdate;
extern NSString *const kFVSIPTextReceived;
extern NSString *const kFVSIPTextComposeEvent;
extern NSString *const kFVSIPCallUpdate;
extern NSString *const kFVSIPRegistrationUpdate;
extern NSString *const kFVSIPMainViewChange;
extern NSString *const kFVSIPAddressBookUpdate;
extern NSString *const kFVSIPLogsUpdate;
extern NSString *const kFVSIPSettingsUpdate;
extern NSString *const kFVSIPBluetoothAvailabilityUpdate;
extern NSString *const kFVSIPConfiguringStateUpdate;
extern NSString *const kFVSIPGlobalStateUpdate;
extern NSString *const kFVSIPNotifyReceived;
extern NSString *const kFVSIPFileTransferSendUpdate;
extern NSString *const kFVSIPFileTransferRecvUpdate;

/**
 *  Transport
 */
extern NSString *const kFVSIPTransportUdp;
extern NSString *const kFVSIPTransportTcp;
extern NSString *const kFVSIPTransportTls;  //  tls 传输层安全
extern NSString *const kFVSIPTransportDtls; //  dtls 数据安全传输协议

/**
 *  Media encryption
 */
extern NSString *const kFVSIPMediaEncryptionSRTP;   //  SRTP协议, 移动多媒体的解密算法
extern NSString *const kFVSIPMediaEncryptionZRTP;
extern NSString *const kFVSIPMediaEncryptionDTLS;
extern NSString *const kFVSIPMediaEncryptionNone;

@interface Constants_SIP : NSObject

@end
