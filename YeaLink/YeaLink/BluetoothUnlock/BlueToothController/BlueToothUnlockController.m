//
//  BlueToothUnlockController.m
//  YeaLink
//
//  Created by 李根 on 16/5/17.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "BlueToothUnlockController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "QuartzCore/QuartzCore.h"
#import "DeviceView.h"

@interface BlueToothUnlockController ()

@end

@implementation BlueToothUnlockController
{
    DeviceView *_deviceView;
}
Byte autoOpen = 1;

#define BUILD_UINT32(Byte0, Byte1, Byte2, Byte3) \
((UInt32)((UInt32)((Byte0) & 0x00FF) \
+ ((UInt32)((Byte1) & 0x00FF) << 8) \
+ ((UInt32)((Byte2) & 0x00FF) << 16) \
+ ((UInt32)((Byte3) & 0x00FF) << 24)))

extern const UInt8 Aes_KeyTable[16];

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = self.sensor.activePeripheral.name;
    self.sensor.delegate = self;
    
    //  设定密码
    self.devicePassword = 0x12345678;
    
//    NSString *str = @"0x87654321";
//    self.devicePassword = (UInt32)str.integerValue;
//    NSString *tempStr = @"231";
//    NSLog(@"tempStr.integerValue: %lu", tempStr.integerValue);
//    NSLog(@"____%lld", str.longLongValue);
    
    if (_peripheral == nil) {
        _peripheral = _sensor.activePeripheral;
    }
    
    [self getValue];
    
    
    
}
#pragma mark    - 各个按钮
- (void)getValue {
    _deviceView = [[DeviceView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, 205 * HEI)];
    [self.view addSubview:_deviceView];
    _deviceView.backgroundColor = [UIColor whiteColor];
    
}

- (void)openDoorAction:(id)sender {
    if(_sensor.activePeripheral.state != CBPeripheralStateConnected){
        _sensor.activePeripheral = _peripheral;
        [self.sensor connectDevice:_sensor.activePeripheral];
    } else {
        [self SendCloseDoor];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [_sensor disconnectDevice:_sensor.activePeripheral];
}

- (void)scanDeviceCallBack:(CBPeripheral *)peripheral RSSI:(int)level {
    
}

- (void)scanDeviceEndCallBack {
    
}

- (void)didDiscoverServicesCallBack:(DHBleResultType)result {
    NSLog(@"result: %ld", result);
    if(result == DHBLE_RESULT_OK){
//        tvRecv.text= [tvRecv.text stringByAppendingString:@"Service OK"];
        NSLog(@"Service OK");
    }
    else{
//        tvRecv.text= [tvRecv.text stringByAppendingString:@"Service NG"];
        NSLog(@"Service NG");
    }
}

#define TWOHI_UINT32(a) (((a) >> 24) & 0xFF)
#define TWOLO_UINT32(a) (((a) >> 16) & 0xFF)
#define ONEHI_UINT32(a) (((a) >> 8) & 0xFF)
#define ONELO_UINT32(a) ((a) & 0xFF)

- (void)didDiscoverCharacteristicsCallBack:(DHBleResultType)result {
    NSLog(@"%@", _sensor.activePeripheral);
    if(result == DHBLE_RESULT_OK){
        NSString *value = [NSString stringWithFormat:@"Charact OK"];
        NSLog(@"Charact OK!");
//        tvRecv.text= [tvRecv.text stringByAppendingString:value];
        if(_sensor.activePeripheral.state == CBPeripheralStateConnected){
            /*[sensor openDeviceUserId:sensor.activePeripheral deviceNum:[sensor getDeviceId:self.sensor.activePeripheral] devicePassword:0x12345678 userId:0x00112233];*/
            /*[sensor openDevice:sensor.activePeripheral deviceNum:[sensor getDeviceId:self.sensor.activePeripheral] devicePassword:[self devicePassword]];*/
            UInt32 deviceId = [_sensor getDeviceId:self.sensor.activePeripheral];
            UInt32 devicePassword = [self devicePassword];
            Byte signatureBuf[18];
            signatureBuf[0] = TWOHI_UINT32(deviceId);
            signatureBuf[1] = TWOLO_UINT32(deviceId);
            signatureBuf[2] = ONEHI_UINT32(deviceId);
            signatureBuf[3] = ONELO_UINT32(deviceId);
            signatureBuf[4] = TWOHI_UINT32(devicePassword);
            signatureBuf[5] = TWOLO_UINT32(devicePassword);
            signatureBuf[6] = ONEHI_UINT32(devicePassword);
            signatureBuf[7] = ONELO_UINT32(devicePassword);
            signatureBuf[8] = 0xf5;
            signatureBuf[9] = 0xff;
            signatureBuf[10] = 0xff;
            signatureBuf[11] = 0xff;
            signatureBuf[12] = 0x00;
            signatureBuf[13] = 0x00;
            signatureBuf[14] = 0x00;
            signatureBuf[15] = 0x00;
            
            // [sensor getSignature:deviceId devicePassword:devicePassword signature:signatureBuf];
            /*[sensor openDeviceExt:sensor.activePeripheral userId:0x11223344 signature:signatureBuf sigLength:16];*/
        }
        else{
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else{
//        tvRecv.text= [tvRecv.text stringByAppendingString:@"Charact NG"];
    }
}

- (void)SendReadDeviceInfo:(id)sender {
    [_sensor readDeviceInfo:_sensor.activePeripheral devicePassword:_devicePassword];
}

- (void)readDeviceInfoCallBack:(DHBleResultType)result device:(UInt32)deviceId configStatus:(Byte)status{
    if(result != DHBLE_ER_OK)
    {
//        tvRecv.text= [tvRecv.text stringByAppendingString:@"Read DeviceInfo Error"];
    }
    else{
        NSString *value = [NSString stringWithFormat:@"Id:%d", deviceId];
//        tvRecv.text= [tvRecv.text stringByAppendingString:value];
        [self setDeviceId:deviceId];
    }
}

- (void)SendConfigDevice:(id)sender {
    [_sensor configDevice:_sensor.activePeripheral deviceNum:[_sensor getDeviceId:_sensor.activePeripheral] devicePassword:[self devicePassword] advInt:1000 connectInt:1000 txPower:TX_POWER_4_DBM activeTime:5000];
}

- (void)SendSetPassword:(id)sender {
    [_sensor modifyPassword:_sensor.activePeripheral deviceNum:[_sensor getDeviceId:_sensor.activePeripheral] oldPassword:[self devicePassword] newPassword:87654321];
}

- (void)modifyPasswordCallBack:(DHBleResultType)result {
    if(result == DHBLE_ER_OK)
    {
//        tvRecv.text= [tvRecv.text stringByAppendingString:@"Modify password success"];
    }
    else{
//        tvRecv.text= [tvRecv.text stringByAppendingString:@"Modify password error"];
    }
}

- (void)SendOpenDoor {
    // [self setDevicePassword:0x12345678];
    /*[sensor oneKeyOpenDevice:peripheral deviceNum:[sensor getDeviceId:sensor.activePeripheral] devicePassword:0x12345678 openType:TYPE_OPEN_LOCK];*/
#if 1
    if(_sensor.activePeripheral.state == CBPeripheralStateConnected){
        [_sensor openDevice:_sensor.activePeripheral deviceNum:[_sensor getDeviceId:_sensor.activePeripheral] devicePassword:0x12345678];
        NSLog(@"sensor.activePeripheral: %@, devicePassword: %u", _sensor.activePeripheral, (unsigned int)_devicePassword);
        /*[sensor openDeviceUserId:sensor.activePeripheral deviceNum:[sensor getDeviceId:sensor.activePeripheral] devicePassword:0x12345678 userId:0x11223344];*/
    }
    else{
        //[self.navigationController popViewControllerAnimated:YES];
        _sensor.activePeripheral = _peripheral;
        [self.sensor connectDevice:_sensor.activePeripheral];
    }
#endif

}

- (void)SendCloseDoor {
    //[self setDevicePassword:0x87654321];
    [_sensor closeDevice:_sensor.activePeripheral deviceNum:[_sensor getDeviceId:_sensor.activePeripheral] devicePassword:[self devicePassword]];
    
}

- (void)openCloseDeviceCallBack:(DHBleResultType)result deviceBattery:(Byte)battery {
    NSLog(@"unlock back result: %ld", (long)result);
    if(result == DHBLE_ER_OK)
    {
//        tvRecv.text= [tvRecv.text stringByAppendingString:@"success"];
        NSLog(@"unlock Success!");
    }
    else{
        NSLog(@"unlock fail!");
        _sensor.activePeripheral = _peripheral;
        [self.sensor connectDevice:_sensor.activePeripheral];
        //[self.navigationController popViewControllerAnimated:YES];
    }

}

- (void)SendConnectDevice:(id)sender {
    if(_sensor.activePeripheral.state != CBPeripheralStateConnected){
        _sensor.activePeripheral = _peripheral;
        [self.sensor connectDevice:_sensor.activePeripheral];
    }
}

- (void)connectDeviceCallBack:(DHBleResultType)result {
    NSLog(@"%@", _sensor.activePeripheral);
//    CFStringRef s = CFUUIDCreateString(kCFAllocatorDefault, (__bridge CFUUIDRef )_sensor.activePeripheral.identifier);
//    BLKAppUUID.text = (__bridge NSString*)s;
//    tvRecv.text = @"OK+CONN";
}

- (void)disconnectDeviceCallBack {
    NSLog(@"OK+LOST");
}

- (void)updateBluetoothStateCallBack:(UInt8)state {
    switch (state) {
        case 0:
            /* 初始化中，请稍后…… */
            break;
        case 1:
            /* 设备不支持状态，过会请重试…… */
            break;
        case 2:
            /* 设备未授权状态，过会请重试…… */
            break;
        case 3:
            /* 设备未授权状态，过会请重试…… */
            break;
        case 4:
            /* 尚未打开蓝牙，请在设置中打开…… */
            break;
        case 5:
            /* 蓝牙已经成功开启，稍后…… */
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
