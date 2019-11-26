//
//  ExerciseGDMap.h
//  VeryfitP
//
//  Created by Jeff on 2017/12/20.
//  Copyright © 2017年 aiju_huangjing1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

#define WeakSelf __weak typeof(self) weakSelf = self;

@interface ExerciseGDMap : UIView

@property (nonatomic, assign) BOOL isSport;//运动中：YES    预览轨迹：NO
@property (nonatomic, assign) BOOL isSelectClick;//隐藏大头针按钮是否选中
//定位成功返回
@property (copy,nonatomic) void (^getCLLocation)(CLLocation *,double);

//两个点之间距离大于等于10米返回
@property (copy,nonatomic) void (^getCLLocationWithDistance)(CLLocation *,double);

//是否显示小圆点，初始化进入地图就显示
-(void)isShowUserLocation:(BOOL)isShow;

//开始持续定位
-(void)startUpdataLocation;

//结束持续定位
-(void)stopUpdataLocation;

//设置屏幕中心点
-(void)setScreenCenterWithCoordinate:(CLLocation *)location;

//根据所有数组动态获取屏幕中心点设置轨迹可见范围
- (void)setMapVisibleScopeWithAllLocationArray:(NSArray *)array;

//根据数组画轨迹
-(void)drawMapGradientLineWithLocationArray:(NSArray *)array;

//是否显示大头针
-(void)isShowAnnidation:(BOOL)isShow;

//获取轨迹路线截图
- (UIImage *)getRunrouteImage;


@end
