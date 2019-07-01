//
//  NSDate+Convenience.m
//  XDCalendar
//
//  Created by xieyajie on 13-3-19.
//  Copyright (c) 2013年 xieyajie. All rights reserved.
//

static NSCalendar *_calendar = nil;
static NSDateComponents *_components = nil;
static NSDateComponents *_offsetComponents = nil;

#import "NSDate+Convenience.h"

@implementation NSDate (Convenience)

- (NSCalendar *)calendar
{
    if (_calendar == nil) {
        _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        /*
         设定每周的第一天从星期几开始，比如:
         .  如需设定从星期日开始，则value传入1
         .  如需设定从星期一开始，则value传入2
         */
        [_calendar setFirstWeekday:2];
    }
    
    return _calendar;
}

- (NSDateComponents *)offsetComponents
{
    if (_offsetComponents != nil) {
        [_offsetComponents release];
    }
    _offsetComponents = [[NSDateComponents alloc] init];
    return _offsetComponents;
}

- (void)setComponents:(NSInteger)unitFlags
{
    _components = [[self calendar] components:unitFlags fromDate: self];
}

- (NSInteger)year
{
    [self setComponents:NSYearCalendarUnit];
    return [_components year];
}

- (NSInteger)month
{
    [self setComponents:NSMonthCalendarUnit];
    return [_components month];
}

- (NSInteger)day
{
    [self setComponents:NSDayCalendarUnit];
    return [_components day];
}

- (NSInteger)week
{
    [self setComponents:NSWeekdayCalendarUnit ];
    return [_components weekday];
}

- (NSInteger)countOfDaysInMonth
{
    NSRange rng = [[self calendar] rangeOfUnit: NSDayCalendarUnit inUnit: NSMonthCalendarUnit forDate: self];
    NSUInteger number = rng.length;
    return number;
}


- (NSInteger)countOfWeeksInMonth
{
    NSRange rng = [[self calendar] rangeOfUnit: NSWeekCalendarUnit inUnit: NSMonthCalendarUnit forDate: self];
    NSUInteger number = rng.length;
    return number;
}

- (NSInteger)firstWeekDayInMonth
{
    //Set date to first of month
    [self setComponents: NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit];
    [_components setDay:1];
    NSDate *newDate = [_calendar dateFromComponents:_components];
    
    return [_calendar ordinalityOfUnit: NSWeekdayCalendarUnit inUnit:NSWeekCalendarUnit forDate:newDate];
}

- (NSInteger)weekInMonth
{
    [self setComponents:NSWeekOfMonthCalendarUnit];
    NSInteger weekdayOrdinal = [_components weekOfMonth];
    return weekdayOrdinal;
}

- (NSInteger)weekInYear
{
    [self setComponents:NSWeekCalendarUnit];
    NSInteger weekdayOrdinal = [_components week];
    return weekdayOrdinal;
}

- (NSDate *)offsetMonth:(NSInteger)numMonths
{
    [[self offsetComponents] setMonth: numMonths];
    
    return [_calendar dateByAddingComponents:_offsetComponents toDate:self options:0];
}

-(NSDate *)offsetDay:(NSInteger)numDays
{
    [[self offsetComponents] setDay:numDays];
    
    return [_calendar dateByAddingComponents:_offsetComponents toDate:self options:0];
}

- (BOOL)isEqualToDate: (NSDate *)aDate
{
    if ([self year] == [aDate year] && [self month] == [aDate month] && [self day] == [aDate day])
    {
        return YES;
    }
    else{
        return NO;
    }
}

- (NSInteger)compareWithDate: (NSDate *)aDate
{
    NSInteger cYear = [self year];
    NSInteger aYear = [aDate year];
    if (cYear > aYear)
    {
        return XDDateComparePlurality;
    }
    else if (cYear < aYear)
    {
        return XDDateCompareSmaller;
    }
    else{
        NSInteger cMonth = [self month];
        NSInteger aMonth = [aDate month];
        
        if (cMonth > aMonth)
        {
            return XDDateComparePlurality;
        }
        else if (cMonth < aMonth)
        {
            return XDDateCompareSmaller;
        }
        else{
            NSInteger cDay = [self day];
            NSInteger aDay = [aDate day];
            if (cDay > aDay)
            {
                return XDDateComparePlurality;
            }
            else if (cDay < aDay)
            {
                return XDDateCompareSmaller;
            }
            else{
                return XDDateCompareEqual;
            }
        }
    }
}

- (NSDate *)firstDayOfMonth
{
    NSTimeInterval endDate;
    NSDate *firstDay = nil;
    [[self calendar] rangeOfUnit:NSMonthCalendarUnit startDate:&firstDay interval:&endDate forDate: self];
    
    return firstDay;
}

@end
