//
//  IDOGoogleMapManage.m
//  googleMap
//
//  Created by xiongze on 2019/11/25.
//  Copyright © 2019 xiongze. All rights reserved.
//

#import "IDOGoogleMapManage.h"

@implementation IDOGoogleMapManage{
    GMSMapView *_mapView;
    GMSPolyline *_polyline;
}

#pragma mark ----- get and set 属性的set和get方法


#pragma mark ----- event Response 事件响应(手势 通知)


#pragma mark ----- custom action for UI 界面处理有关

- (UIView *)addMapWithLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude zoom:(float)zoom{
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:latitude
                                                            longitude:longitude
                                                                 zoom:zoom
                                                              bearing:328.f
                                                         viewingAngle:40.f];
    _mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    _trackArray = [NSMutableArray array];
    return _mapView;
}

- (void)addMapLineWithArray:(NSArray *)lineArray{
    if (lineArray.count == 0) { return; }
    [_mapView clear];
    _trackArray = [[NSMutableArray alloc] initWithArray:lineArray];

    GMSMutablePath *path = [GMSMutablePath path];
    for (NSUInteger i = 0; i < lineArray.count; i++) {
        NSDictionary *info = [lineArray objectAtIndex:i];
        CLLocationDegrees lat = [[info objectForKey:@"lat"] doubleValue];
        CLLocationDegrees lng = [[info objectForKey:@"lng"] doubleValue];
        [path addLatitude:lat longitude:lng];
    }
    
    _polyline = [GMSPolyline polylineWithPath:path];
    _polyline.strokeWidth = 3;
    _polyline.map = _mapView;
}

- (void)addMapLineColorWithArray:(NSArray *)lineColorArray{
    NSMutableArray *colorSpans = [NSMutableArray array];
    NSUInteger count = lineColorArray.count;
    UIColor *prevColor;
    for (NSUInteger i = 0; i < count; i++) {
        NSDictionary *dict = [lineColorArray objectAtIndex:i];
        double elevation = [[dict objectForKey:@"elevation"] doubleValue];
        UIColor *toColor = [UIColor colorWithHue:(float)elevation/700 saturation:1.f brightness:.9f alpha:1.f];

        if (prevColor == nil) {
            prevColor = toColor;
        }

        GMSStrokeStyle *style = [GMSStrokeStyle gradientFromColor:prevColor toColor:toColor];
        [colorSpans addObject:[GMSStyleSpan spanWithStyle:style]];

        prevColor = toColor;
    }
    
    [_polyline setSpans:colorSpans];
}

//添加新的轨迹点 并更新轨迹
- (void)addNewPointWithLocation:(CLLocationCoordinate2D)position{
    [self.trackArray addObject:@{@"lat":@(position.latitude),@"lng":@(position.longitude)}];
    [self addMapLineWithArray:self.trackArray];
}

- (GMSMarker *)makeGMSMarkerWithPoint:(CLLocationCoordinate2D)position title:(NSString *)title showTitle:(NSString *)sTitle{
    GMSMarker *marker = [GMSMarker markerWithPosition:position];
    marker.title = sTitle;
    marker.groundAnchor = CGPointMake(0.5, 0.5);

    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 24, 24)];
    label.backgroundColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = title;
    label.textColor = [UIColor whiteColor];
    
    CGSize size ;float tSize = 14;
    do {
        size = [label.text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:tSize]}];
        tSize = tSize - 1;
    } while (size.width > 20);
    
    label.font = [UIFont systemFontOfSize:tSize];
    label.layer.cornerRadius = 12;
    label.clipsToBounds = YES;
    label.layer.borderColor = [UIColor whiteColor].CGColor;
    label.layer.borderWidth = 2.0;
        
    marker.iconView = label;
    marker.map = _mapView;
    return marker;
}

- (GMSMarker *)makeImageMarkerWithPoint:(CLLocationCoordinate2D)position image:(UIImage *)image showTitle:(NSString *)sTitle{
    GMSMarker *marker = [GMSMarker markerWithPosition:position];
    marker.title = sTitle;
    marker.icon = image;
    marker.map = _mapView;
    marker.groundAnchor = CGPointMake(0.5, 0.5);
    return marker;
}

#pragma mark ----- custom action for DATA 数据处理有关



#pragma mark ----- xxxxxx delegate 各种delegate回调


@end
