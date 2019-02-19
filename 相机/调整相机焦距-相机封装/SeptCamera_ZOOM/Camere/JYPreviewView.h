//
//  JYPreviewView.h
//  SeptOfCamera
//
//  Created by Sept on 16/1/5.
//  Copyright © 2016年 九月. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AVCaptureSession;

@interface JYPreviewView : UIView

@property (nonatomic) AVCaptureSession *session;

@end
