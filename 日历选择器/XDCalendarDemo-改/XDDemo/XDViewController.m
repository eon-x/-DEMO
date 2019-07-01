//
//  XDViewController.m
//  XDDemo
//
//  Created by xieyajie on 13-4-15.
//  Copyright (c) 2013年 xieyajie. All rights reserved.
//

#import "XDViewController.h"
#import "XDCalendarPickerDaysOwner.h"
#import "XDCalendarPicker.h"
#import "NSDate+Convenience.h"
#import "LocalDefine.h"

@interface XDViewController ()<XDCalendarPickerDelegate>
{
    XDCalendarPicker *_calendarPicker;
}

@property (nonatomic, retain) XDCalendarPicker *calendarPicker;

@end

@implementation XDViewController

@synthesize calendarPicker = _calendarPicker;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _calendarPicker = [[XDCalendarPicker alloc] initWithFrame:CGRectMake(0, 110, 320, kCalendarPickerDaysHeight)];
    _calendarPicker.delegate = self;
    [self.view addSubview:_calendarPicker];
}

#pragma mark - XDCalendarPicker Delegate

-(void)calendarPicker:(XDCalendarPicker *)calendarPicker changeFromStyle:(XDCalendarPickerStyle)fromStyle toStyle:(XDCalendarPickerStyle)toStyle changeToHeight:(float)height animated:(BOOL)animated
{
    if (toStyle == XDCalendarPickerStyleDays) {
        [UIView animateWithDuration:0.35 animations:^{
            _calendarPicker.frame = CGRectMake(0, 0, 320, height);
        }completion:nil];
    }
}

-(void)calendarPicker:(XDCalendarPicker *)calendarPicker dateSelected:(NSDate *)date
{
    NSLog(@"date selected: %@", date);
}

@end
