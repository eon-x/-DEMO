//
//  AppDelegate.m
//  Twitter_test
//
//  Created by 柴智权 on 2017/12/18.
//  Copyright © 2017年 xiongze. All rights reserved.
//

#import "AppDelegate.h"
#import <TwitterKit/TwitterKit.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //Twitter 初始化
    NSMutableDictionary *twitterKeys;
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Twitter" ofType:@"plist"];
    twitterKeys = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    [[Twitter sharedInstance] startWithConsumerKey:[twitterKeys objectForKey:@"consumer_key"] consumerSecret:[twitterKeys objectForKey:@"consumer_secret"]];
        
    return YES;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 90000

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    
    BOOL handled = [[Twitter sharedInstance] application:application openURL:url options:options];
    
    // Add any custom logic here.
    return handled;
}

#else

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    BOOL handled = [[Twitter sharedInstance] application:application openURL:url options:annotation];
    
    // Add any custom logic here.
    return handled;
}

#endif

@end
