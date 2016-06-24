//
//  ClearCache.m
//  YeaLink
//
//  Created by 李根 on 16/6/15.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "ClearCache.h"

@implementation ClearCache

+ (instancetype)shareClearCache {
    static ClearCache *clear;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        clear = [[ClearCache alloc] init];
        
    });
    return clear;
}

- (instancetype)init {
    if (self = [super init]) {
        [self removeCache];
    }
    return self;
}

- (float)clearCache {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    float folderSize;
    
    if ([fileManager fileExistsAtPath:path]) {
        //  拿到有文件的数组
        NSArray *chilerFile = [fileManager subpathsAtPath:path];
        
        //  拿到每个文件的名字, 如果有不想清除的文件, 就在这里判断
        for (NSString *fileName in chilerFile) {
            //  将路径拼接到一起
            NSString *fullPath = [path stringByAppendingPathComponent:fileName];
            folderSize += [self fileSizePath:fullPath];
        }
    }
    return folderSize;
}

//  计算文件的大小
- (float)fileSizePath:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:path]) {
        long long size = [fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return size / 1024.0/1024.0;
    }
    return 0;
}

//  清除缓存
- (void)removeCache {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        NSArray *childerFiles = [fileManager subpathsAtPath:path];
        for (NSString *fileName in childerFiles) {
            //  如果有需要, 加入条件, 过滤掉不想删除的文件
            NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }
}


@end
