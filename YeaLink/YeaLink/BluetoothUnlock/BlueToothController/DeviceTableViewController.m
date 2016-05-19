//
//  DeviceTableViewController.m
//  YeaLink
//
//  Created by 李根 on 16/5/17.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "DeviceTableViewController.h"
#import "BlueToothUnlockController.h"

@interface DeviceTableViewController ()

@end

@implementation DeviceTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    [self getValue];
}

- (void)getValue {
    [self settingNavigationbar];
    
    _sensor = [[DHBle alloc] init];
    [_sensor bleInit];
    _sensor.delegate = self;
    
    _peripheralViewControllerArray = [NSMutableArray array];
    
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
    
}

- (void)settingNavigationbar {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Scan" style:UIBarButtonItemStylePlain target:self action:@selector(scanAppDevices:)];
    
    QJLBaseLabel *label = [QJLBaseLabel LabelWithFrame:CGRectMake(0, 0, 50 * WID, HEI * 30) text:@"已扫描到的设备" titleColor:[UIColor blackColor] textAlignment:NSTextAlignmentCenter font:[UIFont systemFontOfSize:19]];
    self.navigationItem.titleView = label;
}

- (void)createTableView {
    _btAppTableView = [[QJLBaseTableView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT) style:UITableViewStylePlain];
    [self.view addSubview:_btAppTableView];
    _btAppTableView.rowHeight = 50 * HEI;
    _btAppTableView.delegate = self;
    _btAppTableView.dataSource = self;
    
}

#pragma mark    - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.peripheralViewControllerArray count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger row = [indexPath row];
    BlueToothUnlockController *btController = [_peripheralViewControllerArray objectAtIndex:row];
    
    if (_sensor.activePeripheral && _sensor.activePeripheral != btController.peripheral) {
        [_sensor disconnectDevice:_sensor.activePeripheral];
    }
    
    _sensor.activePeripheral = btController.peripheral;
    [_sensor connectDevice:_sensor.activePeripheral];
    
    self.navigationItem.rightBarButtonItem.title = @"Scan";
    [self.navigationController pushViewController:btController animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellId = @"peripheral";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    
    //  Configure the cell
    NSUInteger row = indexPath.row;
    BlueToothUnlockController *controller = [_peripheralViewControllerArray objectAtIndex:row];
    CBPeripheral *peripheral = [controller peripheral];
    
#pragma mark    - 这方法有问题, 不注释就很容易崩溃
    //    cell.textLabel.text = [sensor getDeviceName:peripheral];
    
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    return cell;
}

#pragma mark    - BLKAppSensorDelegate
-(void)sensorReady
{
    //TODO: it seems useless right now.
}

- (void)scanDeviceCallBack:(CBPeripheral *)peripheral RSSI:(int)level {
    BlueToothUnlockController *controller = [[BlueToothUnlockController alloc] init];
    controller.peripheral = peripheral;
    controller.sensor = _sensor;
    [_peripheralViewControllerArray addObject:controller];
    [_btAppTableView reloadData];
}

- (void)scanDeviceEndCallBack {
    
}

- (void)connectDeviceCallBack:(DHBleResultType)result {
    NSLog(@"%@", _sensor.activePeripheral);
}

- (void)didDiscoverServicesCallBack:(DHBleResultType)result {
    
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

- (void)scanAppDevices:(id)sender {
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
    [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(scanTimer:) userInfo:nil repeats:NO];
    
    [_sensor scanDevice:5];
    
}

- (void)scanTimer:(NSTimer *)timer {
    self.navigationItem.rightBarButtonItem.title = @"Scan";
}

- (void)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void) didDiscoverCharacteristicsCallBack:(DHBleResultType)result{
    
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
