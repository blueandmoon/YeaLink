//
//  UserLocation.m
//  YeaLink
//
//  Created by 李根 on 16/5/16.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "UserLocation.h"

@interface UserLocation ()<CLLocationManagerDelegate>
@property(nonatomic, strong)CLLocationManager *locationManager;

@end

@implementation UserLocation

+ (instancetype)shareGpsManager {
    static UserLocation *location;
    if (location == nil) {
        location = [[UserLocation alloc] init];
    }
    
    return location;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self createView];
    }
    return self;
}

+ (void)addToSuperViewWith:(UIView *)view {
    UserLocation *userloc = [[UserLocation alloc] init];
    [view addSubview:userloc];
}

- (void)createView {
    //  定位管理器
    _locationManager = [[CLLocationManager alloc] init];
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"定位服务当前可能尚未打开，请设置打开！");
        return;
    }
    
    //  设置代理
    _locationManager.delegate = self;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //    locationManager.distanceFilter = kCLDistanceFilterNone;
    //  启动定位
    [_locationManager startUpdatingLocation];
    
    __weak UserLocation *blockSelf = self;
//    self.realtimePosition = ^() {   //  启动定位的接口
//        [blockSelf.locationManager startUpdatingLocation];
//    };
    [blockSelf.locationManager startUpdatingLocation];
}


#pragma mark    - CoreLocation Delegate //  定位
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusNotDetermined: {
            NSLog(@"未授权");
            if ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                [_locationManager requestWhenInUseAuthorization];
            }
        } break;
        case kCLAuthorizationStatusAuthorizedAlways: {
            NSLog(@"总是授权");
        } break;
        case kCLAuthorizationStatusAuthorizedWhenInUse: {
            NSLog(@"使用时");
        }
        default:
            break;
    }
    
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *currentLocation = [locations lastObject]; // 最后一个值为最新位置
    //    NSLog(@"当前经纬度%f, %f", currentLocation.coordinate.latitude, currentLocation.coordinate.longitude);
    //  包存
    [UserInformation userinforSingleton].latitude = currentLocation.coordinate.latitude;
    [UserInformation userinforSingleton].longitude = currentLocation.coordinate.longitude;
    
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    // 根据经纬度反向得出位置城市信息
    [geoCoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        NSString *currentCity;  //
        if (placemarks.count > 0) {
            CLPlacemark *placeMark = placemarks[0];
            currentCity = placeMark.locality;
            // ? placeMark.locality : placeMark.administrativeArea;
            if (!currentCity) {
//                currentCity = @"无法定位当前城市";
            }
//            //  将城市保存到本地
            NSLog(@"%@", currentCity);
//            [[NSUserDefaults standardUserDefaults] setObject:currentCity forKey:@"currentCity"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self saveCurrentCityWith:currentCity];
        } else if (error == nil && placemarks.count == 0) {
            NSLog(@"No location and error returned");
        } else if (error) {
            NSLog(@"Location error: %@", error);
        }
    }];
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [manager stopUpdatingLocation];
}

- (void)saveCurrentCityWith:(NSString *)currentCity {
    [UserInformation userinforSingleton].currentCity = currentCity;
//    NSLog(@"[UserInformation userinforSingleton].currentCity%@", [UserInformation userinforSingleton].currentCity);
}


- (void)UpdatingLocation {
    //  启动定位
    [_locationManager startUpdatingLocation];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
