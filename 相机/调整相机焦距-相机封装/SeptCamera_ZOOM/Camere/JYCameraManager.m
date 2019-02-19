//
//  JYCameraManager.m
//  SeptiOSCamera
//
//  Created by Sept on 16/1/4.
//  Copyright © 2016年 九月. All rights reserved.
//

#import "JYCameraManager.h"

#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import "JYPreviewView.h"

static void * CapturingStillImageContext = &CapturingStillImageContext;
static void * SessionRunningContext = &SessionRunningContext;
static void * CaptureLensPositionContext = &CaptureLensPositionContext;
static void * DeviceWhiteBalanceGains = &DeviceWhiteBalanceGains;
static void * DeviceExposureTargetBias = &DeviceExposureTargetBias;
static void * DeviceExposureISO = &DeviceExposureISO;
static void * DeviceExposureDuration = &DeviceExposureDuration;
static void * DeviceExposureOffset = &DeviceExposureOffset;

typedef NS_ENUM( NSInteger, AVCamSetupResult ) {
    AVCamSetupResultSuccess,
    AVCamSetupResultCameraNotAuthorized,
    AVCamSetupResultSessionConfigurationFailed
};

@interface JYCameraManager () <AVCaptureFileOutputRecordingDelegate>

@property (nonatomic, weak) JYPreviewView *previewView;

@property (nonatomic) dispatch_queue_t sessionQueue;
@property (nonatomic) AVCaptureSession *session;
@property (nonatomic) AVCaptureDeviceInput *videoDeviceInput;
@property (nonatomic) AVCaptureStillImageOutput *stillImageOutput;

@property (nonatomic) AVCamSetupResult setupResult;
@property (nonatomic, getter=isSessionRunning) BOOL sessionRunning;
@property (nonatomic) UIBackgroundTaskIdentifier backgroundRecordingID;

@end

@implementation JYCameraManager

- (instancetype)initWithPreview:(JYPreviewView *)previewView
{
    self = [super init];
    if (self) {
        
        self.previewView = previewView;
        
        [self initSession];
    }
    return self;
}

- (void)initSession
{
    self.session = [[AVCaptureSession alloc] init];
    
    // Setup the preview view.
    self.previewView.session = self.session;
    
    // 与此队列中的会话和其他会话对象进行通信
    self.sessionQueue = dispatch_queue_create( "session queue", DISPATCH_QUEUE_SERIAL );
    
    self.setupResult = AVCamSetupResultSuccess;
    
    // 检测视频授权状态，视频访问是必须的，音频访问是可选的
    // 如果音频访问被拒绝， 在视频录制过程中没有录制音频
    switch ( [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo] )
    {
        case AVAuthorizationStatusAuthorized:
        {
            // 该用户先前已授权访问相机
            break;
        }
        case AVAuthorizationStatusNotDetermined:
        {
            // 用户尚未提交给视频访问的选项
            // 我们暂停会话队列，以延迟会话设置，知道请求访问完成，以避免用户音频访问，如果视频访问被拒绝
            dispatch_suspend( self.sessionQueue );
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^( BOOL granted ) {
                if ( ! granted ) {
                    self.setupResult = AVCamSetupResultCameraNotAuthorized;
                }
                dispatch_resume( self.sessionQueue );
            }];
            break;
        }
        default:
        {
            // 用户先前以拒绝访问
            self.setupResult = AVCamSetupResultCameraNotAuthorized;
            break;
        }
    }
    
    // 设置捕追会话
    // 一般来说是不安全的 AVCaptureSession 突变 或 其任何输入，输出，或连接多个线程，在同一时间
    dispatch_async( self.sessionQueue, ^{
        if ( self.setupResult != AVCamSetupResultSuccess ) {
            return;
        }
        
        self.backgroundRecordingID = UIBackgroundTaskInvalid;
        NSError *error = nil;
        
        AVCaptureDevice *videoDevice = [JYCameraManager deviceWithMediaType:AVMediaTypeVideo preferringPosition:AVCaptureDevicePositionBack];
        AVCaptureDeviceInput *videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
        
        if ( ! videoDeviceInput ) {
            NSLog( @"Could not create video device input: %@", error );
        }
        
        [self.session beginConfiguration];
        
        if ( [self.session canAddInput:videoDeviceInput] ) {
            [self.session addInput:videoDeviceInput];
            self.videoDeviceInput = videoDeviceInput;
            
            AVCaptureDevice *currentVideoDevice = self.videoDeviceInput.device;
            self.captureDevice = currentVideoDevice;
            
            dispatch_async( dispatch_get_main_queue(), ^{
                
                
                UIInterfaceOrientation statusBarOrientation = [UIApplication sharedApplication].statusBarOrientation;
                AVCaptureVideoOrientation initialVideoOrientation = AVCaptureVideoOrientationPortrait;
                if ( statusBarOrientation != UIInterfaceOrientationUnknown ) {
                    initialVideoOrientation = (AVCaptureVideoOrientation)statusBarOrientation;
                }
                
                AVCaptureVideoPreviewLayer *previewLayer = (AVCaptureVideoPreviewLayer *)self.previewView.layer;
                previewLayer.connection.videoOrientation = initialVideoOrientation;
            } );
        }
        else {
            // 无法将视频设备输入到会话中
            NSLog( @"Could not add video device input to the session" );
            self.setupResult = AVCamSetupResultSessionConfigurationFailed;
        }
        
        AVCaptureDevice *audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
        AVCaptureDeviceInput *audioDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:&error];
        
        if ( ! audioDeviceInput ) {
            // 无法创建音频设备的输入
            NSLog( @"Could not create audio device input: %@", error );
        }
        
        if ( [self.session canAddInput:audioDeviceInput] ) {
            [self.session addInput:audioDeviceInput];
        }
        else {
            // 无法将音频设备输入到会话中
            NSLog( @"Could not add audio device input to the session" );
        }
        
        AVCaptureMovieFileOutput *movieFileOutput = [[AVCaptureMovieFileOutput alloc] init];
        if ( [self.session canAddOutput:movieFileOutput] ) {
            [self.session addOutput:movieFileOutput];
            AVCaptureConnection *connection = [movieFileOutput connectionWithMediaType:AVMediaTypeVideo];
            if ( connection.isVideoStabilizationSupported ) {
                connection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeAuto;
            }
            self.movieFileOutput = movieFileOutput;
            
        }
        else {
            // 无法将电影文件输出添加到会话中
            NSLog( @"Could not add movie file output to the session" );
            self.setupResult = AVCamSetupResultSessionConfigurationFailed;
        }
        
        AVCaptureStillImageOutput *stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
        if ( [self.session canAddOutput:stillImageOutput] ) {
            stillImageOutput.outputSettings = @{AVVideoCodecKey : AVVideoCodecJPEG};
            [self.session addOutput:stillImageOutput];
            self.stillImageOutput = stillImageOutput;
        }
        else {
            // 无法将静止图像输出添加到会话中
            NSLog( @"Could not add still image output to the session" );
            self.setupResult = AVCamSetupResultSessionConfigurationFailed;
        }
        
        [self.session commitConfiguration];
    } );
    
    [self cameraManagerEffectqualityWithTag:91];
}

- (void)startSession
{
    dispatch_async( self.sessionQueue, ^{
        switch ( self.setupResult )
        {
            case AVCamSetupResultSuccess:
            {
                // 只有设置观察员， 如果设置成功就开始运行
                [self addObservers];
                [self.session startRunning];
                self.sessionRunning = self.session.isRunning;
                break;
            }
            case AVCamSetupResultCameraNotAuthorized:
            {
                dispatch_async( dispatch_get_main_queue(), ^{
//                    // 相机没有权限使用相机，请更改隐私设置
//                    NSString *message = NSLocalizedString( @"AVCam doesn't have permission to use the camera, please change privacy settings", @"Alert message when the user has denied access to the camera" );
//                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"AVCam" message:message preferredStyle:UIAlertControllerStyleAlert];
//                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString( @"OK", @"Alert OK button" ) style:UIAlertActionStyleCancel handler:nil];
//                    [alertController addAction:cancelAction];
//                    // Provide quick access to Settings.
//                    UIAlertAction *settingsAction = [UIAlertAction actionWithTitle:NSLocalizedString( @"Settings", @"Alert button to open Settings" ) style:UIAlertActionStyleDefault handler:^( UIAlertAction *action ) {
//                        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
//                    }];
//                    [alertController addAction:settingsAction];
//                    [self presentViewController:alertController animated:YES completion:nil];
                } );
                break;
            }
            case AVCamSetupResultSessionConfigurationFailed:
            {
                dispatch_async( dispatch_get_main_queue(), ^{
//                    NSString *message = NSLocalizedString( @"Unable to capture media", @"Alert message when something goes wrong during capture session configuration" );
//                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"AVCam" message:message preferredStyle:UIAlertControllerStyleAlert];
//                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString( @"OK", @"Alert OK button" ) style:UIAlertActionStyleCancel handler:nil];
//                    [alertController addAction:cancelAction];
//                    [self presentViewController:alertController animated:YES completion:nil];
                } );
                break;
            }
        }
    } );

}

- (void)stopSession
{
    dispatch_async( self.sessionQueue, ^{
        if ( self.setupResult == AVCamSetupResultSuccess ) {
            [self.session stopRunning];
            [self removeObservers];
        }
    } );
}

- (void)removeObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self.session removeObserver:self forKeyPath:@"running" context:SessionRunningContext];
    [self.stillImageOutput removeObserver:self forKeyPath:@"capturingStillImage" context:CapturingStillImageContext];
}

#pragma mark KVO and Notifications

- (void)addObservers
{
    // 1.监听会话是否开启
    [self.session addObserver:self forKeyPath:@"running" options:NSKeyValueObservingOptionNew context:SessionRunningContext];
    
    // 2.监听捕捉图片
    [self.stillImageOutput addObserver:self forKeyPath:@"capturingStillImage" options:NSKeyValueObservingOptionNew context:CapturingStillImageContext];
    
    // 实时监听白平衡的变化
    [self.captureDevice addObserver:self forKeyPath:@"deviceWhiteBalanceGains" options:NSKeyValueObservingOptionNew context:DeviceWhiteBalanceGains];
    
    // 实时监听对焦值的变化
    [self.captureDevice addObserver:self forKeyPath:@"lensPosition" options:NSKeyValueObservingOptionNew context:CaptureLensPositionContext];
    
    // 实时监听曝光偏移的变化exposureTargetOffset
    [self.captureDevice addObserver:self forKeyPath:@"exposureTargetOffset" options:NSKeyValueObservingOptionNew context:DeviceExposureOffset];
    
    // 曝光补偿
    [self.captureDevice addObserver:self forKeyPath:@"exposureTargetBias" options:NSKeyValueObservingOptionNew context:DeviceExposureTargetBias];
    
    // 实时监听感光度的变化
    [self.captureDevice addObserver:self forKeyPath:@"ISO" options:NSKeyValueObservingOptionNew context:DeviceExposureISO];
    
    // 实时监听曝光时间的变化
    [self.captureDevice addObserver:self forKeyPath:@"exposureDuration" options:NSKeyValueObservingOptionNew context:DeviceExposureDuration];
    
    
    // 3.设置通知 （在avcapturedevice实例检测到视频领域的一个重大改变发送通知）
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subjectAreaDidChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:self.videoDeviceInput.device];
    
    // 4.在caputerSession开始运行时意外出现错误时发送通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sessionRuntimeError:) name:AVCaptureSessionRuntimeErrorNotification object:self.session];
    
    // 5.在avcapturesession的实例中断的时候发送通知
    // 由一个传入的电话呼叫，或报警，或另一个应用程序，以控制硬件资源的需要。当适当的avcapturesession实例将停止运行，自动响应一个中断。
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sessionWasInterrupted:) name:AVCaptureSessionWasInterruptedNotification object:self.session];
    
    // 6.在avcapturesession的实例不再中断的时候发送通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sessionInterruptionEnded:) name:AVCaptureSessionInterruptionEndedNotification object:self.session];
}

#pragma KVO监听事件
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    // 2.监听捕捉图片
    if ( context == CapturingStillImageContext ) {
        BOOL isCapturingStillImage = [change[NSKeyValueChangeNewKey] boolValue];
        
        if ( isCapturingStillImage ) {
            dispatch_async( dispatch_get_main_queue(), ^{
                //                self.previewView.layer.opacity = 0.0;
                //                [UIView animateWithDuration:0.25 animations:^{
                //                    self.previewView.layer.opacity = 1.0;
                //                }];
            } );
        }
    } else if (context == CaptureLensPositionContext) {  // 对焦值
//        [JYSeptManager sharedManager].focusValue = self.captureDevice.lensPosition;
    } else if (context == DeviceWhiteBalanceGains) {  // 白平衡
//        NSLog(@"r = %f, g = %f, b = %f", self.captureDevice.deviceWhiteBalanceGains.redGain, self.captureDevice.deviceWhiteBalanceGains.greenGain, self.captureDevice.deviceWhiteBalanceGains.blueGain);
//        [JYSeptManager sharedManager].temperatureAndTintValues = [self.captureDevice temperatureAndTintValuesForDeviceWhiteBalanceGains:self.captureDevice.deviceWhiteBalanceGains];
        
    }
    else if (context == DeviceExposureTargetBias) {   // 曝光补偿
        
//        [JYSeptManager sharedManager].baisValue = self.captureDevice.exposureTargetBias;
    }
    else if (context == DeviceExposureISO) {   // 感光度
        
//        [JYSeptManager sharedManager].ISOValue = self.captureDevice.ISO;
    }
    
    else if (context == DeviceExposureOffset) {   // 曝光偏移
        
//        [JYSeptManager sharedManager].offsetValue = self.captureDevice.exposureTargetOffset;
    }
    else if (context == DeviceExposureDuration) {   // 曝光时间
        
//        [JYSeptManager sharedManager].timeValue = CMTimeGetSeconds(self.captureDevice.exposureDuration);
    }
    // 1.监听会话是否开启
    else if ( context == SessionRunningContext ) {
        BOOL isSessionRunning = [change[NSKeyValueChangeNewKey] boolValue];
        
        dispatch_async( dispatch_get_main_queue(), ^{
            // 只有当设备有多个摄像头时才有能力改变相机
            //            self.cameraButton.enabled = isSessionRunning && ( [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo].count > 1 );
            //            self.recordButton.enabled = isSessionRunning;
            //            self.stillButton.enabled = isSessionRunning;
        } );
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark Orientation
- (BOOL)shouldAutorotate
{
    //当在录像时禁止旋转
    return ! self.movieFileOutput.isRecording;
}

// （在avcapturedevice实例检测到视频领域的一个重大改变发送通知）-- 监听
- (void)subjectAreaDidChange:(NSNotification *)notification
{
    //    CGPoint devicePoint = CGPointMake( 0.5, 0.5 );
    //    [self focusWithMode:AVCaptureFocusModeContinuousAutoFocus exposeWithMode:AVCaptureExposureModeContinuousAutoExposure atDevicePoint:devicePoint monitorSubjectAreaChange:NO];
}

// 通知对象是遇到运行时错误的avcapturesession实例
- (void)sessionRuntimeError:(NSNotification *)notification
{
    NSError *error = notification.userInfo[AVCaptureSessionErrorKey];
    // 捕追会话运行时错误
    NSLog( @"Capture session runtime error: %@", error );
    
    // 如果媒体服务被重置，自动尝试重新启动会话运行，知道运行成功
    if ( error.code == AVErrorMediaServicesWereReset ) {
        dispatch_async( self.sessionQueue, ^{
            if ( self.isSessionRunning ) {
                [self.session startRunning];
                self.sessionRunning = self.session.isRunning;
            }
            else {
                dispatch_async( dispatch_get_main_queue(), ^{
#warning  捕追会话运行时错误的时候显示继续按钮
                    [self interruptedSession];
                } );
            }
        } );
    }
    else {
#warning 同上
        //        self.resumeButton.hidden = NO;
        [self interruptedSession];
    }
}

- (void)interruptedSession
{
    dispatch_async( self.sessionQueue, ^{
        // 当打电话的时候会话无法启动
        [self.session startRunning];
        self.sessionRunning = self.session.isRunning;
        if ( ! self.session.isRunning ) {
//            dispatch_async( dispatch_get_main_queue(), ^{
//                NSString *message = NSLocalizedString( @"Unable to resume", @"Alert message when unable to resume the session running" );
//                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"AVCam" message:message preferredStyle:UIAlertControllerStyleAlert];
//                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString( @"OK", @"Alert OK button" ) style:UIAlertActionStyleCancel handler:nil];
//                [alertController addAction:cancelAction];
//                [self presentViewController:alertController animated:YES completion:nil];
//            } );
        }
        else {
            dispatch_async( dispatch_get_main_queue(), ^{
//                self.resumeButton.hidden = YES;
            } );
        }
    } );
}

// 5.在avcapturesession的实例中断的时候发送通知
- (void)sessionWasInterrupted:(NSNotification *)notification
{
    
}

// 6.在avcapturesession的实例不再中断的时候发送通知
- (void)sessionInterruptionEnded:(NSNotification *)notification
{
    
}

// 当打电话的时候会话无法启动
- (void)resumeInterruptedSession
{
    dispatch_async( self.sessionQueue, ^{
        // 当打电话的时候会话无法启动
        [self.session startRunning];
        self.sessionRunning = self.session.isRunning;
        if ( ! self.session.isRunning ) {
            dispatch_async( dispatch_get_main_queue(), ^{
#warning 弹框显示 --- 代理
                //                NSString *message = NSLocalizedString( @"Unable to resume", @"Alert message when unable to resume the session running" );
                //                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"AVCam" message:message preferredStyle:UIAlertControllerStyleAlert];
                //                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString( @"OK", @"Alert OK button" ) style:UIAlertActionStyleCancel handler:nil];
                //                [alertController addAction:cancelAction];
                //                [self presentViewController:alertController animated:YES completion:nil];
            } );
        }
        else {
            dispatch_async( dispatch_get_main_queue(), ^{
                //                self.resumeButton.hidden = YES;
            } );
        }
    } );
}

// 拍照
- (void)snapStillImage
{
    dispatch_async( self.sessionQueue, ^{
        AVCaptureConnection *connection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
        AVCaptureVideoPreviewLayer *previewLayer = (AVCaptureVideoPreviewLayer *)self.previewView.layer;
        
        // Update the orientation on the still image output video connection before capturing.
        connection.videoOrientation = previewLayer.connection.videoOrientation;
        
        // 闪关灯设置自动捕获
        [JYCameraManager setFlashMode:AVCaptureFlashModeAuto forDevice:self.videoDeviceInput.device];
        
        // 捕捉静止图像
        [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:connection completionHandler:^( CMSampleBufferRef imageDataSampleBuffer, NSError *error ) {
            
            if ( imageDataSampleBuffer ) {
                // 未保留样本缓冲区，在将静态图像保存到照片库之前，先创建图像数据
                NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
//                [self userGPSinfoSaveImageWith:imageData];
                
                [self cameraManagerSaveImageWithData:imageData];
            }
            else {
                // 无法捕捉静止图像
                NSLog( @"Could not capture still image: %@", error );
            }
        }];
    } );
}

/** 分级捕捉 */
- (void)classificationCapture
{
    dispatch_async(self.sessionQueue, ^{
        
        // 在拍摄前更新录像输出视频连线的方向
        AVCaptureConnection *connection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
        AVCaptureVideoPreviewLayer *previewLayer = (AVCaptureVideoPreviewLayer *)self.previewView.layer;
        
        // Update the orientation on the still image output video connection before capturing.
        connection.videoOrientation = previewLayer.connection.videoOrientation;
        
        NSMutableArray *mArr = [NSMutableArray array];
        for (NSString *mStr in @[@"-1.0", @"0.0", @"1.0"]) {
            
            AVCaptureBracketedStillImageSettings *stillImageSettings = [AVCaptureAutoExposureBracketedStillImageSettings autoExposureSettingsWithExposureTargetBias:[mStr floatValue]];
            
            [mArr addObject:stillImageSettings];
        }
//        __block CGFloat count = mArr.count;
        
        [self.stillImageOutput  captureStillImageBracketAsynchronouslyFromConnection:connection withSettingsArray:mArr completionHandler:^(CMSampleBufferRef sampleBuffer, AVCaptureBracketedStillImageSettings *stillImageSettings, NSError *error) {
            
            if ( sampleBuffer ) {
                // 未保留样本缓冲区，在将静态图像保存到照片库之前，先创建图像数据
                NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:sampleBuffer];
                //                [self userGPSinfoSaveImageWith:imageData];
                
                [self cameraManagerSaveImageWithData:imageData];
            }
            else {
                // 无法捕捉静止图像
                NSLog( @"Could not capture still image: %@", error );
            }
        }];
    });
}

/** 把GPS信息保存到EXIF中 */
- (void)userGPSinfoSaveImageWith:(NSData *)data
{
    CGImageSourceRef imgSource = CGImageSourceCreateWithData((__bridge_retained CFDataRef)data, NULL);
    
    // 获取图片所有的云数据
    NSDictionary *allDict = (__bridge NSDictionary *)CGImageSourceCopyPropertiesAtIndex(imgSource, 0, NULL);
    
    // 使元数据字典易变的所以我们可以将属性添加到它
    NSMutableDictionary *metadataAsMutable = [allDict mutableCopy];
    
    NSMutableDictionary *EXIFDict = [[metadataAsMutable objectForKey:(NSString *)kCGImagePropertyExifDictionary] mutableCopy];
    
    NSMutableDictionary *GPSDict = [[metadataAsMutable objectForKey:(NSString *)kCGImagePropertyGPSDictionary] mutableCopy];
    
    NSMutableDictionary *RAMDict = [[metadataAsMutable objectForKey:(NSString *)kCGImagePropertyRawDictionary] mutableCopy];
    
    if (!EXIFDict) {
        EXIFDict = [[NSMutableDictionary dictionary] init];
    }
    if (!GPSDict) {
        GPSDict = [[NSMutableDictionary dictionary] init];
    }
    if (!RAMDict) {
        RAMDict = [[NSMutableDictionary dictionary] init];
    }
    
    [GPSDict setObject:[NSNumber numberWithFloat:37.795] forKey:(NSString*)kCGImagePropertyGPSLatitude];
    
    [GPSDict setObject:@"N" forKey:(NSString*)kCGImagePropertyGPSLatitudeRef];
    
    [GPSDict setObject:[NSNumber numberWithFloat:122.410]
                forKey:(NSString*)kCGImagePropertyGPSLongitude];
    
    [GPSDict setObject:@"W" forKey:(NSString*)kCGImagePropertyGPSLongitudeRef];
    
    [GPSDict setObject:@"2012:10:18"
                forKey:(NSString*)kCGImagePropertyGPSDateStamp];
    
    [GPSDict setObject:[NSNumber numberWithFloat:300]
                forKey:(NSString*)kCGImagePropertyGPSImgDirection];
    
    [GPSDict setObject:[NSNumber numberWithFloat:37.795]
                forKey:(NSString*)kCGImagePropertyGPSDestLatitude];
    
    [GPSDict setObject:@"N" forKey:(NSString*)kCGImagePropertyGPSDestLatitudeRef];
    
    [GPSDict setObject:[NSNumber numberWithFloat:122.410]
                forKey:(NSString*)kCGImagePropertyGPSDestLongitude];
    
    [GPSDict setObject:@"W" forKey:(NSString*)kCGImagePropertyGPSDestLongitudeRef];
    
    [EXIFDict setObject:@"[S.D.] kCGImagePropertyExifUserComment"
                 forKey:(NSString *)kCGImagePropertyExifUserComment];
    
    [EXIFDict setObject:[NSNumber numberWithFloat:69.999]
                 forKey:(NSString*)kCGImagePropertyExifSubjectDistance];
    
    
    //Add the modified Data back into the image’s metadata
    [metadataAsMutable setObject:EXIFDict forKey:(NSString *)kCGImagePropertyExifDictionary];
    [metadataAsMutable setObject:GPSDict forKey:(NSString *)kCGImagePropertyGPSDictionary];
    [metadataAsMutable setObject:RAMDict forKey:(NSString *)kCGImagePropertyRawDictionary];
    
    
    CFStringRef UTI = CGImageSourceGetType(imgSource); //this is the type of image (e.g., public.jpeg)
    
    //this will be the data CGImageDestinationRef will write into
    NSMutableData *newImageData = [NSMutableData data];
    
    CGImageDestinationRef destination = CGImageDestinationCreateWithData((__bridge CFMutableDataRef)newImageData, UTI, 1, NULL);
    
    if(!destination)
        NSLog(@"***Could not create image destination ***");
    
    //add the image contained in the image source to the destination, overidding the old metadata with our modified metadata
    CGImageDestinationAddImageFromSource(destination, imgSource, 0, (__bridge CFDictionaryRef) metadataAsMutable);
    
    //tell the destination to write the image data and metadata into our data object.
    //It will return false if something goes wrong
    BOOL success = NO;
    success = CGImageDestinationFinalize(destination);
    
    if(!success)
        NSLog(@"***Could not create data from image destination ***");
    
    CIImage *testImage = [CIImage imageWithData:newImageData];
    NSDictionary *propDict = [testImage properties];
    NSLog(@"Final properties %@", propDict);
}

/** 慢动作视频拍摄 */
- (void)configureCameraForHighestFrameRate:(AVCaptureDevice *)device
{
    AVCaptureDeviceFormat *bestFormat = nil;
    AVFrameRateRange *bestFrameRateRange = nil;
    for ( AVCaptureDeviceFormat *format in [device formats] ) {
        for ( AVFrameRateRange *range in format.videoSupportedFrameRateRanges ) {
            
            if ( range.maxFrameRate == 120.000000 ) {
                bestFormat = format;
                bestFrameRateRange = range;
            }
        }
    }
    if ( bestFormat ) {
        if ( [device lockForConfiguration:NULL] == YES ) {
            device.activeFormat = bestFormat;
            device.activeVideoMinFrameDuration = bestFrameRateRange.minFrameDuration;
            device.activeVideoMaxFrameDuration = bestFrameRateRange.minFrameDuration;
            //            NSLog(@"%@", device.activeVideoMaxFrameDuration);
            [device unlockForConfiguration];
        }
    }
}

// 录像
- (void)videoRecoding
{
    dispatch_async( self.sessionQueue, ^{
        if ( ! self.movieFileOutput.isRecording ) {
            if ( [UIDevice currentDevice].isMultitaskingSupported ) {
                // 这里需要设置背景任务.  the -[captureOutput:didFinishRecordingToOutputFileAtURL:fromConnections:error:]
                // 回调不接收，直到相机返回前台，除非你请求后台执行
                // 这也保证有时间把相片保存到相机库
                // To conclude this background execution, -endBackgroundTask is called in
                // -[captureOutput:didFinishRecordingToOutputFileAtURL:fromConnections:error:] after the recorded file has been saved.
                self.backgroundRecordingID = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
            }
            
            // 在拍摄前更新录像输出视频连线的方向
            AVCaptureConnection *connection = [self.movieFileOutput connectionWithMediaType:AVMediaTypeVideo];
            AVCaptureVideoPreviewLayer *previewLayer = (AVCaptureVideoPreviewLayer *)self.previewView.layer;
            connection.videoOrientation = previewLayer.connection.videoOrientation;
            
            // 关上闪关灯
            [JYCameraManager setFlashMode:AVCaptureFlashModeOff forDevice:self.videoDeviceInput.device];
            
            // 开始记录到临时文件
            NSString *outputFileName = [NSProcessInfo processInfo].globallyUniqueString;
            NSString *outputFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:[outputFileName stringByAppendingPathExtension:@"mov"]];
            [self.movieFileOutput startRecordingToOutputFileURL:[NSURL fileURLWithPath:outputFilePath] recordingDelegate:self];
        }
        else {
            [self.movieFileOutput stopRecording];
        }
    } );
}

/**
    AVCaptureDevicePositionUnspecified  指示设备相对于系统硬件的位置未指定。
    AVCaptureDevicePositionBack         后置摄像头
    AVCaptureDevicePositionFront        前置摄像头
 */

/** 切换摄像头 */
- (void)switchCamera
{
    dispatch_async( self.sessionQueue, ^{
        AVCaptureDevice *currentVideoDevice = self.videoDeviceInput.device;
        AVCaptureDevicePosition preferredPosition = AVCaptureDevicePositionUnspecified;
        AVCaptureDevicePosition currentPosition = currentVideoDevice.position;
        
        switch ( currentPosition )
        {
            case AVCaptureDevicePositionUnspecified:
            case AVCaptureDevicePositionFront:
                preferredPosition = AVCaptureDevicePositionBack;
                break;
            case AVCaptureDevicePositionBack:
                preferredPosition = AVCaptureDevicePositionFront;
                break;
        }
        
        AVCaptureDevice *videoDevice = [JYCameraManager deviceWithMediaType:AVMediaTypeVideo preferringPosition:preferredPosition];
        
        AVCaptureDeviceInput *videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:nil];
        
        [self.session beginConfiguration];
        
        // 删除现有的设备信息，因为不能同时支持前摄像头和摄像头
        [self.session removeInput:self.videoDeviceInput];
        
        if ( [self.session canAddInput:videoDeviceInput] ) {
            [[NSNotificationCenter defaultCenter] removeObserver:self name:AVCaptureDeviceSubjectAreaDidChangeNotification object:currentVideoDevice];
            
            [JYCameraManager setFlashMode:AVCaptureFlashModeAuto forDevice:videoDevice];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subjectAreaDidChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:videoDevice];
            
            [self.session addInput:videoDeviceInput];
            self.videoDeviceInput = videoDeviceInput;
        }
        else {
            [self.session addInput:self.videoDeviceInput];
        }
        
        AVCaptureConnection *connection = [self.movieFileOutput connectionWithMediaType:AVMediaTypeVideo];
        if ( connection.isVideoStabilizationSupported ) {
            connection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeAuto;
        }
        
        [self.session commitConfiguration];
    } );
}

/** 设置相机拍摄质量 */
- (void)cameraManagerEffectqualityWithTag:(NSInteger)tag
{
    dispatch_async( self.sessionQueue, ^{
        
        NSError *error = nil;
        
        AVCaptureDevice *videoDevice = [JYCameraManager deviceWithMediaType:AVMediaTypeVideo preferringPosition:AVCaptureDevicePositionBack];
        AVCaptureDeviceInput *videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
        
        if ( ! videoDeviceInput ) {
            NSLog( @"Could not create video device input: %@", error );
        }
        
        [self.session beginConfiguration];
        
        NSString *sessionPreset = nil;
        
        switch (tag) {
               
            case 90:
                sessionPreset = AVCaptureSessionPresetHigh;
                break;
            case 91:
                sessionPreset = AVCaptureSessionPreset640x480;
                break;
            case 92:
                sessionPreset = AVCaptureSessionPreset1280x720;
                break;
            case 93:
                sessionPreset = AVCaptureSessionPreset3840x2160;
                break;
            default:
                sessionPreset = AVCaptureSessionPresetHigh;
                break;
        }
        
        self.session.sessionPreset = sessionPreset;
        
        if ( [self.session canAddInput:videoDeviceInput] ) {
            [self.session addInput:videoDeviceInput];
            self.videoDeviceInput = videoDeviceInput;
        }
        
        [self.session commitConfiguration];
    });
}

// 设置闪关灯
- (void)setEnableFlash:(BOOL)enableFlash
{
    _enableFlash = enableFlash;
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch] && [device hasFlash])
    {
        [device lockForConfiguration:nil];
        if (enableFlash) { [device setTorchMode:AVCaptureTorchModeOn]; }
        else { [device setTorchMode:AVCaptureTorchModeOff]; }
        [device unlockForConfiguration];
    }
}

- (void)setEnableBack:(BOOL)enableBack
{
    _enableBack = enableBack;
    
    dispatch_async( self.sessionQueue, ^{
        
        // 设置相机摄像头还没有设定
        AVCaptureDevicePosition preferredPosition = AVCaptureDevicePositionUnspecified;
        
        // 获取当前设备的摄像头位置
        //        AVCaptureDevicePosition currentPosition = self.videoDeviceInput.device.position;
        //        NSLog(@"%ld", (long)currentPosition);
        
        switch ( [[NSNumber numberWithBool:_enableBack] integerValue] )
        {
            case 0:
                preferredPosition = AVCaptureDevicePositionBack;
                break;
            case 1:
                preferredPosition = AVCaptureDevicePositionFront;
                break;
            default:
                preferredPosition = AVCaptureDevicePositionUnspecified;
                break;
        }
        
        AVCaptureDevice *videoDevice = [JYCameraManager deviceWithMediaType:AVMediaTypeVideo preferringPosition:preferredPosition];
        AVCaptureDeviceInput *videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:nil];
        
        [self.session beginConfiguration];
        
        // 删除现有的设备信息，因为不能同时支持前摄像头和摄像头
        [self.session removeInput:self.videoDeviceInput];
        
        if ( [self.session canAddInput:videoDeviceInput] ) {
            [[NSNotificationCenter defaultCenter] removeObserver:self name:AVCaptureDeviceSubjectAreaDidChangeNotification object:self.videoDeviceInput.device];
            
            [JYCameraManager setFlashMode:AVCaptureFlashModeAuto forDevice:videoDevice];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(subjectAreaDidChange:) name:AVCaptureDeviceSubjectAreaDidChangeNotification object:videoDevice];
            
            [self.session addInput:videoDeviceInput];
            self.videoDeviceInput = videoDeviceInput;
        }
        else {
            [self.session addInput:self.videoDeviceInput];
        }
        
        AVCaptureConnection *connection = [self.movieFileOutput connectionWithMediaType:AVMediaTypeVideo];
        if ( connection.isVideoStabilizationSupported ) {
            connection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeAuto;
        }
        
        [self.session commitConfiguration];
    } );
}

- (void)videoDidEndRecodeing
{
    [self.movieFileOutput stopRecording];
}

#pragma mark -------------------------> 分级捕捉
- (void)hierarchicalCapture
{
    dispatch_async(self.sessionQueue, ^{
        
        
    });
}

#pragma mark Device Configuration
- (void)focusWithMode:(AVCaptureFocusMode)focusMode exposeWithMode:(AVCaptureExposureMode)exposureMode atDevicePoint:(CGPoint)point monitorSubjectAreaChange:(BOOL)monitorSubjectAreaChange isAutoFocus:(BOOL)isOnAuto
{
	dispatch_async( self.sessionQueue, ^{
		AVCaptureDevice *device = self.videoDeviceInput.device;
		NSError *error = nil;
		if ( [device lockForConfiguration:&error] ) {
			// Setting (focus/exposure)PointOfInterest alone does not initiate a (focus/exposure) operation.
            // 设置对焦和曝光
			// Call -set(Focus/Exposure)Mode: to apply the new point of interest.
            // 定点聚焦
//            NSLog(@"isOnAuto = %d", isOnAuto);
//            if (!isOnAuto) {
//                if ( device.isFocusPointOfInterestSupported && [device isFocusModeSupported:focusMode] ) {
//                    device.focusPointOfInterest = point;
//                    device.focusMode = focusMode;
//                }
//            }

            // 定点设置曝光
			if ( device.isExposurePointOfInterestSupported && [device isExposureModeSupported:exposureMode] ) {
				device.exposurePointOfInterest = point;
				device.exposureMode = exposureMode;
			}

			device.subjectAreaChangeMonitoringEnabled = monitorSubjectAreaChange;
			[device unlockForConfiguration];
		}
		else {
			NSLog( @"Could not lock device for configuration: %@", error );
		}
	} );
}

/** 设置相机的曝光模式 */
- (void)exposeMode:(AVCaptureExposureMode)exposureMode
{
    NSError *error = nil;
    
    if ([self.captureDevice lockForConfiguration:&error]) {
        
        if ( self.captureDevice.isExposurePointOfInterestSupported && [self.captureDevice isExposureModeSupported:exposureMode] ) {
            self.captureDevice.exposureMode = exposureMode;
        }
        
        [self.captureDevice unlockForConfiguration];
        
    } else
    {
        NSLog(@"设置曝光失败");
    }
}

/** 设置相机的白平衡模式 */
- (void)whiteBalanceMode:(AVCaptureWhiteBalanceMode)whiteBalanceMode
{
    NSError *error = nil;
    
    if ([self.captureDevice lockForConfiguration:&error]) {
        
        if ([self.captureDevice isWhiteBalanceModeSupported:whiteBalanceMode] ) {
            self.captureDevice.whiteBalanceMode = whiteBalanceMode;
        }
        
        [self.captureDevice unlockForConfiguration];
        
    } else
    {
        NSLog(@"设置白平衡失败");
    }
}

/** 设置相机的HDR */
- (void)cameraManagerSetVideoHDR
{
    NSError *error = nil;
    
    if ([self.captureDevice lockForConfiguration:&error]) {
        
        self.captureDevice.automaticallyAdjustsVideoHDREnabled = !self.captureDevice.automaticallyAdjustsVideoHDREnabled;
        
        [self.captureDevice unlockForConfiguration];
        
    } else
    {
        NSLog(@"设置白平衡失败");
    }
}

/**
     PHAuthorizationStatusNotDetermined = 0, // 用户尚未对该应用程序作出选择
     PHAuthorizationStatusRestricted,        // 此应用程序未授权访问照片数据。
     PHAuthorizationStatusDenied,            // 用户已明确否认了这一应用程序访问的照片数据。
     PHAuthorizationStatusAuthorized         // 用户已授权此应用程序访问照片数据。
 */
- (void)cameraManagerSaveImageWithData:(NSData *)imageData
{
    [PHPhotoLibrary requestAuthorization:^( PHAuthorizationStatus status ) {
        if ( status == PHAuthorizationStatusAuthorized ) {
            // To preserve the metadata, we create an asset from the JPEG NSData representation.
            // 创建JPEG类型数据保存云数据
            // In iOS 9, we can use -[PHAssetCreationRequest addResourceWithType:data:options].
            // In iOS 8, we save the image to a temporary file and use +[PHAssetChangeRequest creationRequestForAssetFromImageAtFileURL:].
            if ( [PHAssetCreationRequest class] ) {
                [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                    [[PHAssetCreationRequest creationRequestForAsset] addResourceWithType:PHAssetResourceTypePhoto data:imageData options:nil];
                } completionHandler:^( BOOL success, NSError *error ) {
                    if ( ! success ) {
                        // 保存图像到照片库时出错
                        NSLog( @"Error occurred while saving image to photo library: %@", error );
                    }
                }];
            }
            else {
                NSString *temporaryFileName = [NSProcessInfo processInfo].globallyUniqueString;
                NSString *temporaryFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:[temporaryFileName stringByAppendingPathExtension:@"jpg"]];
                NSURL *temporaryFileURL = [NSURL fileURLWithPath:temporaryFilePath];
                
                [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                    NSError *error = nil;
                    [imageData writeToURL:temporaryFileURL options:NSDataWritingAtomic error:&error];
                    
                    if ( error ) {
                        // 将图像数据写入临时文件时出错
                        NSLog( @"Error occured while writing image data to a temporary file: %@", error );
                    }
                    else {
                        [PHAssetChangeRequest creationRequestForAssetFromImageAtFileURL:temporaryFileURL];
                    }
                } completionHandler:^( BOOL success, NSError *error ) {
                    
                    if ( ! success ) {
                        // 保存图像到照片库时出错
                        NSLog( @"Error occurred while saving image to photo library: %@", error );
                    }
                    
                    // 删除临时文件
                    [[NSFileManager defaultManager] removeItemAtURL:temporaryFileURL error:nil];
                }];
            }
        }
    }];
}


#pragma mark File Output Recording Delegate

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didStartRecordingToOutputFileAtURL:(NSURL *)fileURL fromConnections:(NSArray *)connections
{
    // 启动录像按钮让用户停止记录
    NSLog(@"开始录像");
}

- (void)captureOutput:(AVCaptureFileOutput *)captureOutput didFinishRecordingToOutputFileAtURL:(NSURL *)outputFileURL fromConnections:(NSArray *)connections error:(NSError *)error
{
    [self cameraManagerVideoSaveURL:outputFileURL];
    
    // Note that currentBackgroundRecordingID is used to end the background task associated with this recording.
    // This allows a new recording to be started, associated with a new UIBackgroundTaskIdentifier, once the movie file output's isRecording property
    // is back to NO — which happens sometime after this method returns.
    // Note: Since we use a unique file path for each recording, a new recording will not overwrite a recording currently being saved.
    UIBackgroundTaskIdentifier currentBackgroundRecordingID = self.backgroundRecordingID;
    self.backgroundRecordingID = UIBackgroundTaskInvalid;
    
    dispatch_block_t cleanup = ^{
        [[NSFileManager defaultManager] removeItemAtURL:outputFileURL error:nil];
        if ( currentBackgroundRecordingID != UIBackgroundTaskInvalid ) {
            [[UIApplication sharedApplication] endBackgroundTask:currentBackgroundRecordingID];
        }
    };
    
    BOOL success = YES;
    
    if ( error ) {
        NSLog( @"Movie file finishing error: %@", error );
        success = [error.userInfo[AVErrorRecordingSuccessfullyFinishedKey] boolValue];
        
        // 告诉用户保存失败
        [self cameraManagerSaveVideoError];
    }
    if ( success ) {
        
        // 检查授权状态
        [PHPhotoLibrary requestAuthorization:^( PHAuthorizationStatus status ) {
            if ( status == PHAuthorizationStatusAuthorized ) {
                // 保存电影文件到照片库和清理
                [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                    // In iOS 9 and later, it's possible to move the file into the photo library without duplicating the file data.
                    // This avoids using double the disk space during save, which can make a difference on devices with limited free disk space.
                    if ( [PHAssetResourceCreationOptions class] ) {
                        PHAssetResourceCreationOptions *options = [[PHAssetResourceCreationOptions alloc] init];
                        options.shouldMoveFile = YES;
                        PHAssetCreationRequest *changeRequest = [PHAssetCreationRequest creationRequestForAsset];
                        [changeRequest addResourceWithType:PHAssetResourceTypeVideo fileURL:outputFileURL options:options];
                    }
                    else {
                        [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:outputFileURL];
                    }
                } completionHandler:^( BOOL success, NSError *error ) {
                    [self cameraManagerVideoDidSaveLSuccess:success];
                    cleanup();
                }];
            }
            else {
                cleanup();
            }
        }];
    }
    else {
        cleanup();
    }
}

/**
   保存视频失败
 */
- (void)cameraManagerSaveVideoError
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cameraManagerSaveVideoError)]) {
        [self.delegate cameraManagerSaveVideoError];
    }
}

/** 获取视频保存的URL */
- (void)cameraManagerVideoSaveURL:(NSURL *)outputFileURL
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cameraManagerVideoSaveURL:)]) {
        [self.delegate cameraManagerVideoSaveURL:outputFileURL];
    }
}

/** 获取视频是否保存成功 */
- (void)cameraManagerVideoDidSaveLSuccess:(BOOL)success
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cameraManagerVideoDidSaveLSuccess:)]) {
        [self.delegate cameraManagerVideoDidSaveLSuccess:success];
    }
}


+ (AVCaptureDevice *)deviceWithMediaType:(NSString *)mediaType preferringPosition:(AVCaptureDevicePosition)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:mediaType];
    AVCaptureDevice *captureDevice = devices.firstObject;
    
    for ( AVCaptureDevice *device in devices ) {
        if ( device.position == position ) {
            captureDevice = device;
            break;
        }
    }
    
    return captureDevice;
}

+ (void)setFlashMode:(AVCaptureFlashMode)flashMode forDevice:(AVCaptureDevice *)device
{
    if ( device.hasFlash && [device isFlashModeSupported:flashMode] ) {
        NSError *error = nil;
        if ( [device lockForConfiguration:&error] ) {
            device.flashMode = flashMode;
            [device unlockForConfiguration];
        }
        else {
            NSLog( @"Could not lock device for configuration: %@", error );
        }
    }
}



@end
