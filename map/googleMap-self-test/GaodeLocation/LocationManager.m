//
//  LocationManager.m
//  IDOFoundation
//
//  Created by xiongze on 2018/9/12.
//  Copyright © 2018年 hedongyang. All rights reserved.
//

#import "LocationManager.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

@interface LocationManager()<AMapLocationManagerDelegate>

@property(nonatomic,retain)AMapLocationManager *onceLocationManager;
@property(nonatomic,retain)AMapLocationManager *locationManager;

@end

@implementation LocationManager

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static LocationManager * myLocationManager;
    dispatch_once( &once, ^{
        myLocationManager = [[self alloc] init];
        [AMapServices sharedServices].apiKey = MAMapApiKey;
    } );
    return myLocationManager;
}

- (AMapLocationManager *)onceLocationManager{
    if (!_onceLocationManager) {
        _onceLocationManager = [[AMapLocationManager alloc] init];
        [_onceLocationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
        [_onceLocationManager setAllowsBackgroundLocationUpdates:YES];
        _onceLocationManager.locationTimeout = 2;
        _onceLocationManager.reGeocodeTimeout = 2;
    }
    return _onceLocationManager;
}

- (AMapLocationManager *)locationManager{
    if (!_locationManager) {
        _locationManager = [[AMapLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.distanceFilter = 3;
        _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        [_locationManager setPausesLocationUpdatesAutomatically:NO];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] > 9.0) {
            [_locationManager setAllowsBackgroundLocationUpdates:YES];
        }
    }
    return _locationManager;
}

- (void)locateAndCallBack:(void(^)(CLLocation *location))block{
 
    // 带逆地理（返回坐标和地址信息）。将下面代码中的 YES 改成 NO ，则不会返回地址信息。
    [self.onceLocationManager requestLocationWithReGeocode:NO completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        
        if (!error) {
            self.latAndLong = [NSString stringWithFormat:@"%f,%f",location.coordinate.longitude,location.coordinate.latitude];
        }
        
        if (block) {
            block(location);
        }
        
    }];
}

/**
 开始连续定位 
 */
- (void)startUpdatingLocation{
    [self.locationManager startUpdatingLocation];
}

/**
 结束连续定位
 */
- (void)endUpdatingLocation{
    [self.locationManager stopUpdatingLocation];
}

+ (BOOL)locationServicesEnabled {
    if (([CLLocationManager locationServicesEnabled]) && ([CLLocationManager authorizationStatus] >=3)) {
        return YES;
    } else {
        return NO;
    }
}
 
#pragma mark AMapLocationManagerDelegate

- (void)amapLocationManager:(AMapLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"定位错误：%@",error);
}

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location{
    NSLog(@"定位信息:{lat:%f; lon:%f; accuracy:%f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
    //信号过滤
    if (location.horizontalAccuracy > 0 && location.horizontalAccuracy <= 2000) {
//        if (location.horizontalAccuracy > 0 && location.horizontalAccuracy <= 65) {
        if (_locationBlock) {
            _locationBlock(location);
        }
    }
}

- (void)amapLocationManager:(AMapLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusNotDetermined || status == kCLAuthorizationStatusDenied) {

    }
}


@end

