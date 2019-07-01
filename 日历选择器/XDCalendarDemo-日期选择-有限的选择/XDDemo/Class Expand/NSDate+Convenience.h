//
//  NSDate+Convenience.h
//  XDCalendar
//
//  Created by xieyajie on 13-3-19.
//  Copyright (c) 2013年 xieyajie. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    XDDateCompareSmaller = -1,
    XDDateCompareEqual = 0,
    XDDateComparePlurality
}XDDateCompare;


@interface NSDate (Convenience)

- (NSInteger)year;

- (NSInteger)month;

- (NSInteger)day;

- (NSInteger)week;

- (NSInteger)countOfDaysInMonth;

- (NSInteger)countOfWeeksInMonth;

- (NSInteger)firstWeekDayInMonth;

- (NSInteger)weekInMonth;

- (NSInteger)weekInYear;

- (NSDate *)offsetMonth:(NSInteger)numMonths;

- (NSDate *)offsetDay:(NSInteger)numDays;

- (BOOL)isEqualToDate: (NSDate *)aDate;

- (NSInteger)compareWithDate: (NSDate *)aDate;

- (NSDate *)firstDayOfMonth;

@end
