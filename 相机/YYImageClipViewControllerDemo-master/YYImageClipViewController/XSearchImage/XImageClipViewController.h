//
//  XImageClipViewController.h
//  VeryFitPlus
//
//  Created by xiongze on 2018/5/11.
//  Copyright © 2018年 aiju_huangjing1. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XImageClipViewController;

@protocol XImageClipDelegate <NSObject>

- (void)imageCropper:(XImageClipViewController *)clipViewController didFinished:(UIImage *)editedImage;
- (void)imageCropperDidCancel:(XImageClipViewController *)clipViewController;

@end

@interface XImageClipViewController : UIViewController

@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, weak) id<XImageClipDelegate> delegate;
@property (nonatomic, assign) CGRect cropFrame;

- (instancetype)initWithImage:(UIImage *)originalImage cropFrame:(CGRect)cropFrame limitScaleRatio:(NSInteger)limitRatio;

@end
