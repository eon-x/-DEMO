//
//  GoogleTestVC.m
//  googleMap
//
//  Created by xiongze on 2019/11/25.
//  Copyright © 2019 xiongze. All rights reserved.
//

#import "GoogleTestVC.h"

@interface GoogleTestVC ()

@end

@implementation GoogleTestVC

#pragma mark ----- vc lift cycle 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self initUI];
}

#pragma mark ----- get and set 属性的set和get方法

- (ExerciseGoogleMap *)googleMapView{
    if (!_googleMapView) {
        _googleMapView = [[ExerciseGoogleMap alloc]initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)
                                                        position:CLLocationCoordinate2DMake(22.686230, 113.980271)];
        _googleMapView.isSport = YES;
        _googleMapView.isShowSelf = YES;
        __block GoogleTestVC *blockSelf = self;
        _googleMapView.getCLLocationWithDistance = ^(CLLocation *location, double distance) {
            [blockSelf addPointWith:location distance:distance];
        };
        [_googleMapView startUpdataLocation];
    }
    return _googleMapView;
}

#pragma mark ----- event Response 事件响应(手势 通知)

//地图的block回调，增加距离和定位点
- (void)addPointWith:(CLLocation *)location distance:(double)distance{
    NSLog(@"%@",location);
}

#pragma mark ----- custom action for UI 界面处理有关

- (void)initUI{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Google Map";
    
    [self.view addSubview:self.googleMapView];
}

#pragma mark ----- custom action for DATA 数据处理有关

- (void)initData{
    
}


#pragma mark ----- xxxxxx delegate 各种delegate回调




@end
