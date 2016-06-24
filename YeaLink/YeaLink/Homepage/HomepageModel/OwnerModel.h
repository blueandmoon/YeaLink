//
//  OwnerModel.h
//  YeaLink
//
//  Created by 李根 on 16/6/14.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "BaseModel.h"

@interface OwnerModel : BaseModel
@property(nonatomic, strong)NSString *OwnerID;  //  业主ID
@property(nonatomic, strong)NSString *VID;  //  小区编号
@property(nonatomic, strong)NSString *VName;    //  小区名
@property(nonatomic, strong)NSString *BID;  //  楼栋号
@property(nonatomic, strong)NSString *Unit; //  单元
@property(nonatomic, strong)NSString *RID;  //  房间号

@end
