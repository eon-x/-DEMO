//
//  ExerciseGoogleMap.m
//  VeryfitP
//
//  Created by xiongze on 2017/12/25.
//  Copyright © 2017年 aiju_huangjing1. All rights reserved.
//

#import "ExerciseGoogleMap.h"
#import "LocationManager.h"

@interface ExerciseGoogleMap ()

@property (nonatomic,strong)GMSPolyline *polyline;          //轨迹线
@property (nonatomic,assign)float myZoon;                   //默认缩放大小
@property (nonatomic,strong)NSMutableArray *markers;        //标记数组
@property (nonatomic,strong)GMSMarker *myMarker;            //自定义蓝点
@property (nonatomic,strong)GMSCircle *googleCircle;        //自定义蓝点 周围阴影
@property (nonatomic,assign)double unitDouble;              //英里  or  公里

@end

@implementation ExerciseGoogleMap

#pragma mark ----- vc lift cycle 生命周期

-(instancetype)initWithFrame:(CGRect)frame position:(CLLocationCoordinate2D)position{
    if (self = [super initWithFrame:frame]) {
        
        _isShowSelf = NO;
        _isSport = NO;
        _trackArray = [NSMutableArray new];
        _markers = [NSMutableArray new];
        _myZoon = 18.0f;
        _unitDouble = 1000;
        
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:position.latitude
                                                                longitude:position.longitude
                                                                     zoom:_myZoon-2];
        CGRect subFrame = self.bounds;
        _mapView = [GMSMapView mapWithFrame:subFrame camera:camera];
        [self addSubview: _mapView];
        
    }
    return self;
}

#pragma mark ----- get and set 属性的set和get方法

- (void)setMyLocationWithGD:(CLLocationCoordinate2D)myLocationWithGD{
    _myLocationWithGD = myLocationWithGD;
    
    if (_isShowSelf) {
        self.myMarker.position = myLocationWithGD;
        self.googleCircle.position = myLocationWithGD;
    }
}

//自己 蓝点
- (GMSMarker *)myMarker{
    if (!_myMarker) {
        _myMarker = [GMSMarker markerWithPosition:_myLocationWithGD];
        UIView *bgView = [[UIView alloc ]initWithFrame:CGRectMake(0, 0, 20, 20)];
        bgView.backgroundColor = [UIColor blueColor];
        bgView.layer.cornerRadius = 10;
        bgView.layer.borderColor = [UIColor whiteColor].CGColor;
        bgView.layer.borderWidth = 3.0;
        _myMarker.iconView = bgView;
        _myMarker.groundAnchor = CGPointMake(0.5, 0.5);
        _myMarker.map = _mapView;
    }
    return _myMarker;
}

//自己 外圈
- (GMSCircle *)googleCircle{
    if (!_googleCircle) {
        CLLocationDistance distance=100;
        _googleCircle = [GMSCircle circleWithPosition:_myLocationWithGD radius:distance];
        _googleCircle.fillColor = [[UIColor colorWithRed:0.76 green:0.76 blue:0.76 alpha:0.3] colorWithAlphaComponent:0.5];
        _googleCircle.strokeColor = [[UIColor colorWithRed:0.76 green:0.76 blue:0.76 alpha:0.9] colorWithAlphaComponent:0.5];
        _googleCircle.strokeWidth = 1.0;
        _googleCircle.map = _mapView;
    }
    return _googleCircle;
}

#pragma mark ----- event Response 事件响应(手势 通知)
//点击回到自己
- (void)clickMyLocationBtn{
    
    _mapView.layer.cameraLatitude = self.myLocationWithGD.latitude;
    _mapView.layer.cameraLongitude = self.myLocationWithGD.longitude;
    _mapView.layer.cameraBearing = 0.0;
    
    // Access the GMSMapLayer directly to modify the following properties with a
    // specified timing function and duration.
    
    CAMediaTimingFunction *curve =
    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    CABasicAnimation *animation;
    
    animation = [CABasicAnimation animationWithKeyPath:kGMSLayerCameraLatitudeKey];
    animation.duration = 2.0f;
    animation.timingFunction = curve;
    animation.toValue = @(self.myLocationWithGD.latitude);
    [_mapView.layer addAnimation:animation forKey:kGMSLayerCameraLatitudeKey];
    
    animation = [CABasicAnimation animationWithKeyPath:kGMSLayerCameraLongitudeKey];
    animation.duration = 2.0f;
    animation.timingFunction = curve;
    animation.toValue = @(self.myLocationWithGD.longitude);
    [_mapView.layer addAnimation:animation forKey:kGMSLayerCameraLongitudeKey];
    
    animation = [CABasicAnimation animationWithKeyPath:kGMSLayerCameraBearingKey];
    animation.duration = 2.0f;
    animation.timingFunction = curve;
    animation.toValue = @0.0;
    [_mapView.layer addAnimation:animation forKey:kGMSLayerCameraBearingKey];
    
    // Fly out to the minimum zoom and then zoom back to the current zoom!
    CGFloat zoom = _mapView.camera.zoom;
    NSArray *keyValues = @[@(zoom), @(15.0), @(zoom)];
    CAKeyframeAnimation *keyFrameAnimation =
    [CAKeyframeAnimation animationWithKeyPath:kGMSLayerCameraZoomLevelKey];
    keyFrameAnimation.duration = 2.0f;
    keyFrameAnimation.values = keyValues;
    [_mapView.layer addAnimation:keyFrameAnimation forKey:kGMSLayerCameraZoomLevelKey];
}

//显示/隐藏 标记
- (void)clickShowDistanceBtn:(BOOL)isShow{
    _isShowMarker = isShow;
    for (GMSMarker *aMarker in _markers) {
        aMarker.map = _isShowMarker ? _mapView : nil;
    }
}

//使轨迹显示在地图可视区域
- (void)ClickShowCourseBtn{
    NSArray *firstPoint = _trackArray[0];
    CLLocationCoordinate2D firstPos = CLLocationCoordinate2DMake([firstPoint[1] doubleValue], [firstPoint[2] doubleValue]);
    GMSCoordinateBounds *bounds =
    [[GMSCoordinateBounds alloc] initWithCoordinate:firstPos coordinate:firstPos];
    for (NSArray *aPoint in _trackArray) {
        bounds = [bounds includingCoordinate:CLLocationCoordinate2DMake([aPoint[1] doubleValue], [aPoint[2] doubleValue])];
    }
    
    CGRect selfBound = _mapView.bounds;
    float leftAndRight = 50;
    float topAndBottom = (selfBound.size.height - selfBound.size.width)/2 + leftAndRight;
    
    GMSCameraUpdate *update = [GMSCameraUpdate fitBounds:bounds withEdgeInsets:UIEdgeInsetsMake(topAndBottom, leftAndRight, topAndBottom, leftAndRight)];
    [_mapView moveCamera:update];
}

//开始持续定位
-(void)startUpdataLocation{
    WeakSelf;
    [[LocationManager sharedInstance] startUpdatingLocation];
    [LocationManager sharedInstance].locationBlock = ^(CLLocation *location) {
        if (location.horizontalAccuracy >= 0) {
            if (_trackArray.count == 0) {
                [weakSelf.trackArray addObject:@[@0,@(location.coordinate.latitude),@(location.coordinate.longitude)]];
                if (weakSelf.getCLLocation) {
                    weakSelf.getCLLocation(location,0);
                }
                //第一个点不需要判断距离
                if (weakSelf.getCLLocationWithDistance) {
                    weakSelf.getCLLocationWithDistance(location,0);
                }
            }else{
                NSArray *lastPoint = weakSelf.trackArray.lastObject;
                CLLocation *l2 = [[CLLocation alloc] initWithLatitude:[lastPoint[1] doubleValue] longitude:[lastPoint[2] doubleValue]];
                double distance = [location distanceFromLocation:l2];
                if (distance >= 3) {
                    [weakSelf addNewPointAndUpdateUIWithLocation:location distance:distance];
                }
            }
            
            self.myLocationWithGD = location.coordinate;
        }
    };
}

//结束持续定位
-(void)stopUpdataLocation{
    [[LocationManager sharedInstance] endUpdatingLocation];
}

#pragma mark ----- custom action for UI 界面处理有关

//添加画线路径
- (void)trackLineWithLocationArray:(NSArray *)array {
    if (array.count == 0) {
        return;
    }
    
    [_mapView clear];
    _markers = [NSMutableArray new];
    
    _trackArray = [[NSMutableArray alloc] initWithArray:array];
    if (!_isSport) {
        [self ClickShowCourseBtn];
    }
    
    NSArray *firstPoint = array.firstObject;
    CLLocationCoordinate2D startPoint = CLLocationCoordinate2DMake([firstPoint[1] doubleValue], [firstPoint[2] doubleValue]);
    [self addMarkerWithStr:@"GO" position:startPoint title:@""];
    
    double annotDistance = 0;
    double totalDistance = 0;
    
    GMSMutablePath *path = [GMSMutablePath path];
    
    for (NSArray *aPoint in array) {
        CLLocationDegrees lat = [aPoint[1] doubleValue];
        CLLocationDegrees lon = [aPoint[2] doubleValue];
        [path addLatitude:lat longitude:lon];
        
        if ([aPoint isEqualToArray:array.lastObject] && !_isSport){
            lat = lat == startPoint.latitude ? lat + 0.000001 : lat;
            lon = lon == startPoint.longitude ? lon + 0.000001 : lon;//如果两个点经纬度完全一样，会闪来闪去
            [self addMarkerWithStr:@"END" position:CLLocationCoordinate2DMake(lat, lon) title:@""];;
        }
        
        if (![aPoint isEqualToArray:array.firstObject] && ![aPoint isEqualToArray:array.lastObject]) {
            CLLocation *l1 = [[CLLocation alloc]initWithLatitude:startPoint.latitude longitude:startPoint.longitude];
            CLLocation *l2 = [[CLLocation alloc]initWithLatitude:lat longitude:lon];
            annotDistance += [l1 distanceFromLocation:l2];
            totalDistance += [l1 distanceFromLocation:l2];
            startPoint = CLLocationCoordinate2DMake(lat, lon);
            
            if (annotDistance >= _unitDouble) {
                GMSMarker *marker = [self addMarkerWithStr:[NSString stringWithFormat:@"%ld",[_markers count]+1]
                                                  position:l2.coordinate title:@""];
                [_markers addObject:marker];
                annotDistance = totalDistance - [_markers count]*_unitDouble;
            }
        }
    }
    
    _polyline = [GMSPolyline polylineWithPath:path];
    _polyline.strokeWidth = 3;
    _polyline.map = _mapView;
    
    [self gradientSpans];
}

//轨迹颜色数组
- (void)gradientSpans {
    NSMutableArray *colorSpans = [NSMutableArray array];
    UIColor *prevColor;
    for (NSArray *aPoint in _trackArray) {
        
        UIColor *toColor = [self getDrawStyleColorWithSpeed:[aPoint[0] doubleValue]];
        prevColor = prevColor == nil ? toColor : prevColor;
        
        GMSStrokeStyle *style = [GMSStrokeStyle gradientFromColor:prevColor toColor:toColor];
        [colorSpans addObject:[GMSStyleSpan spanWithStyle:style]];
        
        prevColor = toColor;
    }
    
    [_polyline setSpans:colorSpans];
}

//添加一个图片标记
- (void)addMarkerWithImageStr:(NSString *)imageStr position:(CLLocationCoordinate2D)position title:(NSString *)title{
    GMSMarker *marker = [GMSMarker markerWithPosition:position];
    marker.title = title;
    marker.icon = [UIImage imageNamed:imageStr];
    marker.map = _mapView;
}

//添加一个文字标记
- (GMSMarker *)addMarkerWithStr:(NSString *)str position:(CLLocationCoordinate2D)position title:(NSString *)title{
    GMSMarker *marker = [GMSMarker markerWithPosition:position];
    marker.title = title;
    marker.groundAnchor = CGPointMake(0.5, .5);
    
    UIView *labelBGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 24, 24)];
    labelBGView.backgroundColor = [UIColor greenColor];

    labelBGView.layer.borderColor = [UIColor whiteColor].CGColor;
    labelBGView.layer.borderWidth = 2.0;
    labelBGView.layer.cornerRadius = 12;
    labelBGView.clipsToBounds = YES;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 24, 24)];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = str ;
    CGSize size ;float tSize = 14;
    do {
        size = [label.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:tSize]}];
        tSize = tSize - 1;
    } while (size.width > 20);
    label.font = [UIFont systemFontOfSize:tSize];
    label.frame = CGRectMake(0, 0, size.width, size.height);
    [labelBGView addSubview:label];
    label.center = CGPointMake(12, 12);
    
    marker.iconView = labelBGView;
    marker.map = _mapView;
    
    return marker;
}

- (UIImage *)getRunrouteImage{
    return nil;
}

/**
 *  截取view中某个区域生成一张图片
 *
 *  @param view  view description
 *  @param scope 需要截取的view中的某个区域frame
 *
 *  @return image
 */
- (UIImage *)shotWithView:(UIView *)view scope:(CGRect)scope{
    CGImageRef imageRef = CGImageCreateWithImageInRect([self shotWithView:view].CGImage, scope);
    UIGraphicsBeginImageContext(scope.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0, 0, scope.size.width, scope.size.height);
    CGContextTranslateCTM(context, 0, rect.size.height);//下移
    CGContextScaleCTM(context, 1.0f, -1.0f);//上翻
    CGContextDrawImage(context, rect, imageRef);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRelease(imageRef);
//    CGContextRelease(context);//打开会内存泄漏
    return image;
}

/**
 *  截取view生成一张图片
 *
 *  @param view view description
 *
 *  @return image
 */
- (UIImage *)shotWithView:(UIView *)view{
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


#pragma mark ----- custom action for DATA 数据处理有关

//添加新的轨迹点 并更新轨迹
- (void)addNewPointAndUpdateUIWithLocation:(CLLocation *)location distance:(double)distance{
    [self.trackArray addObject:@[@(distance),@(location.coordinate.latitude),@(location.coordinate.longitude),location]];
    if (self.getCLLocationWithDistance) {
        self.getCLLocationWithDistance(location,distance);
    }
    
    [self trackLineWithLocationArray:self.trackArray];
}

//根据时间偏移量获取颜色
-(UIColor *)getDrawStyleColorWithSpeed:(double)speed{
    UIColor *drawStyleColor = [[UIColor alloc] init];
    if (speed >= 0 && speed <= 2) {
        drawStyleColor = [UIColor redColor];
        
    }else if (speed > 2 && speed <= 4){
        drawStyleColor = [UIColor orangeColor];
        
    }else if (speed > 4 && speed <= 6){
        drawStyleColor = [UIColor yellowColor];
        
    }else if (speed > 6 && speed <= 8){
        drawStyleColor = [UIColor greenColor];
        
    }else if (speed > 8 && speed <= 10){
        drawStyleColor = [UIColor blueColor];
    }else{
        drawStyleColor = [UIColor purpleColor];
    }
    return drawStyleColor;
}

#pragma mark ----- xxxxxx delegate 各种delegate回调




@end
