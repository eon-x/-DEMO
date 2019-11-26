//
//  AppDelegate.m
//  googleMap
//
//  Created by 柴智权 on 2017/12/20.
//  Copyright © 2017年 xiongze. All rights reserved.
//

#import "AppDelegate.h"

@import GoogleMaps;

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //只使用地图，这个key随便设置，
//    [GMSServices provideAPIKey:@"AIzaSyDl32GgsHp_L1Horam9GqVIbUUiN1WY1nk"];//appTest
//    [GMSServices provideAPIKey:@"AIzaSyBs03QLxCQ6EA90lB5I7qwM_TVmVumRd5A"];//xoing2
    [GMSServices provideAPIKey:@"AIzaSyDrkNGCp5pKP7vGcc2NvfkBBiRe7AUAxi0"];//xoing2

    return YES;
}


@end
