//
//  ViewController.m
//  googleMap
//
//  Created by 柴智权 on 2017/12/20.
//  Copyright © 2017年 xiongze. All rights reserved.
//

#import "ViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@interface ViewController ()

@end

@implementation ViewController{
    GMSMapView *_mapView;
    GMSPolyline *_polyline;
    NSMutableArray *_trackData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:44.1314
                                                            longitude:9.6921
                                                                 zoom:14.059f
                                                              bearing:328.f
                                                         viewingAngle:40.f];
    _mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    self.view = _mapView;
    
    [self parseTrackFile];
    [_polyline setSpans:[self gradientSpans]];
}

- (NSArray *)gradientSpans {
    NSMutableArray *colorSpans = [NSMutableArray array];
    NSUInteger count = _trackData.count;
    UIColor *prevColor;
    for (NSUInteger i = 0; i < count; i++) {
        NSDictionary *dict = [_trackData objectAtIndex:i];
        double elevation = [[dict objectForKey:@"elevation"] doubleValue];
        UIColor *toColor = [UIColor colorWithHue:(float)elevation/700
                                      saturation:1.f
                                      brightness:.9f
                                           alpha:1.f];
//        UIColor *toColor = [UIColor whiteColor];
//        if (i%300==0) {
//            toColor = [UIColor redColor];
//        }else if (i%300==100){
//            toColor = [UIColor greenColor];
//        }else if (i%300==200){
//            toColor = [UIColor blueColor];
//        }
        
        if (prevColor == nil) {
            prevColor = toColor;
        }
        
        GMSStrokeStyle *style = [GMSStrokeStyle gradientFromColor:prevColor toColor:toColor];
        [colorSpans addObject:[GMSStyleSpan spanWithStyle:style]];
        
        prevColor = toColor;
    }
    return colorSpans;
}

- (void)parseTrackFile {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"track" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    _trackData = [[NSMutableArray alloc] init];
    GMSMutablePath *path = [GMSMutablePath path];
    
    for (NSUInteger i = 0; i < json.count; i++) {
        NSDictionary *info = [json objectAtIndex:i];
        NSNumber *elevation = [info objectForKey:@"elevation"];
        CLLocationDegrees lat = [[info objectForKey:@"lat"] doubleValue];
        CLLocationDegrees lng = [[info objectForKey:@"lng"] doubleValue];
        CLLocation *loc = [[CLLocation alloc] initWithLatitude:lat longitude:lng];
        [_trackData addObject:@{@"loc": loc, @"elevation": elevation}];
        [path addLatitude:lat longitude:lng];
        
        if (i%400 == 0) {
            CLLocationCoordinate2D position = CLLocationCoordinate2DMake(lat, lng);
            GMSMarker *marker = [GMSMarker markerWithPosition:position];
            marker.title = info[@"time"];
            marker.icon = [UIImage imageNamed:@"time_select"];
            marker.map = _mapView;
        }else if (i%200 == 0){
            CLLocationCoordinate2D position = CLLocationCoordinate2DMake(lat, lng);
            GMSMarker *marker = [GMSMarker markerWithPosition:position];
            marker.title = info[@"time"];
            
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 24, 24)];
            label.backgroundColor = [UIColor blackColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = @"2";
            label.textColor = [UIColor whiteColor];
            label.layer.cornerRadius = 12;
            label.clipsToBounds = YES;
            label.layer.borderColor = [UIColor whiteColor].CGColor;
            label.layer.borderWidth = 2.0;
            marker.iconView = label;
            
            marker.map = _mapView;
        }
        
        NSLog(@"%ld",i);
    }
    
    _polyline = [GMSPolyline polylineWithPath:path];
    _polyline.strokeWidth = 3;
    _polyline.map = _mapView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
