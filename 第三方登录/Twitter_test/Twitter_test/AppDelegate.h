//
//  AppDelegate.h
//  Twitter_test
//
//  Created by 柴智权 on 2017/12/18.
//  Copyright © 2017年 xiongze. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@end


/*
 1.导入框架
 2.引入头文件
 3.初始化
 4.修改plist文件
 <key>CFBundleURLTypes</key>
 <array>
 <dict>
 <key>CFBundleURLSchemes</key>
 <array>
 <string>twitterkit-<consumerKey></string>
 </array>
 </dict>
 </array>
 <key>LSApplicationQueriesSchemes</key>
 <array>
 <string>twitter</string>
 <string>twitterauth</string>
 </array>
 
 5.实现登录退出相关代码
 
 坑
 1.callback URL 一定要填
 2.手机号码不能登录
 
 */
