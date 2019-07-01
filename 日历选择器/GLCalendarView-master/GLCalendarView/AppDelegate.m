//
//  AppDelegate.m
//  GLCalendarView
//
//  Created by ltebean on 15-4-29.
//  Copyright (c) 2015 glow. All rights reserved.
//

#import "AppDelegate.h"
#import "GLCalendarView.h"
#import "GLCalendarDayCell.h"


#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [UINavigationBar appearance].barTintColor = UIColorFromRGB(0x79a9cd);
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    
    [GLCalendarView appearance].rowHeight = 54;
    [GLCalendarView appearance].padding = 6;

    [GLCalendarView appearance].weekDayTitleAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:8], NSForegroundColorAttributeName:[UIColor grayColor]};
    [GLCalendarView appearance].monthCoverAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:30]};
    [GLCalendarDayCell appearance].evenMonthBackgroundColor = UIColorFromRGB(0xf5f5f5);

    [GLCalendarDayCell appearance].rangeDisplayMode = RANGE_DISPLAY_MODE_CONTINUOUS;

    [GLCalendarDayCell appearance].dayLabelAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:20], NSForegroundColorAttributeName:UIColorFromRGB(0x555555)};
    [GLCalendarDayCell appearance].monthLabelAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:8]};
    
    [GLCalendarDayCell appearance].editCoverBorderWidth = 2;
    [GLCalendarDayCell appearance].editCoverBorderColor = UIColorFromRGB(0x366aac);
    [GLCalendarDayCell appearance].editCoverPointSize = 14;
    
    [GLCalendarDayCell appearance].todayBackgroundColor = UIColorFromRGB(0x366aac);
    [GLCalendarDayCell appearance].todayLabelAttributes = @{NSFontAttributeName:[UIFont systemFontOfSize:20]};

    return YES;
}

@end
