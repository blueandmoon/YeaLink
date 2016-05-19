//
//  DeviceTableViewController.h
//  YeaLink
//
//  Created by 李根 on 16/5/17.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "QJLBaseViewController.h"
#import "DHBle.h"

@class BlueToothUnlockController;

@interface DeviceTableViewController : QJLBaseViewController<DHBleDelegate, UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong)DHBle *sensor;
@property(nonatomic,retain)NSMutableArray *peripheralViewControllerArray;

- (void)scanAppDevices:(id)sender;

- (void)scanTimer:(NSTimer *)timer;

@property(nonatomic, strong)QJLBaseTableView *btAppTableView;
@property(nonatomic, strong)QJLBaseButton *scanbtn;



















@end












