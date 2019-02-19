//
//  JYPreviewView.m
//  SeptOfCamera
//
//  Created by Sept on 16/1/5.
//  Copyright © 2016年 九月. All rights reserved.
//

@import AVFoundation;

#import "JYPreviewView.h"

@implementation JYPreviewView

+ (Class)layerClass
{
    return [AVCaptureVideoPreviewLayer class];
}

- (AVCaptureSession *)session
{
    AVCaptureVideoPreviewLayer *previewLayer = (AVCaptureVideoPreviewLayer *)self.layer;
    return previewLayer.session;
}

- (void)setSession:(AVCaptureSession *)session
{
    AVCaptureVideoPreviewLayer *previewLayer = (AVCaptureVideoPreviewLayer *)self.layer;
    previewLayer.session = session;
}

@end
