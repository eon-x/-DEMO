//
//  JKAppDelegate.m
//  JKDataHelper
//
//  Created by HHL110120 on 02/28/2017.
//  Copyright (c) 2017 HHL110120. All rights reserved.
//

#import "JKAppDelegate.h"
#import "JKViewController.h"
@implementation JKAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    JKViewController *jkVC = [JKViewController new];
    UINavigationController *naVC = [[UINavigationController alloc] initWithRootViewController:jkVC];
    self.window.rootViewController = naVC;
    return YES;
}

@end
