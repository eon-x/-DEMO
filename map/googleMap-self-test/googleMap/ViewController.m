//
//  ViewController.m
//  googleMap
//
//  Created by 柴智权 on 2017/12/20.
//  Copyright © 2017年 xiongze. All rights reserved.
//

#import "ViewController.h"
#import "GoogleTestVC.h"
#import "GaoDeTestVC.h"

@implementation ViewController{
    GMSMapView *_mapView;
    NSArray *_dataArray;
}

#pragma mark ----- vc lift cycle 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    self.googleMapManage = [[IDOGoogleMapManage alloc] init];
//    self.view = [self.googleMapManage addMapWithLatitude:44.1314
//                                               longitude:9.6921
//                                                    zoom:14.059f];
//    
//    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"track" ofType:@"json"];
//    NSData *data = [NSData dataWithContentsOfFile:filePath];
//    _dataArray = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
//    
//    [self addLine];
//    [self addLineColor];
//    [self addMake];
//    [self addImageMake];
}

//数组里面为 {@"lat":@"44.134271", @"lng":@"9.685005"} 对象
- (void)addLine{
    [self.googleMapManage addMapLineWithArray:_dataArray];
}

//数组里面为 {@"elevation":@"88.30000305175781"} 对象
- (void)addLineColor{
    [self.googleMapManage addMapLineColorWithArray:_dataArray];
}

- (void)addMake{
    NSDictionary *info = [_dataArray objectAtIndex:200];
    CLLocationDegrees lat = [[info objectForKey:@"lat"] doubleValue];
    CLLocationDegrees lng = [[info objectForKey:@"lng"] doubleValue];
    CLLocationCoordinate2D position = CLLocationCoordinate2DMake(lat, lng);
    [self.googleMapManage makeGMSMarkerWithPoint:position title:@"99" showTitle:info[@"time"]];
}

- (void)addImageMake{
    NSDictionary *info = [_dataArray objectAtIndex:400];
    CLLocationDegrees lat = [[info objectForKey:@"lat"] doubleValue];
    CLLocationDegrees lng = [[info objectForKey:@"lng"] doubleValue];
    CLLocationCoordinate2D position = CLLocationCoordinate2DMake(lat, lng);
    UIImage *image = [UIImage imageNamed:@"time_select"];
    [self.googleMapManage makeImageMarkerWithPoint:position image:image showTitle:@""];
}

- (IBAction)clickGoogleTest:(id)sender {
    GoogleTestVC *vc = [[GoogleTestVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)clickGDTest:(id)sender {
    GaoDeTestVC *vc = [[GaoDeTestVC alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
