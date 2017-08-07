//
//  CalenderTool.h
//  FCalender
//
//  Created by fcz on 2017/8/7.
//  Copyright © 2017年 com.TulipSport. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalenderTool : NSObject

//获取单例
+ (id)shared;

//获取某天所在月份的天数
- (NSInteger)getMonthDays:(NSString *)string;

//获取某天是周几
- (NSInteger)getWeekSeveral:(NSString *)string;

//获取某天所在月份跨越的周数
- (NSInteger)getMonthWeeks:(NSString *)string;

//获取某天所在周的全部天
- (NSArray *)getWeekAllDays:(NSString *)string;

//获取某天所在月的全部天
- (NSArray *)getMonthAllDays:(NSString *)string;

//日期按日加减
- (NSString *)timeAddDay:(NSString *)day increase:(BOOL)increase;

//日期按周加减
- (NSString *)timeAddWeek:(NSArray *)days increase:(BOOL)increase;

//日期按月加减
- (NSString *)timeAddMonth:(NSArray *)days increase:(BOOL)increase;

//日期转时间
- (NSDate *)timeFromString:(NSString *)string;

//时间转日期
- (NSString *)stringFromTime:(NSDate *)date;

@end
