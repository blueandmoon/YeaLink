//
//  DeviceView.h
//  YeaLink
//
//  Created by 李根 on 16/5/17.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "QJLBaseView.h"

@interface DeviceView : QJLBaseView
@property(nonatomic, strong)QJLBaseTextfield *passwordField;
@property(nonatomic, strong)QJLBaseButton *connectBtn;
@property(nonatomic, strong)QJLBaseButton *disconnectBtn;
@property(nonatomic, strong)QJLBaseButton *openDoorBtn;
@property(nonatomic, strong)QJLBaseButton *closeDoorBtn;

@end
