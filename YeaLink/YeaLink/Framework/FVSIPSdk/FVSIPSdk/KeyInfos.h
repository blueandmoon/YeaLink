//
//  KeyInfos.h
//  FVSIPSdk
//
//  Created by  Tim Lei on 1/28/16.
//  Copyright © 2016 FreeView. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyInfos : NSObject

@property (nonatomic, assign) NSInteger villageID;  // 小区ID
@property (nonatomic, copy) NSString*   villageName; // 小区名称
@property (nonatomic, copy) NSString*   localDirectory; // 设备位置编码
@property (nonatomic, copy) NSString*   deviceName; // 设备名称


+ (instancetype)keyInfosWithJsonData:(NSDictionary*) jsonData;
@end
