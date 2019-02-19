//
//  AppDelegate.m
//  Google_test
//
//  Created by 柴智权 on 2017/12/18.
//  Copyright © 2017年 xiongze. All rights reserved.
//

#import "AppDelegate.h"
#import <GoogleSignIn/GoogleSignIn.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

// DO NOT USE THIS CLIENT ID. IT WILL NOT WORK FOR YOUR APP.
// Please use the client ID created for you by Google.
static NSString * const kClientID =
@"296848218022-3pd2ccssnk4dnch0u44ugo06iobbdqi9.apps.googleusercontent.com";


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // Set app's client ID for |GIDSignIn|.
    [GIDSignIn sharedInstance].clientID = kClientID;
    
    return YES;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 90000

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    
    BOOL handled = [[GIDSignIn sharedInstance] handleURL:url
                                       sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                              annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
    // Add any custom logic here.
    return handled;
}

#else

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    BOOL handled = [[GIDSignIn sharedInstance] handleURL:url
                                       sourceApplication:sourceApplication
                                              annotation:annotation];

    // Add any custom logic here.
    return handled;
}

#endif




@end
