//
//  LocationManager.h
//  IDOFoundation
//
//  Created by xiongze on 2018/9/12.
//  Copyright © 2018年 hedongyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

//高德KEY
#define MAMapApiKey @"ba9ccd98bd6177f7af71e9e8b1ebf116"

@interface LocationManager : NSObject

+ (instancetype)sharedInstance;


/**
 获取定位权限是否可用

 @return 返回定位权限是否可用
 */
+ (BOOL)locationServicesEnabled;

@property (nonatomic,copy) NSString *cityCode; //城市编码
@property (nonatomic,copy) NSDictionary *countryDic;
@property (nonatomic,copy) NSString *province;
@property (nonatomic,copy) NSString *latAndLong;

/**
单次定位

 @param block 返回定位信息
 */
- (void)locateAndCallBack:(void(^)(CLLocation *location))block;

/**
 开始连续定位
 */
- (void)startUpdatingLocation;

@property (nonatomic, copy) void (^locationBlock)(CLLocation * location);

/**
 结束连续定位
 */
- (void)endUpdatingLocation;



@end

/*
 文档
 https://lbs.amap.com/api/ios-location-sdk/guide/create-project/manual-configuration
 */
