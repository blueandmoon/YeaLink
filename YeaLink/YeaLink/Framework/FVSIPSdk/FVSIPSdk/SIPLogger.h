//
//  SIPLogger.h
//  FVSIPSdk
//
//  Created by  Tim Lei on 11/11/15.
//  Copyright © 2015 FreeView. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ortp/ortp.h>

#ifdef __cplusplus
extern "C" {
#endif

void sip_iphone_log_handler(int lev, const char *fmt, va_list args);
    
#ifdef __cplusplus
}
#endif

@interface SIPLogger : NSObject

+ (void)log:(OrtpLogLevel)severity file:(const char *)file line:(int)line format:(NSString *)format, ...;

@end

#define LOGV(level, ...) [SIPLogger log:level file:__FILE__ line:__LINE__ format:__VA_ARGS__]
#define LOGD(...) LOGV(ORTP_DEBUG, __VA_ARGS__)
#define LOGI(...) LOGV(ORTP_MESSAGE, __VA_ARGS__)
#define LOGW(...) LOGV(ORTP_WARNING, __VA_ARGS__)
#define LOGE(...) LOGV(ORTP_ERROR, __VA_ARGS__)
#define LOGF(...) LOGV(ORTP_FATAL, __VA_ARGS__)