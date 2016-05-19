//
//  ServiceModel.h
//  YeaLink
//
//  Created by 李根 on 16/5/4.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "BaseModel.h"

@interface ServiceModel : BaseModel
@property(nonatomic, strong)NSString *GUID;
@property(nonatomic, strong)NSString *SeviceName;
@property(nonatomic, strong)NSString *ServiceLogo;
@property(nonatomic, strong)NSString *SeviceAddress;
@property(nonatomic, strong)NSString *IconPath; //  广告区的图片地址

@end
