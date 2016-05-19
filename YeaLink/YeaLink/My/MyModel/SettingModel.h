//
//  SettingModel.h
//  YeaLink
//
//  Created by 李根 on 16/5/12.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "BaseModel.h"

@interface SettingModel : BaseModel
@property(nonatomic, strong)NSString *Name;
@property(nonatomic, strong)NSString *ImageUrl;
@property(nonatomic, strong)NSString *ServicePath;

@end
