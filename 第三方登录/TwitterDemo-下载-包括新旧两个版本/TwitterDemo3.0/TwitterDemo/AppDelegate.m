//
//  AppDelegate.m
//  TwitterDemo
//
//  Created by zpp on 17/7/13.
//  Copyright © 2017年 txtws. All rights reserved.
//

#import "AppDelegate.h"
#import <TwitterKit/TwitterKit.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [[Twitter sharedInstance] startWithConsumerKey:@"guLppo4I9ck7KLphYmalSeaKt" consumerSecret:@"xWpL85O3d3j6L0xTXC17jeE7p4nzvfGQtC8oCJjXXDGQRLsZFh"];
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
//    return [[Twitter sharedInstance] application:app openURL:url options:options];
    if ([[Twitter sharedInstance] application:app openURL:url options:options]) {
        return YES;
    }
    // If you handle other (non Twitter Kit) URLs elsewhere in your app, return YES. Otherwise
    return NO;
}



@end
