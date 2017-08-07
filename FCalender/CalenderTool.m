//
//  CalenderTool.m
//  FCalender
//
//  Created by fcz on 2017/8/7.
//  Copyright © 2017年 com.TulipSport. All rights reserved.
//

#import "CalenderTool.h"

@interface CalenderTool ()

@property (nonatomic,strong) NSCalendar *calender;

@end

@implementation CalenderTool

+ (id)shared
{
    static CalenderTool *tool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [[CalenderTool alloc] init];
        tool.calender = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    });
    return tool;
}

//获取某天所在月份的第一天
- (NSDate *)getMonthFirstDay:(NSString *)string
{
    NSDateComponents *components = [_calender components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitWeekday|NSCalendarUnitDay|NSCalendarUnitTimeZone|NSCalendarUnitWeekOfMonth|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:[self timeFromString:string]];
    [components setDay:1];
    return [_calender dateFromComponents:components];
}

//获取某天所在月份的天数
- (NSInteger)getMonthDays:(NSString *)string
{
    NSRange range = [_calender rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:[self timeFromString:string]];
    return range.length;
}

//获取某天是周几
- (NSInteger)getWeekSeveral:(NSString *)string
{
    NSDateComponents *components = [_calender components:NSCalendarUnitWeekOfMonth|NSCalendarUnitWeekday|NSCalendarUnitDay|NSCalendarUnitTimeZone|NSCalendarUnitWeekOfMonth fromDate:[self timeFromString:string]];
    if(components.weekday == 1) return 7;
    return components.weekday - 1;
}

//获取某天所在月份跨越的周数
- (NSInteger)getMonthWeeks:(NSString *)string
{
    NSInteger monthDays = [self getMonthDays:string];
    NSString *firstDay = [self stringFromTime:[self getMonthFirstDay:string]];
    NSInteger weekSeveral = [self getWeekSeveral:firstDay];
    
    NSInteger count = (monthDays - (7 - (weekSeveral - 1))) / 7;
    NSInteger remain = (monthDays - (7 - (weekSeveral - 1))) % 7 == 0 ? 0 : 1;
    return count + remain + 1;
}

//获取某天所在周的第一天
- (NSDate *)getWeekFirstDay:(NSString *)string
{
    NSDateComponents *components = [_calender components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitWeekday fromDate:[self timeFromString:string]];
    NSInteger weekSeveral = components.weekday == 1 ? 7 : components.weekday - 1;
    components.day = components.day - weekSeveral + 1;
    return [_calender dateFromComponents:components];
}

//获取某天所在周的全部天
- (NSArray *)getWeekAllDays:(NSString *)string
{
    NSDateComponents *components = [_calender components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitWeekday fromDate:[self timeFromString:string]];
    
    NSInteger weekSeveral = components.weekday == 1 ? 7 : components.weekday - 1;
    components.day = components.day - weekSeveral + 1;
    NSDate *firstDate = [_calender dateFromComponents:components];
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    for(int i=0;i<7;i++){
        NSDate *dateTemp = [firstDate dateByAddingTimeInterval:3600*24*i];
        NSString *stringTemp = [self stringFromTime:dateTemp];
        [array addObject:stringTemp];
    }
    return array;
}

//获取某天所在月的全部天
- (NSArray *)getMonthAllDays:(NSString *)string
{
    NSDate *date = [self timeFromString:string];
    NSDateComponents *components = [_calender components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitWeekday|NSCalendarUnitDay|NSCalendarUnitTimeZone|NSCalendarUnitWeekOfMonth|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:date];
    [components setDay:1];
    NSDate *firstDate = [_calender dateFromComponents:components];
    NSInteger monthDays = [_calender rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date].length;
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    for(int i=0;i<monthDays;i++){
        NSDate *dateTemp = [firstDate dateByAddingTimeInterval:3600*24*i];
        NSString *stringTemp = [self stringFromTime:dateTemp];
        [array addObject:stringTemp];
    }
    return array;
}

//日期按日加减
- (NSString *)timeAddDay:(NSString *)day increase:(BOOL)increase
{
    NSDate *date = [self timeFromString:day];
    if(increase){
        date = [date dateByAddingTimeInterval:3600*24];
    }else{
        date = [date dateByAddingTimeInterval:-3600*24];
    }
    return [self stringFromTime:date];
}

//日期按周加减
- (NSString *)timeAddWeek:(NSArray *)days increase:(BOOL)increase
{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    for(NSString *stringTemp in days){
        NSDate *dateTemp = [self timeFromString:stringTemp];
        if(increase){
            dateTemp = [dateTemp dateByAddingTimeInterval:3600*24*7];
        }else{
            dateTemp = [dateTemp dateByAddingTimeInterval:-3600*24*7];
        }
        NSString *dayString = [self stringFromTime:dateTemp];
        [array addObject:dayString];
    }
    return [NSString stringWithFormat:@"%@ - %@",[array firstObject],[array lastObject]];
}

//日期按月加减
- (NSString *)timeAddMonth:(NSArray *)days increase:(BOOL)increase
{
    NSDate *firstDate = [self timeFromString:[days firstObject]];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.month = increase ? 1 : -1;
    NSString *string = [self stringFromTime:[_calender dateByAddingComponents:components toDate:firstDate options:0]];
    return [string substringToIndex:7];
}

//日期转时间
- (NSDate *)timeFromString:(NSString *)string
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    return [formatter dateFromString:string];
}

//时间转日期
- (NSString *)stringFromTime:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    return [formatter stringFromDate:date];
}

@end
