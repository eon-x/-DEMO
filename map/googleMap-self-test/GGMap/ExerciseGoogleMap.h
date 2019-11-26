//
//  ExerciseGoogleMap.h
//  VeryfitP
//
//  Created by xiongze on 2017/12/25.
//  Copyright © 2017年 aiju_huangjing1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

#define WeakSelf __weak typeof(self) weakSelf = self;

@interface ExerciseGoogleMap : UIView

-(instancetype)initWithFrame:(CGRect)frame position:(CLLocationCoordinate2D)position;

@property (strong, nonatomic) GMSMapView *mapView;
@property (nonatomic) CLLocationCoordinate2D myLocationWithGD;
@property (nonatomic, assign) BOOL isShowSelf; //是否显示自己定位点
@property (nonatomic, assign) BOOL isSport; //运动中：YES    预览轨迹：NO
@property (nonatomic, assign) BOOL isShowMarker; //是否显示标记
@property (nonatomic,strong)NSMutableArray *trackArray; //轨迹点数组

//定位成功返回
@property (copy,nonatomic) void (^getCLLocation)(CLLocation *,double);

//两个点之间距离大于等于10米返回
@property (copy,nonatomic) void (^getCLLocationWithDistance)(CLLocation *,double);

//开始持续定位
-(void)startUpdataLocation;

//结束持续定位
-(void)stopUpdataLocation;

//定位到自己
- (void)clickMyLocationBtn;

//显示/隐藏标记
- (void)clickShowDistanceBtn:(BOOL)isShow;

//居中显示轨迹
- (void)ClickShowCourseBtn;

//画轨迹线
- (void)trackLineWithLocationArray:(NSArray *)array;

//设置线颜色
- (void)gradientSpans;

//添加一个图片标记
- (void)addMarkerWithImageStr:(NSString *)imageStr position:(CLLocationCoordinate2D)position title:(NSString *)title;

//添加一个文字标记
- (GMSMarker *)addMarkerWithStr:(NSString *)str position:(CLLocationCoordinate2D)position title:(NSString *)title;

//截取轨迹图
- (UIImage *)getRunrouteImage;

@end
