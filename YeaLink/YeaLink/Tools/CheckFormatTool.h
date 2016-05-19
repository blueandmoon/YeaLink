//
//  CheckFormatTool.h
//  YeaLink
//
//  Created by 李根 on 16/4/29.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CheckFormatTool : NSObject
#pragma mark    - 正则匹配手机号
+ (BOOL)checkTelNumber:(NSString *)telNumber;
#pragma mark    - 正则匹配用户密码6 - 20位的数字和字母组合
+ (BOOL)checkPassword:(NSString *)password;



@end
