//
//  ReportMemory.m
//  YeaLink
//
//  Created by 李根 on 16/6/6.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "ReportMemory.h"

@implementation ReportMemory

+ (void)reportCurrentMemory {
    struct task_basic_info info;
    mach_msg_type_number_t size = sizeof(info);
    kern_return_t kerr = task_info(mach_task_self(),
                                   TASK_BASIC_INFO,
                                   (task_info_t)&info,
                                   &size);
    if( kerr == KERN_SUCCESS )
    {
        //printf("Memory vm : %u\n",info.virtual_size);
        //printf("Memory in use (in bytes): %u b\n", info.resident_size);
        //printf("Memory in use (in k-bytes): %f k\n", info.resident_size / 1024.0);
        printf("当前占用内存为Memory in use (in m-bytes): %f m\n", info.resident_size / (1024.0 * 1024.0));
    }
    else
    {
        printf("Error with task_info(): %s\n", mach_error_string(kerr));
    }
}

@end
