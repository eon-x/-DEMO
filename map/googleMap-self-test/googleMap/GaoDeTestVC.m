//
//  GaoDeTestVC.m
//  googleMap
//
//  Created by xiongze on 2019/11/25.
//  Copyright © 2019 xiongze. All rights reserved.
//

#import "GaoDeTestVC.h"

@interface GaoDeTestVC ()

@end

@implementation GaoDeTestVC

#pragma mark ----- vc lift cycle 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self initUI];
}

#pragma mark ----- get and set 属性的set和get方法

- (ExerciseGDMap *)gdMapView {
    if (!_gdMapView) {
        _gdMapView = [[ExerciseGDMap alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height)];
        _gdMapView.isSport = YES;
        _gdMapView.getCLLocationWithDistance = ^(CLLocation *location, double distance) {
            
        };
        [_gdMapView startUpdataLocation];
    }
    return _gdMapView;
}

#pragma mark ----- event Response 事件响应(手势 通知)


#pragma mark ----- custom action for UI 界面处理有关

- (void)initUI{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"GaoDe Map";
    
    [self.view addSubview:self.gdMapView];
}

#pragma mark ----- custom action for DATA 数据处理有关

- (void)initData{
    
}


#pragma mark ----- xxxxxx delegate 各种delegate回调




@end
