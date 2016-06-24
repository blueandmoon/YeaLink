//
//  ClearCache.h
//  YeaLink
//
//  Created by 李根 on 16/6/15.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClearCache : NSObject

+ (instancetype)shareClearCache;
//  计算缓存大小
- (float)clearCache;
//  清除缓存
- (void)removeCache;

@end
