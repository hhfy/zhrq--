//
//  NSString+Extension.m
//
//  Created by Mr Lai on 2017/4/27.
//  Copyright © 2017年 Mr Lai. All rights reserved.
//

#import "NSString+Extension.h"
#import "NSDate+Extension.h"

@implementation NSString (Extension)

/// 将字符串日期格式转为指定字符串格式的日期
+ (NSString *)dateStr:(NSString *)dateStr formatter:(NSString *)formatter  formatWithOtherFormatter:(NSString *)otherFormatter {
    NSDate *date = [NSDate dateFromStringFormat:dateStr formatter:formatter];
    return [NSString stringFormDateFromat:date formatter:otherFormatter];
}

/// 对比连个字符串类型的时间至少是年月日
+ (NSInteger)compareDateStr:(NSString *)dateStr withOtherDateStr:(NSString *)otherDateStr formatter:(NSString *)formatter {
    NSDate *dateA = [NSDate dateFromStringFormat:dateStr formatter:formatter];
    NSDate *dateB = [NSDate dateFromStringFormat:otherDateStr formatter:formatter];
    
    NSComparisonResult result = [dateA compare:dateB];
    if (result == NSOrderedDescending) { //降序
        return 1;
    } else if (result == NSOrderedAscending){ // 升序
        return -1;
    } else {
        return 0;
    }
}

/// 将字符类型的时间转为周几至少是年月日
+ (NSString *)calculateWeek:(NSString *)dateStr formatter:(NSString *)formatter {
    
    NSDate* inputDate = [NSDate dateFromStringFormat:dateStr formatter:formatter];
    //计算week数
    NSCalendar * myCalendar = [NSCalendar currentCalendar];
    myCalendar.timeZone = [NSTimeZone systemTimeZone];
    NSInteger week = [[myCalendar components:NSCalendarUnitWeekday fromDate:inputDate] weekday];
    switch (week) {
        case 1: {
            return @"周日";
        }
        case 2: {
            return @"周一";
        }
        case 3: {
            return @"周二";
        }
        case 4: {
            return @"周三";
        }
        case 5: {
            return @"周四";
        }
        case 6: {
            return @"周五";
        }
        case 7: {
            return @"周六";
        }
    }
    return nil;
}

/// 对比两个字符串格式的时间是否为今天、明天、后天
+ (NSString *)componentNowDateWithSelectedDate:(NSString *)selectedDate formatter:(NSString *)formatter {

    NSDate *createDate = [NSDate dateFromStringFormat:selectedDate formatter:formatter];
    
    if ([createDate isYesterday]) {
        return @"昨天";
    }
    else if ([createDate isToday]) // 今天
    {
        return @"今天";
    }
    else if ([createDate isTomorrow]) // 明天
    {
        return @"明天";
    }
    else if ([createDate isDayAfterTomorrow]) // 后天
    {
        return @"后天";
    } else {
        return nil;
    }
}

/// 对比两个字符串类型的时间直接的差值(格式不能为时间戳类型的格式)
+ (NSString *)getDifferenceDate:(NSString *)date withOtherDate:(NSString *)otherDate formatter:(NSString *)formatter options:(DifferenceDateComponentType)componentType {
    NSDate *dateA = [NSDate dateFromStringFormat:date formatter:formatter];
    NSDate *dateB = [NSDate dateFromStringFormat:otherDate formatter:formatter];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [calendar setFirstWeekday:2];
    // 需要对比的时间数据
    NSCalendarUnit unit = NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    // 对比时间差
    NSDateComponents *dateCom = [calendar components:unit fromDate:dateB toDate:dateA options:0];
    
    if (componentType == DifferenceDateComponentTypeOnlyDays) {
        return [NSString stringWithFormat:@"%zd", labs(dateCom.day)];
    } else {
        return [NSString stringWithFormat:@"%zd天%zd时%zd分", labs(dateCom.day), labs(dateCom.hour), labs(dateCom.minute)];
    }
}

/// NSDate转为字符串格式的时间
+ (NSString *)stringFormDateFromat:(NSDate *)date formatter:(NSString *)formatter {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.timeZone = [NSTimeZone timeZoneForSecondsFromGMT:0];
    fmt.dateFormat = formatter;
    return [fmt stringFromDate:date];
}

/// 将时间戳装换为指定的字符串格式的时间格式
+ (NSString *)stringFromTimestampFromat:(NSString *)timestamp formatter:(NSString *)formatter {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[timestamp doubleValue]];
    NSDate *localDate = [date dateByAddingTimeInterval:28800.0f];
    return [NSString stringFormDateFromat:localDate formatter:formatter];
}

+ (NSString *)getBytesFromDataLength:(NSInteger)dataLength {
    NSString *bytes;
    if (dataLength >= 0.1 * (1024 * 1024)) {
        bytes = [NSString stringWithFormat:@"%0.1fM", dataLength / 1024 / 1024.0];
    } else if (dataLength >= 1024) {
        bytes = [NSString stringWithFormat:@"%0.0fK", dataLength / 1024.0];
    } else {
        bytes = [NSString stringWithFormat:@"%zdB", dataLength];
    }
    return bytes;
}

+ (NSString *)jsonStrFromatWithArray:(NSArray *)array {
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
    return (error) ? nil : [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end
