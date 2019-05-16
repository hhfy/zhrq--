//
//  NSArray+Estension.m
//
//  Created by Mr Lai on 2017/6/22.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import "NSArray+Estension.h"

@implementation NSArray (Estension)
+ (NSArray *)arrayFromatFromJsonDataString:(NSString *)string {
    if (!string) return nil;
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
}
@end
