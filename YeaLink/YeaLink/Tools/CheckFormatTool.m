//
//  CheckFormatTool.m
//  YeaLink
//
//  Created by 李根 on 16/4/29.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "CheckFormatTool.h"

@implementation CheckFormatTool
+ (BOOL)checkTelNumber:(NSString *)telNumber {
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    NSPredicate *regextestMobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    BOOL reg = [regextestMobile evaluateWithObject:telNumber];
//    if (reg) {
//        NSLog(@"正确的手机号!");
//        return YES;
//    } else {
//        NSLog(@"手机号码不正确, 请输入正确的手机号");
//        return NO;
//    }
    return [regextestMobile evaluateWithObject:telNumber];
}

+ (BOOL)checkPassword:(NSString *)password {
    NSString *passwordRegex = @"^[a-zA-Z0-9]{6,20}+$";
    NSPredicate *passwordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", passwordRegex];
    return [passwordPredicate evaluateWithObject:password];
}

@end
