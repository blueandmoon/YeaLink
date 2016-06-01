//
//  GetUserInformation.h
//  YeaLink
//
//  Created by 李根 on 16/5/31.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GetUserInformation : NSObject
@property(nonatomic, strong)void(^doSomething)();   //  执行一些操作

+ (void)getUserInfroWithUserName:(NSString *)UserName;

@end
