//
//  NSString+Extension.h
//
//  Created by Mr Lai on 2017/4/27.
//  Copyright © 2017年 Mr Lai. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    DifferenceDateComponentTypeOnlyDays = 0,
    DifferenceDateComponentTypeDayHourMinute
} DifferenceDateComponentType;

@interface NSString (Extension)
+ (NSInteger)compareDateStr:(NSString *)dateStr withOtherDateStr:(NSString *)otherDateStr formatter:(NSString *)formatter;
+ (NSString *)calculateWeek:(NSString *)dateStr formatter:(NSString *)formatter;
+ (NSString *)componentNowDateWithSelectedDate:(NSString *)selectedDate formatter:(NSString *)formatter;
+ (NSString *)getDifferenceDate:(NSString *)date withOtherDate:(NSString *)otherDate formatter:(NSString *)formatter options:(DifferenceDateComponentType)componentType;
+ (NSString *)stringFormDateFromat:(NSDate *)date formatter:(NSString *)formatter;
+ (NSString *)stringFromTimestampFromat:(NSString *)timestamp formatter:(NSString *)formatter;
+ (NSString *)getBytesFromDataLength:(NSInteger)dataLength;
+ (NSString *)jsonStrFromatWithArray:(NSArray *)array;
@end
