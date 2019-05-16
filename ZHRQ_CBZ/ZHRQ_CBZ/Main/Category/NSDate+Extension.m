//
//  NSDate+Extension.m
//
//  Created by Mr Lai on 2017/2/4.
//  Copyright © 2017年 赖同学. All rights reserved.
//

#import "NSDate+Extension.h"
#import "NSString+Extension.h"

@implementation NSDate (Extension)

#define nowDate [NSDate localDate]
static NSString *const fmt = @"yyyy-MM-dd";

/// 如果[NSDate date]存在时差，就调用此方法来获取
+ (NSDate *)localDate {
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone localTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    return [date dateByAddingTimeInterval:interval];
}

- (BOOL)isThisYear
{
    // 创建日历对象
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // 设置对比属性
    NSCalendarUnit unit = NSCalendarUnitYear;
    
    // 获得某个时间的具体年与日时分秒
    NSDateComponents *dateCmps = [calendar components:unit fromDate:self];
    NSDateComponents *nowCmps = [calendar components:unit fromDate:nowDate];
    return dateCmps.year == nowCmps.year;
}

- (BOOL)isYesterday
{
    // 原理是将时间转成去掉时分秒，剩下年与日，然后相减，是否为1
    NSString *dateStr = [NSString stringFormDateFromat:self formatter:fmt];
    NSString *nowStr = [NSString stringFormDateFromat:nowDate formatter:fmt];
    
    // 时间就已经去掉了时分秒
    NSDate *date = [NSDate dateFromStringFormat:dateStr formatter:fmt];
    NSDate *now = [NSDate dateFromStringFormat:nowStr formatter:fmt];
    
    // 创建日历对象
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // 设置对比属性
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    
    // 对比时间
    NSDateComponents *cmps = [calendar components:unit fromDate:date toDate:now options:0];
    
    return cmps.year == 0 && cmps.month == 0 && cmps.day == 1;
}

- (BOOL)isTomorrow
{
    // 原理是将时间转成去掉时分秒，剩下年与日，然后相减，是否为1
    NSString *dateStr = [NSString stringFormDateFromat:self formatter:fmt];
    NSString *nowStr = [NSString stringFormDateFromat:nowDate formatter:fmt];
    
    // 时间就已经去掉了时分秒
    NSDate *date = [NSDate dateFromStringFormat:dateStr formatter:fmt];
    NSDate *now = [NSDate dateFromStringFormat:nowStr formatter:fmt];
    
    // 创建日历对象
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // 设置对比属性
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    
    // 对比时间
    NSDateComponents *cmps = [calendar components:unit fromDate:now toDate:date options:0];
    
    return cmps.year == 0 && cmps.month == 0 && cmps.day == 1;
}

- (BOOL)isDayAfterTomorrow
{
    // 原理是将时间转成去掉时分秒，剩下年与日，然后相减，是否为1
    NSString *dateStr = [NSString stringFormDateFromat:self formatter:fmt];
    NSString *nowStr = [NSString stringFormDateFromat:nowDate formatter:fmt];
    
    // 时间就已经去掉了时分秒
    NSDate *date = [NSDate dateFromStringFormat:dateStr formatter:fmt];
    NSDate *now = [NSDate dateFromStringFormat:nowStr formatter:fmt];
    
    // 创建日历对象
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // 设置对比属性
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    
    // 对比时间
    NSDateComponents *cmps = [calendar components:unit fromDate:now toDate:date options:0];
    
    return cmps.year == 0 && cmps.month == 0 && cmps.day == 2;
}


- (BOOL)isToday
{
    // 原理是将时间转成去掉时分秒，剩下年与日，然后相减，是否为1    
    NSString *dateStr = [NSString stringFormDateFromat:self formatter:fmt];
    NSString *nowStr = [NSString stringFormDateFromat:nowDate formatter:fmt];
    return [dateStr isEqualToString:nowStr];
}

- (BOOL)isThisWeek {
    // 原理是将时间转成去掉时分秒，剩下年与日，然后相减，是否为1
    NSString *dateStr = [NSString stringFormDateFromat:self formatter:fmt];
    NSString *nowStr = [NSString stringFormDateFromat:nowDate formatter:fmt];
    
    // 时间就已经去掉了时分秒
    NSDate *date = [NSDate dateFromStringFormat:dateStr formatter:fmt];
    NSDate *now = [NSDate dateFromStringFormat:nowStr formatter:fmt];
    
    // 创建日历对象
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // 设置对比属性
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    
    // 对比时间
    NSDateComponents *cmps = [calendar components:unit fromDate:now toDate:date options:0];
    
    return cmps.year == 0 && cmps.month == 0 && cmps.day <= 7;
}

- (BOOL)isInTime {
    // 原理是将时间转成去掉时分秒，剩下年与日，然后相减，是否为1
    NSString *dateStr = [NSString stringFormDateFromat:self formatter:fmt];
    NSString *nowStr = [NSString stringFormDateFromat:nowDate formatter:fmt];
    
    // 时间就已经去掉了时分秒
    NSDate *date = [NSDate dateFromStringFormat:dateStr formatter:fmt];
    NSDate *now = [NSDate dateFromStringFormat:nowStr formatter:fmt];
    
    // 对比当前时间和过期时间
    NSComparisonResult result = [date compare:now];
    // NSOrderedAscending = -1L（升序）, NSOrderedSame（一样）, NSOrderedDescending（降序）
    return (result == NSOrderedAscending);
}

- (BOOL)isOutTime {
    // 原理是将时间转成去掉时分秒，剩下年与日，然后相减，是否为1
    NSString *dateStr = [NSString stringFormDateFromat:self formatter:fmt];
    NSString *nowStr = [NSString stringFormDateFromat:nowDate formatter:fmt];
    
    // 时间就已经去掉了时分秒
    NSDate *date = [NSDate dateFromStringFormat:dateStr formatter:fmt];
    NSDate *now = [NSDate dateFromStringFormat:nowStr formatter:fmt];
    
    // 对比当前时间和过期时间
    NSComparisonResult result = [date compare:now];
    // NSOrderedAscending = -1L（升序）, NSOrderedSame（一样）, NSOrderedDescending（降序）
    return (result == NSOrderedDescending);
}


+ (NSDate *)dateFromStringFormat:(NSString *)dateStr formatter:(NSString *)formatter {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    fmt.dateFormat = formatter;
    return [fmt dateFromString:dateStr];
}


@end
