//
//  AppDelegate.h
//  DOSigninFW
//
//  Created by 柴智权 on 2017/12/20.
//  Copyright © 2017年 xiongze. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@end

/*
 
 1.添加FW ，添加plist文件信息    CFBundleURLTypes FacebookAppID FacebookDisplayName LSApplicationQueriesSchemes ；
 2.添加-ObjC，报错；
 3.添加AVFoundation.framework CoreMedia.framework解决；
 出现：
 Undefined symbols for architecture x86_64:
 "_OBJC_CLASS_$_AVAssetImageGenerator", referenced from:
 objc-class-ref in TwitterKit(TWTRSharedComposerWrapper.o)
 这种错误，是由于没有引入AVAssetImageGenerator对应框架导致，引入即可；
 4.添加SystemConfiguration.framework  SafariServices.framework
 5.appdelegate.m代码添加
 
 
 */
