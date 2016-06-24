//
//  OwnerInfor.m
//  YeaLink
//
//  Created by 李根 on 16/6/14.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "OwnerInfor.h"
#import "OwnerModel.h"

@implementation OwnerInfor

+ (NSMutableArray *)getOwnerInfor {
    //  http://wapi.go2family.com/api/APIVillageManage/BindVillageList?UserID=13862578920
    __block NSMutableArray *ownerArr = [NSMutableArray array];
    
    NSString *strUrl = [NSString stringWithFormat:@"%@/api/APIVillageManage/BindVillageList?UserID=%@", COMMONURL, [UserInformation userinforSingleton].usermodel.UserID];
    NSLog(@"业主信息接口: %@", strUrl);
    [NetWorkingTool getNetWorking:strUrl block:^(id result) {
        
        ownerArr = [OwnerModel baseModelByArray:result[@"List"]];
        NSLog(@"ownerArr:%lu", (unsigned long)ownerArr.count);
        
    }];
    return ownerArr;
}

@end
