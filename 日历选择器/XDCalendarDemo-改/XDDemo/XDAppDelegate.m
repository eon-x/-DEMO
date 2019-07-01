//
//  XDAppDelegate.m
//  XDDemo
//
//  Created by xieyajie on 13-4-15.
//  Copyright (c) 2013年 xieyajie. All rights reserved.
//

#import "XDAppDelegate.h"

#import "XDViewController.h"

@implementation XDAppDelegate

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.viewController = [[[XDViewController alloc] initWithNibName:@"XDViewController" bundle:nil] autorelease];
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
