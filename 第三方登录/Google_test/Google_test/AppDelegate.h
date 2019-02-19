//
//  AppDelegate.h
//  Google_test
//
//  Created by 柴智权 on 2017/12/18.
//  Copyright © 2017年 xiongze. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

/*
 
 1.导入框架和plist文件
 2.添加URL types信息
 3.appdelegate.m代码添加
 4.viewcontroller.m代码添加
 5. Other Linker Flags 添加 -ObjC
 6.SafariServices.framework   SystemConfiguration.framework添加
 
 
 */


/*
 
 坑1.[__NSDictionaryI gtm_httpArgumentsString]: unrecognized selector sent to instance 0x60000026ffc0
 Other Linker Flags 添加 -ObjC
 
 
 
 */






