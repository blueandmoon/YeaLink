//
//  ReportMemory.h
//  YeaLink
//
//  Created by 李根 on 16/6/6.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <mach/mach.h>
/**
 *  打印出当前占用内存
 */
@interface ReportMemory : NSObject

+ (void)reportCurrentMemory;

@end
