//
//  DeviceTableViewController.m
//  YeaLink
//
//  Created by 李根 on 16/5/17.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "DeviceTableViewController.h"
#import "BlueToothUnlockController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "QuartzCore/QuartzCore.h"
#import "DeviceView.h"
#import "HeaderView.h"  //  分区头视图
#import "BlueToothCell.h"

@interface DeviceTableViewController ()

@end

@implementation DeviceTableViewController
{
    BOOL isScaning;
    NSTimer *_delayTimer;
    NSTimer *_timer;
    HeaderView *_headerView;
    DeviceView *_deviceView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
//    [self gonext];
    
}

//- (void)gonext {
//    [self scanAppDevices];
//    
//}

- (void)viewWillDisappear:(BOOL)animated {
    [_timer invalidate];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    _peripheralViewControllerArray = [NSMutableArray array];

    //  设定密码
    self.devicePassword = 0x12345678;
    
    [self getValue];
}

- (void)getValue {
    [self settingNavigationbar];
    
    _deviceView = [[DeviceView alloc] init];
    [self.view addSubview:_deviceView];
    [_deviceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.height.mas_equalTo(205 * HEI);
        make.width.equalTo(self.view);
        make.centerX.equalTo(self.view);
    }];
    
    
    
    
    _sensor = [[DHBle alloc] init];
    [_sensor bleInit];
    _sensor.delegate = self;
    
    
    UInt8 bytes[24];
    
    for(int i=0; i<24; i++){
        bytes[i] = i;
    }
    
    UInt8 lockType, activeYear, activeMonth, activeDay;
    UInt16 keyId, activeNumb;
    UInt32 lockId;
    
    lockId = 4000;
    lockType = 0;
    activeYear = 15;
    activeMonth = 7;
    activeDay = 30;
    keyId = 2000;
    activeNumb = 5;
 
    [self createTableView];
    
//    _timer =  [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(gonext) userInfo:nil repeats:NO];
//    [_timer fire];
    
    
    
}

- (void)settingNavigationbar {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Scan" style:UIBarButtonItemStylePlain target:self action:@selector(scanAppDevices)];
    self.navigationController.navigationBar.barTintColor = CUSTOMBLUE;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    QJLBaseLabel *label = [QJLBaseLabel LabelWithFrame:CGRectMake(0, 0, 50 * WID, HEI * 30) text:@"蓝牙开门" titleColor:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter font:[UIFont systemFontOfSize:19]];
    self.navigationItem.titleView = label;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    
}

- (void)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createTableView {
    _btAppTableView = [[QJLBaseTableView alloc] initWithFrame:CGRectMake(0, 205 * HEI, WIDTH, HEIGHT - 205 * HEI) style:UITableViewStylePlain];
    [self.view addSubview:_btAppTableView];
    _btAppTableView.rowHeight = 40 * HEI;
    _btAppTableView.delegate = self;
    _btAppTableView.dataSource = self;
    _btAppTableView.tableFooterView = [[UIView alloc] init];
    _btAppTableView.bounces = NO;
}

#pragma mark    - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.peripheralViewControllerArray count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = [indexPath row];
//    BlueToothUnlockController *btController = [_peripheralViewControllerArray objectAtIndex:row];
    
    CBPeripheral *peripheral = _peripheralViewControllerArray[indexPath.row];
    if (_sensor.activePeripheral && _sensor.activePeripheral != peripheral) {
        [_sensor disconnectDevice:_sensor.activePeripheral];
    }
    
    _sensor.activePeripheral = peripheral;
    [_sensor connectDevice:_sensor.activePeripheral];
    
    if(_sensor.activePeripheral.state != CBPeripheralStateConnected){
        _sensor.activePeripheral = _peripheral;
        [self.sensor connectDevice:_sensor.activePeripheral];
    }
    //  开锁按钮
    [_deviceView.button addTarget:self action:@selector(openDoor) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem.title = @"Scan";
    
//    [self openDoor];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"peripheral";
    BlueToothCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[BlueToothCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
    }
    
    //  Configure the cell
//    NSUInteger row = indexPath.row;
//    BlueToothUnlockController *controller = [_peripheralViewControllerArray objectAtIndex:row];
//    CBPeripheral *peripheral = [controller peripheral];
    CBPeripheral *peripheral = self.peripheral;
    cell.titleLabel.text = [_sensor getDeviceName:peripheral];
    
//    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    _headerView = [[HeaderView alloc] init];
//    [_headerView.button addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpOutside];
    
    _headerView = [[HeaderView alloc] init];
    [_headerView.button addTarget:self action:@selector(scanAppDevices) forControlEvents:UIControlEventTouchUpInside];
    return _headerView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40 * HEI;
}



#pragma mark    - 搬迁过来的
- (void)openDoor {
//    NSLog(@"%@", self.navigationItem.rightBarButtonItem.title);
    if (isScaning == 0) {
        if(_sensor.activePeripheral.state != CBPeripheralStateConnected){
            _sensor.activePeripheral = _peripheral;
            [self.sensor connectDevice:_sensor.activePeripheral];
        } else {
            [self SendCloseDoor];
        }        
    }
}

//  发现设备
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
//            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    else{
        //        tvRecv.text= [tvRecv.text stringByAppendingString:@"Charact NG"];
    }
}

- (void)SendOpenDoor {
    // [self setDevicePassword:0x12345678];
    /*[sensor oneKeyOpenDevice:peripheral deviceNum:[sensor getDeviceId:sensor.activePeripheral] devicePassword:0x12345678 openType:TYPE_OPEN_LOCK];*/
#if 1
    if(_sensor.activePeripheral.state == CBPeripheralStateConnected){
        [_sensor openDevice:_sensor.activePeripheral deviceNum:[_sensor getDeviceId:_sensor.activePeripheral] devicePassword:0x12345678];
//        NSLog(@"sensor.activePeripheral: %@, devicePassword: %u", _sensor.activePeripheral, (unsigned int)_devicePassword);
        /*[sensor openDeviceUserId:sensor.activePeripheral deviceNum:[sensor getDeviceId:sensor.activePeripheral] devicePassword:0x12345678 userId:0x11223344];*/
    }
    else{
        //[self.navigationController popViewControllerAnimated:YES];
        _sensor.activePeripheral = _peripheral;
        [self.sensor connectDevice:_sensor.activePeripheral];
    }
#endif
    
}

- (void)openCloseDeviceCallBack:(DHBleResultType)result deviceBattery:(Byte)battery {
    NSLog(@"unlock back result: %ld", (long)result);
    if(result == DHBLE_ER_OK)
    {
        //        tvRecv.text= [tvRecv.text stringByAppendingString:@"success"];
        NSLog(@"unlock Success!");
        //  成功就切换图片
        [_deviceView.button setImage:[UIImage imageNamed:@"unlock_success"] forState:UIControlStateNormal];
    }
    else{
        NSLog(@"unlock fail!");
        _sensor.activePeripheral = _peripheral;
        [self.sensor connectDevice:_sensor.activePeripheral];
        //[self.navigationController popViewControllerAnimated:YES];
        
        [_deviceView.button setImage:[UIImage imageNamed:@"unlock_fail"] forState:UIControlStateNormal];
    }
    _delayTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(exchangeImage:) userInfo:nil repeats:NO];
    
}

- (void)exchangeImage:(id)sender {
    [_deviceView.button setImage:[UIImage imageNamed:@"blueToothImage"] forState:UIControlStateNormal];
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
    if(_sensor.activePeripheral.state != CBPeripheralStateConnected){
        _sensor.activePeripheral = _peripheral;
        [self.sensor connectDevice:_sensor.activePeripheral];
    }
    NSLog(@"OK+LOST");
}

- (void)SendCloseDoor {
    //[self setDevicePassword:0x87654321];
    [_sensor closeDevice:_sensor.activePeripheral deviceNum:[_sensor getDeviceId:_sensor.activePeripheral] devicePassword:[self devicePassword]];
    
}

#pragma mark    - BLKAppSensorDelegate
-(void)sensorReady
{
    //TODO: it seems useless right now.
}

- (void)scanDeviceCallBack:(CBPeripheral *)peripheral RSSI:(int)level {
//    BlueToothUnlockController *controller = [[BlueToothUnlockController alloc] init];
//    controller.peripheral = peripheral;
//    controller.sensor = _sensor;
    
    self.peripheral = peripheral;
    [_peripheralViewControllerArray addObject:self.peripheral];
    [_btAppTableView reloadData];
}

- (void)scanDeviceEndCallBack {
    
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

- (void)scanAppDevices{
    if ([_sensor activePeripheral]) {
        if (_sensor.activePeripheral.state == CBPeripheralStateConnected) {
            [_sensor.manager cancelPeripheralConnection:_sensor.activePeripheral];
            _sensor.activePeripheral = nil;
        }
    }
    
    if ([_sensor peripherals]) {
        _sensor.peripherals = nil;
        [_peripheralViewControllerArray removeAllObjects];
        [_btAppTableView reloadData];
    }
    
    _sensor.delegate = self;
    NSLog(@"now we are searching device...\n");
    self.navigationItem.rightBarButtonItem.title = @"Scaning";
    isScaning = 1;
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(scanTimer:) userInfo:nil repeats:NO];
    
    [_sensor scanDevice:5];
    
}

- (void)scanTimer:(NSTimer *)timer {
    self.navigationItem.rightBarButtonItem.title = @"Scan";
    isScaning = 0;
    [_btAppTableView reloadData];
//    [self gonext];
}

- (void)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
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
