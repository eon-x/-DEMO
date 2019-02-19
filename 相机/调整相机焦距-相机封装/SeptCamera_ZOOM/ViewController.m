//
//  ViewController.m
//  SeptCamera_ZOOM
//
//  Created by Sept on 16/3/22.
//  Copyright © 2016年 九月. All rights reserved.
//

#import "ViewController.h"

#import "JYPreviewView.h"
#import "JYCameraManager.h"

@interface ViewController ()

@property (strong, nonatomic) JYCameraManager *camereManager;

@property (weak, nonatomic) IBOutlet JYPreviewView *previewView;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

/** 懒加载相机类 */
- (JYCameraManager *)camereManager
{
    if (_camereManager == nil) {
        _camereManager = [[JYCameraManager alloc] initWithPreview:self.previewView];
    }
    return _camereManager;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.camereManager startSession];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.camereManager stopSession];
}

/** 拍照 */
- (IBAction)takePhotoOnClick:(UIButton *)sender
{
    [self.camereManager snapStillImage];
}

/** 调节ZOOM */
- (IBAction)zoomChangeValue:(UISlider *)sender
{
    NSError *error = nil;
    [self.camereManager.captureDevice lockForConfiguration:&error];
    if (!error) {
        self.camereManager.captureDevice.videoZoomFactor = sender.value;
    }else
    {
        NSLog(@"error = %@", error);
    }
    [self.camereManager.captureDevice unlockForConfiguration];
}

/** 放大缩小屏幕 */
- (IBAction)viewScaleChnageValue:(UISlider *)sender
{
    self.previewView.transform = CGAffineTransformMakeScale(sender.value, sender.value);
}

/**
   
   ZOOM:镜头变焦，推近或者拉远焦距,拍照后有效果
   放大缩小屏幕：放大缩小后拍照无效果
 */

@end
