//
//  BlueToothUnlockController.h
//  YeaLink
//
//  Created by 李根 on 16/5/17.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "QJLBaseViewController.h"
#import "DHBle.h"

#define RSSI_THRESHOLD -60
#define WARNING_MESSAGE @"z"

@class CBPeripheral;
@class DHBle;

@interface BlueToothUnlockController : QJLBaseViewController<DHBleDelegate>


@property (strong, nonatomic) CBPeripheral *peripheral;
@property (strong, nonatomic) DHBle *sensor;
@property (nonatomic, assign, readwrite) UInt32 deviceId;
@property (nonatomic, assign, readwrite) UInt32 devicePassword;

//@property (strong, nonatomic) NSTimer *timer;

@property (strong, nonatomic) NSMutableArray *rssi_container; // used for contain the indexers of the lower rssi value

//@property (weak, nonatomic) IBOutlet UILabel *BLKAppUUID; //  设备id Label

//- (IBAction)sendMsgToBTMode:(id)sender;   //
//- (IBAction)SendConnectDevice:(id)sender; //  连接设备
- (void)SendConnectDevice;
//- (IBAction)SendReadDeviceInfo:(id)sender;    //  读取设备信息
- (void)SendReadDeviceInfo:(id)sender;
//- (IBAction)SendConfigDevice:(id)sender;  //  发送配置
- (void)SendConfigDevice:(id)sender;
//- (IBAction)SendReadConfig:(id)sender;    //  读取配置
- (void)SendReadConfig:(id)sender;
//- (IBAction)SendSetPassword:(id)sender;   //  设置密码
- (void)SendSetPassword:(id)sender;
//- (IBAction)SendModifyName:(id)sender;    //  修改名称
- (void)SSendModifyName:(id)sender;
//- (IBAction)SendOpenDoor:(id)sender;  //  开门
- (void)SendOpenDoor;
//- (IBAction)SendCloseDoor:(id)sender; //  关门
- (void)SendCloseDoor;
//- (IBAction)sendSetIbeaconCofig:(id)sender;   //
//- (IBAction)sendSetIbeaconUUID:(id)sender;
//- (IBAction)sendConfigWifiSSID:(id)sender;
//- (IBAction)sendConfigWifiPaswd:(id)sender;
//- (IBAction)sendReadVersion:(id)sender;

@property (strong, nonatomic)UITextField *MsgToBTMode;
@property (strong, nonatomic)UITextView *tvRecv;
@property (strong, nonatomic)UILabel *lbDevice;
@property (strong, nonatomic)UILabel *lbDeviceId;




















@end
