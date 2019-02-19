//
//  JYCameraManager.h
//  SeptiOSCamera
//
//  Created by Sept on 16/1/4.
//  Copyright © 2016年 九月. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AVFoundation/AVFoundation.h>

@class JYPreviewView, JYCameraManager;

@protocol JYCameraManagerDelegate <NSObject>

@optional
- (void)cameraManage:(JYCameraManager *)cameraManage getImgData:(NSData *)imgData;

/** 获取视频保存的URL */
- (void)cameraManagerVideoSaveURL:(NSURL *)outputFileURL;

/** 获取视频是否保存成功 */
- (void)cameraManagerVideoDidSaveLSuccess:(BOOL)success;

/** 保存视频失败 */
- (void)cameraManagerSaveVideoError;

@end

@interface JYCameraManager : NSObject

@property (weak, nonatomic) id<JYCameraManagerDelegate>delegate;

@property (nonatomic,assign,getter=isFlashEnabled) BOOL enableFlash;
@property (nonatomic,assign,getter=isDevicePositionBack) BOOL enableBack;
//
@property (strong, nonatomic) AVCaptureDevice *captureDevice;
@property (nonatomic) AVCaptureMovieFileOutput *movieFileOutput;

- (void)stopSession;
- (void)startSession;

- (instancetype)initWithPreview:(JYPreviewView *)previewView;

- (void)snapStillImage;

- (void)videoDidEndRecodeing;
- (void)videoRecoding;

- (void)switchCamera;

- (void)cameraManagerChangeFoucus:(CGFloat)value;

- (void)cameraManagerWhiteBalanceWithTemp:(CGFloat)temp andTint:(CGFloat)tint;

- (void)cameraManagerWithExposure:(CGFloat)value;

- (void)cameraManagerWithExposureTime:(CGFloat)time andIso:(CGFloat)iso;

- (void)focusWithMode:(AVCaptureFocusMode)focusMode exposeWithMode:(AVCaptureExposureMode)exposureMode atDevicePoint:(CGPoint)point monitorSubjectAreaChange:(BOOL)monitorSubjectAreaChange isAutoFocus:(BOOL)isAutoFocus;

/** 设置相机的曝光模式 */
- (void)exposeMode:(AVCaptureExposureMode)exposureMode;
/** 设置相机的白平衡模式 */
- (void)whiteBalanceMode:(AVCaptureWhiteBalanceMode)whiteBalanceMode;

/** 设置相机的HDR */     // ----> 仅供参考
- (void)cameraManagerSetVideoHDR;

- (void)cameraManagerWithExposureTime:(CGFloat)time andIso:(CGFloat)iso choose:(BOOL)isTime;

/** 设置相机拍摄质量 */
- (void)cameraManagerEffectqualityWithTag:(NSInteger)tag;

/** 分级捕捉 */
- (void)classificationCapture;

@end

