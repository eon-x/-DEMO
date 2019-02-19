//
//  AppDelegate+ThirdLogin.m
//  DOSigninFW
//
//  Created by xiongze on 2017/12/21.
//  Copyright © 2017年 xiongze. All rights reserved.
//

#import "AppDelegate+ThirdLogin.h"
#import <TwitterKit/TwitterKit.h>
#import <GoogleSignIn/GoogleSignIn.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

#import "DOSigninManagerV2.h"

@implementation AppDelegate (ThirdLogin)


- (void)thirdLoginApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //Twitter 初始化
    NSMutableDictionary *twitterKeys;
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Twitter" ofType:@"plist"];
    twitterKeys = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    [[Twitter sharedInstance] startWithConsumerKey:[twitterKeys objectForKey:@"consumer_key"] consumerSecret:[twitterKeys objectForKey:@"consumer_secret"]];
    
    //google
    NSMutableDictionary *googleKeys;
    NSString *googlePlistPath = [[NSBundle mainBundle] pathForResource:@"GoogleService-Info" ofType:@"plist"];
    googleKeys = [NSMutableDictionary dictionaryWithContentsOfFile:googlePlistPath];
    NSString *kClientID = (NSString *)googleKeys[@"CLIENT_ID"];
    [GIDSignIn sharedInstance].clientID = kClientID;
    
    //facebook  id配置在info.plist文件中
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 90000

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options {
    
    DOSigninManagerV2 *signinManager = [DOSigninManagerV2 shareSigninManager];
    if (signinManager.signinType == DOSigninGoogle) {
        BOOL handled = [[GIDSignIn sharedInstance] handleURL:url
                                           sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                                  annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
        // Add any custom logic here.
        return handled;
    }else if (signinManager.signinType == DOSigninFacebook){
        BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                      openURL:url
                                                            sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                                                   annotation:options[UIApplicationOpenURLOptionsAnnotationKey]
                        ];
        // Add any custom logic here.
        return handled;
    }else{
        BOOL handled = [[Twitter sharedInstance] application:application openURL:url options:options];
        
        // Add any custom logic here.
        return handled;;
    }
}

#else

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    if (signinManager.signinType == DOSigninGoogle) {
        BOOL handled = [[GIDSignIn sharedInstance] handleURL:url
                                           sourceApplication:sourceApplication
                                                  annotation:annotation];
        
        // Add any custom logic here.
        return handled;
        
    }else if (signinManager.signinType == DOSigninTwitter){
        
        BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                      openURL:url
                                                            sourceApplication:sourceApplication
                                                                   annotation:annotation
                        ];
        // Add any custom logic here.
        return handled;
    }else{
        BOOL handled = [[Twitter sharedInstance] application:application openURL:url options:annotation];
        
        // Add any custom logic here.
        return handled;;
    }
    
}

#endif


@end
