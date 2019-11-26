//
//  ExerciseGDMap.m
//  VeryfitP
//
//  Created by Jeff on 2017/12/20.
//  Copyright © 2017年 aiju_huangjing1. All rights reserved.
//

#import "ExerciseGDMap.h"
#import "LocationManager.h"

@interface ExerciseGDMap()<MAMapViewDelegate>//,AMapLocationManagerDelegate>
{
    MAMultiPolyline *multiPolyline;
    MAMultiColoredPolylineRenderer *renderer;
    NSMutableArray *mutStrokeColorsArr;
    NSMutableArray *drawStyleArr;
    NSMutableArray *strokeColorsArr;
    NSMutableArray *annidationArray;
}
@property (nonatomic,strong)MAMapView *mapView;

@property (nonatomic,strong)MAPolyline *polyline;
@property (nonatomic,strong)NSDate *lastDate;
@property (nonatomic,strong)CLLocation *lastLocation;

@property (nonatomic,strong)NSMutableArray *locationArray;

@property (nonatomic,strong)NSMutableArray *trackArray;

@property (nonatomic,strong)UILabel *dateLabel;

@property (nonatomic,strong)CLLocation *markLocation;

@property (nonatomic,assign)double totalDistance;

@property (nonatomic,assign)double annotDistance;

@property (nonatomic,assign)BOOL isFollowUserLocation;

@property (nonatomic,assign)double unitDouble;              //英里  or  公里

@end

@implementation ExerciseGDMap

-(instancetype)initWithFrame:(CGRect)frame{
    if ([super initWithFrame:frame]) {
        
        _unitDouble = 1000;
        
        [self loadMapData];
        
//        [self configLocationManager];
        
        _trackArray = [NSMutableArray array];
        
        _locationArray = [NSMutableArray array];
        
        drawStyleArr = [NSMutableArray array];
        strokeColorsArr = [NSMutableArray array];
        mutStrokeColorsArr = [NSMutableArray array];
        annidationArray = [NSMutableArray array];
        _lastLocation = [[CLLocation alloc] init];
        _isFollowUserLocation = YES;
        _isSport = NO;
        _isSelectClick = YES;
    }
    return self;
}

-(void)buttonClick:(UIButton *)sender{
    CLLocation *location0 = [[CLLocation alloc] initWithLatitude:39.832136 longitude:116.34095];
    CLLocation *location1 = [[CLLocation alloc] initWithLatitude:39.832136 longitude:116.42095];
    CLLocation *location2 = [[CLLocation alloc] initWithLatitude:39.902136 longitude:116.42095];
    CLLocation *location3 = [[CLLocation alloc] initWithLatitude:39.902136 longitude:116.49095];
    CLLocation *location4 = [[CLLocation alloc] initWithLatitude:39.952136 longitude:116.49095];
    CLLocation *location5 = [[CLLocation alloc] initWithLatitude:39.952136 longitude:116.42095];
    CLLocation *location6 = [[CLLocation alloc] initWithLatitude:39.922136 longitude:116.49095];
    CLLocation *location7 = [[CLLocation alloc] initWithLatitude:39.922136 longitude:116.41095];

    NSArray *drawArray = @[location0,location1,location2,location3,location4,location5,location6,location7];

    
//    CLLocation *location = _trackArray.lastObject;
    CLLocation *location = drawArray.lastObject;
    switch (sender.tag) {
        case 1:
            [[LocationManager sharedInstance] startUpdatingLocation];
            break;
            
        case 2:
            [[LocationManager sharedInstance] endUpdatingLocation];
            break;
            
        case 3:
            [_mapView setCenterCoordinate:location.coordinate animated:YES];
            [_mapView setZoomLevel:18 animated:YES];
            break;
            
        case 4:
//            _mapView.region = MACoordinateRegionMake(location.coordinate, MACoordinateSpanMake(0.3, 0.3));
//            MACoordinateRegion region = MACoordinateRegionMakeWithDistance(location.coordinate,5000 ,5000);
        {
            MACoordinateRegion reg = MACoordinateRegionMakeWithDistance([self getMapCenterCoordinateWithAllLocationArray:_trackArray],_totalDistance/2,_totalDistance/2);
//            MACoordinateRegion reg = MACoordinateRegionMakeWithDistance(location.coordinate,_totalDistance/2,_totalDistance/2);
            MACoordinateRegion adjustedRegion = [_mapView regionThatFits:reg];
            [_mapView setRegion:adjustedRegion animated:NO];
//            [_mapView setCenterCoordinate:[self getMapCenterCoordinateWithAllLocationArray:drawArray] animated:YES];
//            [_mapView setZoomLevel:18 animated:YES];

        }
            
            break;
            
        case 5:
            
        {
//            UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(kScreen_Width/2, 0, kScreen_Width/2, kScreen_Height/2)];
//            imageV.image = [self getRunrouteImage:self.bounds];
//            imageV.alpha = 0.5;
//            [self addSubview:imageV];
            [self drawMapGradientLineWithLocationArray:drawArray];
        }
            break;
        default:
            break;
    }
    
//    CLLocation *location = _trackArray.lastObject;
//    _mapView.region = MACoordinateRegionMake(location.coordinate, MACoordinateSpanMake(0.3, 0.3));
//
//    //返回当前的定位点
//    [_mapView setCenterCoordinate:location.coordinate animated:YES];
}

-(void)startUpdataLocation{
    [[LocationManager sharedInstance] startUpdatingLocation];
}
-(void)stopUpdataLocation{
    [[LocationManager sharedInstance] endUpdatingLocation];
}
-(void)setScreenCenterWithCoordinate:(CLLocation *)location{
    [_mapView setCenterCoordinate:location.coordinate animated:YES];
    _isFollowUserLocation = YES;
}
-(void)isShowUserLocation:(BOOL)isShow{
    if (isShow) {
        _mapView.showsUserLocation = YES;
        _mapView.userTrackingMode = MAUserTrackingModeFollow;
    }else{
        _mapView.showsUserLocation = NO;
    }
}
-(void)isShowAnnidation:(BOOL)isShow{
    if (annidationArray.count <= 0) {
        return;
    }
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:annidationArray.firstObject];
    [array addObject:annidationArray.lastObject];
    if (isShow) {
        [_mapView addAnnotations:annidationArray];
    }else{
        [_mapView removeAnnotations:annidationArray];
        [_mapView addAnnotations:array];
    }
}

-(UIImage *)getRunrouteImage{
    [self isShowUserLocation:NO];
    return [_mapView takeSnapshotInRect:self.bounds];
}

-(void)loadMapData{
    ///地图需要v4.5.0及以上版本才必须要打开此选项（v4.5.0以下版本，需要手动配置info.plist）
    [AMapServices sharedServices].enableHTTPS = YES;
    
    ///初始化地图
    _mapView = [[MAMapView alloc] initWithFrame:self.bounds];
    
    _mapView.delegate = self;
    
    //缩放级别(3-19)
    [_mapView setZoomLevel:18 animated:YES];
    
    ///把地图添加至view
    [self addSubview:_mapView];
    
    ///如果您需要进入地图就显示定位小蓝点，则需要下面两行代码
    _mapView.showsUserLocation = YES;
    _mapView.userTrackingMode = MAUserTrackingModeFollow;

    _mapView.showsCompass= NO;// 设置成NO表示关闭指南针；YES表示显示指南针
    _mapView.showsScale = NO; //设置成NO表示不显示比例尺；YES表示显示比例尺
    
    WeakSelf
    [LocationManager sharedInstance].locationBlock = ^(CLLocation *location) {
        if (location.horizontalAccuracy >= 0 && location.horizontalAccuracy <= 65) {
            if (_isFollowUserLocation) {
                [_mapView setCenterCoordinate:location.coordinate animated:YES];
            }
            if (_trackArray.count == 0) {
                _markLocation = location;
                [_trackArray addObject:@[@0,@(location.coordinate.latitude),@(location.coordinate.longitude)]];
                if (weakSelf.getCLLocationWithDistance) {
                    weakSelf.getCLLocationWithDistance(location,0);
                }
                MAPointAnnotation *startPoint = [[MAPointAnnotation alloc] init];
                startPoint.coordinate = weakSelf.markLocation.coordinate;
                startPoint.title = @"GO";
                [weakSelf.mapView addAnnotation:startPoint];
                [annidationArray addObject:startPoint];
                
            }else{
                NSArray *lastPoint = _trackArray.lastObject;
                CLLocation *l2 = [[CLLocation alloc] initWithLatitude:[lastPoint[1] doubleValue] longitude:[lastPoint[2] doubleValue]];
                double distance = [location distanceFromLocation:l2];
                if (distance >= 3) {
                    [_trackArray addObject:@[@(distance),@(location.coordinate.latitude),@(location.coordinate.longitude)]];
                    NSLog(@"_trackArray = %@",_trackArray);
                    
                    if (weakSelf.getCLLocationWithDistance) {
                        weakSelf.getCLLocationWithDistance(location,distance);
                    }
                    [weakSelf drawGradientLineWithArray:_trackArray];
                }
            }
        }
    };
    
    /*
    //构造折线数据对象
    CLLocationCoordinate2D commonPolylineCoords[8];
    commonPolylineCoords[0].latitude = 39.832136;
    commonPolylineCoords[0].longitude = 116.34095;
    
    commonPolylineCoords[1].latitude = 39.832136;
    commonPolylineCoords[1].longitude = 116.42095;
    
    commonPolylineCoords[2].latitude = 39.902136;
    commonPolylineCoords[2].longitude = 116.42095;
    
    commonPolylineCoords[3].latitude = 39.902136;
    commonPolylineCoords[3].longitude = 116.49095;
    
    commonPolylineCoords[4].latitude = 39.952136;
    commonPolylineCoords[4].longitude = 116.49095;
    
    commonPolylineCoords[5].latitude = 39.952136;
    commonPolylineCoords[5].longitude = 116.42095;
    
    commonPolylineCoords[6].latitude = 39.922136;
    commonPolylineCoords[6].longitude = 116.49095;
    
    commonPolylineCoords[7].latitude = 39.922136;
    commonPolylineCoords[7].longitude = 116.41095;
    
    //构造折线对象
//    MAPolyline *commonPolyline = [MAPolyline polylineWithCoordinates:commonPolylineCoords count:4];
    multiPolyline = [MAMultiPolyline polylineWithCoordinates:commonPolylineCoords count:7 drawStyleIndexes:@[@(1),@(3),@(5)]];
    
    //在地图上添加折线对象
//    [_mapView addOverlay: commonPolyline];
    [_mapView addOverlay: multiPolyline];
    
    MAPointAnnotation *startPoint = [[MAPointAnnotation alloc] init];
    startPoint.coordinate = commonPolylineCoords[0];
    startPoint.title = AJ_NSLocalizedString(@"起", nil);
    [self.mapView addAnnotation:startPoint];
    
    MAPointAnnotation *startPoint1 = [[MAPointAnnotation alloc] init];
    startPoint1.coordinate = commonPolylineCoords[3];
    startPoint1.title = AJ_NSLocalizedString(@"起1", nil);
    [self.mapView addAnnotation:startPoint1];
    
//    NSLog(@"[_mapView visibleMapRect] = %f,%f,%f,%f",[_mapView visibleMapRect].origin.x,[_mapView visibleMapRect].origin.y,[_mapView visibleMapRect].size.width,[_mapView visibleMapRect].size.height);
    */
}

-(void)drawGradientLineWithArray:(NSMutableArray *)array{
    if (array.count <= 0) {
        return;
    }
    for (NSArray *speed in array) {
        [mutStrokeColorsArr addObject:[self getDrawStyleColorWithSpeed:[speed[0] doubleValue]]];
    }
    NSMutableArray *locationArray = [NSMutableArray array];
    for (int i = 0; i < array.count; i++) {
        CLLocation *location = [[CLLocation alloc] initWithLatitude:[array[i][1] doubleValue] longitude:[array[i][2] doubleValue]];
        [locationArray addObject:location];
    }
    
    NSUInteger count = 0;
    CLLocationCoordinate2D *coordinates = [self coordinatesFromLocationArray:locationArray count:&count];
    if (coordinates != NULL)
    {
        //刷新
        if (multiPolyline) {
            [_mapView removeOverlay:multiPolyline];
            multiPolyline = nil;
        }
        
        _totalDistance += [[locationArray objectAtIndex:locationArray.count-1] distanceFromLocation:[locationArray objectAtIndex:locationArray.count-2]];
        _annotDistance += [[locationArray objectAtIndex:locationArray.count-1] distanceFromLocation:[locationArray objectAtIndex:locationArray.count-2]];
        if (_annotDistance > _unitDouble) {
            _markLocation = [locationArray objectAtIndex:locationArray.count-1];
            _annotDistance = _totalDistance - annidationArray.count*_unitDouble;
            MAPointAnnotation *startPoint = [[MAPointAnnotation alloc] init];
            startPoint.coordinate = _markLocation.coordinate;
            startPoint.title = [NSString stringWithFormat:@"%ld",annidationArray.count];
            [self.mapView addAnnotation:startPoint];
            [annidationArray addObject:startPoint];
        }
        
        _dateLabel.text = [NSString stringWithFormat:@"%@",[mutStrokeColorsArr lastObject]];
        [drawStyleArr addObject:[NSNumber numberWithInteger:array.count-1]];
        multiPolyline = [MAMultiPolyline polylineWithCoordinates:coordinates count:count drawStyleIndexes:drawStyleArr];
        [self.mapView addOverlay:multiPolyline];
    }
    free(coordinates);
}

/*测试代码*/
- (CLLocationCoordinate2D)getMapCenterCoordinateWithAllLocationArray:(NSArray *)array{
    /* 使轨迹在地图可视范围内. */

    CLLocationDegrees minLat = 0.0;
    CLLocationDegrees maxLat = 0.0;
    CLLocationDegrees minLon = 0.0;
    CLLocationDegrees maxLon = 0.0;


    //解析数据
    for (int i=0; i<array.count; i++) {
        CLLocation *location = array[i];
        if (i==0) {
            //以第一个坐标点做初始值
            minLat = location.coordinate.latitude;
            maxLat = location.coordinate.latitude;
            minLon = location.coordinate.longitude;
            maxLon = location.coordinate.longitude;
        }else{
            //对比筛选出最小纬度，最大纬度；最小经度，最大经度
            minLat = MIN(minLat, location.coordinate.latitude);
            maxLat = MAX(maxLat, location.coordinate.latitude);
            minLon = MIN(minLon, location.coordinate.longitude);
            maxLon = MAX(maxLon, location.coordinate.longitude);
        }
    }
    CLLocationCoordinate2D centCoor;
    //动态的根据坐标数据的区域，来确定地图的显示中心点和缩放级别
    if (array.count > 0) {
        //计算中心点
        centCoor.latitude = (CLLocationDegrees)((maxLat+minLat) * 0.5f);
        centCoor.longitude = (CLLocationDegrees)((maxLon+minLon) * 0.5f);
        return centCoor;
    }
    return centCoor;
}

- (void)setMapVisibleScopeWithAllLocationArray:(NSArray *)array{
    /* 使轨迹在地图可视范围内. */
    if (array.count <= 0) {
        return;
    }
    
    CLLocationDegrees minLat = 0.0;
    CLLocationDegrees maxLat = 0.0;
    CLLocationDegrees minLon = 0.0;
    CLLocationDegrees maxLon = 0.0;
    
    NSMutableArray *locationArray = [NSMutableArray array];
    for (int i = 0; i < array.count; i++) {
        CLLocation *location = [[CLLocation alloc] initWithLatitude:[array[i][1] doubleValue] longitude:[array[i][2] doubleValue]];
        [locationArray addObject:location];
    }
    
    
    //解析数据
    for (int i=0; i<locationArray.count; i++) {
        CLLocation *location = locationArray[i];
        if (i==0) {
            //以第一个坐标点做初始值
            minLat = location.coordinate.latitude;
            maxLat = location.coordinate.latitude;
            minLon = location.coordinate.longitude;
            maxLon = location.coordinate.longitude;
        }else{
            //对比筛选出最小纬度，最大纬度；最小经度，最大经度
            minLat = MIN(minLat, location.coordinate.latitude);
            maxLat = MAX(maxLat, location.coordinate.latitude);
            minLon = MIN(minLon, location.coordinate.longitude);
            maxLon = MAX(maxLon, location.coordinate.longitude);
        }
    }
    
    //动态的根据坐标数据的区域，来确定地图的显示中心点和缩放级别
    //计算中心点
    CLLocationCoordinate2D centCoor;
    centCoor.latitude = (CLLocationDegrees)((maxLat+minLat) * 0.5f);
    centCoor.longitude = (CLLocationDegrees)((maxLon+minLon) * 0.5f);
//    MACoordinateRegion reg = MACoordinateRegionMakeWithDistance(centCoor,_totalDistance/2.0,_totalDistance/2.0);
    MACoordinateRegion reg = MACoordinateRegionMake(centCoor, MACoordinateSpanMake((CLLocationDegrees)(maxLat-minLat)*1.1, (CLLocationDegrees)(maxLon-minLon)*1.1));
    MACoordinateRegion adjustedRegion = [_mapView regionThatFits:reg];
    \
    [_mapView setRegion:adjustedRegion animated:NO];
}

-(void)drawMapGradientLineWithLocationArray:(NSArray *)array{
    if (array.count <= 0) {
        return;
    }
    [_trackArray removeAllObjects];
    [_trackArray addObjectsFromArray:array];
    [mutStrokeColorsArr removeAllObjects];
    [drawStyleArr removeAllObjects];
    [_mapView removeAnnotations:annidationArray];
    [annidationArray removeAllObjects];
    _annotDistance = 0;
    _totalDistance = 0;
    
    for (NSArray *speed in array) {
        [mutStrokeColorsArr addObject:[self getDrawStyleColorWithSpeed:[speed[0] doubleValue]]];
    }
    NSMutableArray *locationArray = [NSMutableArray array];
    for (int i = 0; i < array.count; i++) {
        CLLocation *location = [[CLLocation alloc] initWithLatitude:[array[i][1] doubleValue] longitude:[array[i][2] doubleValue]];
        [locationArray addObject:location];
    }
    if (locationArray.count == 1) {
        _markLocation = locationArray[0];
        MAPointAnnotation *startPoint = [[MAPointAnnotation alloc] init];
        startPoint.coordinate = _markLocation.coordinate;
        startPoint.title = @"GO";
        [self.mapView addAnnotation:startPoint];
        [annidationArray addObject:startPoint];
        return;
    }
    NSUInteger count = 0;
    CLLocationCoordinate2D *coordinates = [self coordinatesFromLocationArray:locationArray count:&count];
    if (coordinates != NULL)
    {
        if (multiPolyline) {
            [_mapView removeOverlay:multiPolyline];
            multiPolyline = nil;
        }
        for (int i = 0; i < locationArray.count - 1; i ++) {
            
            _annotDistance += [locationArray[i] distanceFromLocation:locationArray[i+1]];
            _totalDistance += [locationArray[i] distanceFromLocation:locationArray[i+1]];
            if (_annotDistance > _unitDouble || i==0) {
                _markLocation = i==0?locationArray[0]:locationArray[i+1];
                _annotDistance = _totalDistance - annidationArray.count*_unitDouble;
                MAPointAnnotation *startPoint = [[MAPointAnnotation alloc] init];
                startPoint.coordinate = _markLocation.coordinate;
                if (i == 0 ) {
                    startPoint.title = @"GO";
                    [self.mapView addAnnotation:startPoint];
                }else{
                    startPoint.title = [NSString stringWithFormat:@"%d",annidationArray.count];
                    if (_isSelectClick) {
                        [self.mapView addAnnotation:startPoint];
                    }
                }
                [annidationArray addObject:startPoint];
            }
            if (locationArray[i+1] == locationArray.lastObject && !_isSport) {
                MAPointAnnotation *startPoint = [[MAPointAnnotation alloc] init];
                CLLocation *lastLocation = locationArray.lastObject;
                startPoint.coordinate = lastLocation.coordinate;
                startPoint.title = @"END";
                [self.mapView addAnnotation:startPoint];
                [annidationArray addObject:startPoint];
            }
            [drawStyleArr addObject:[NSNumber numberWithInteger:i]];
        }
        multiPolyline = [MAMultiPolyline polylineWithCoordinates:coordinates count:count drawStyleIndexes:drawStyleArr];
        [self.mapView addOverlay:multiPolyline];
    }
    free(coordinates);
    
}

- (UIColor *)drawGradientLineWithFirstLocation:(CLLocation *)firstLocation andSecondLocation:(CLLocation *)secondLocation {

    double distance = [firstLocation distanceFromLocation:secondLocation];
    double time = [firstLocation.timestamp timeIntervalSinceDate:secondLocation.timestamp];
    double speed = distance/time==0?1:time;
    return [self getDrawStyleColorWithSpeed:speed];
}

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
        drawStyleColor = [UIColor blackColor];
    }
    return drawStyleColor;
}


-(void)mapView:(MAMapView *)mapView mapWillMoveByUser:(BOOL)wasUserAction{
    if (wasUserAction) {
        _isFollowUserLocation = NO;
    }
}

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
        if ([overlay isKindOfClass:[MAMultiPolyline class]])
    {
        if (renderer) {
            renderer = nil;
        }
        renderer = [[MAMultiColoredPolylineRenderer alloc] initWithOverlay:overlay];
        
        renderer.lineWidth = 6;
        
        renderer.strokeColors = mutStrokeColorsArr;
        
        renderer.gradient = YES;
        
        return renderer;
    }
    return nil;
}
- (CLLocationCoordinate2D *)coordinatesFromLocationArray:(NSArray *)locations count:(NSUInteger *)count
{
    if (locations.count == 0)
    {
        return NULL;
    }
    
    *count = locations.count;
    
    CLLocationCoordinate2D *coordinates = (CLLocationCoordinate2D *)malloc(sizeof(CLLocationCoordinate2D) * *count);
    
    int i = 0;
    for (CLLocation *location in locations)
    {
        coordinates[i] = location.coordinate;
        ++i;
    }
    return coordinates;
}

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation {
    
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {//判断是否是自己的定位气泡，如果是自己的定位气泡，不做任何设置，显示为蓝点，如果不是自己的定位气泡，比如大头针就会进入
        // @"当前位置" 为高德地图添加，不需要多语言
        if ([annotation.title isEqualToString:@"当前位置"]) {
            return nil;
        }
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        //NSString *pointReuseIndentifier = annotation.title;
        
        MAAnnotationView*annotationView = (MAAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        
        if (annotationView == nil) {
            
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        
        annotationView.frame = CGRectMake(0, 0, 24, 24);
        
        annotationView.canShowCallout= NO;//YES;       //设置气泡可以弹出，默认为NO
        //annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
        annotationView.draggable = NO;//YES;           //设置标注可以拖动，默认为NO
        //        annotationView.pinColor = MAPinAnnotationColorPurple;
        
        UIView *labelBGView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 24, 24)];
        labelBGView.layer.borderColor = [UIColor whiteColor].CGColor;
        labelBGView.layer.borderWidth = 2.0;
        labelBGView.layer.cornerRadius = 12;
        labelBGView.clipsToBounds = YES;
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 24, 24)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = annotation.title;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:10];
        [labelBGView addSubview:label];
        
        [annotationView addSubview:labelBGView];
        
        return annotationView;
    }
    return nil;
}


@end
