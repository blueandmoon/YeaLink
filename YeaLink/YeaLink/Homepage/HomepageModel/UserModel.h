//
//  UserModel.h
//  YeaLink
//
//  Created by 李根 on 16/5/9.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "BaseModel.h"

@interface UserModel : BaseModel
@property(nonatomic, strong)NSString *APPUserRole;
@property(nonatomic, strong)NSString *CityID;
@property(nonatomic, strong)NSString *Email;
@property(nonatomic, strong)NSString *HeadThumbPath;
@property(nonatomic, strong)NSString *ImageID;
@property(nonatomic, strong)NSString *NickName;
@property(nonatomic, strong)NSString *OwnerId;
@property(nonatomic, strong)NSString *UserID;
@property(nonatomic, strong)NSString *VName;

@end
