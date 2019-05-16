//
//  NSDate+Extension.h
//
//  Created by Mr Lai on 2017/2/4.
//  Copyright © 2017年 赖同学. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extension)
- (BOOL)isThisYear;
- (BOOL)isYesterday;
- (BOOL)isTomorrow;
- (BOOL)isToday;
- (BOOL)isDayAfterTomorrow;
- (BOOL)isThisWeek;
- (BOOL)isInTime;
- (BOOL)isOutTime;
+ (NSDate *)localDate;
+ (NSDate *)dateFromStringFormat:(NSString *)dateStr formatter:(NSString *)formatter;
@end
