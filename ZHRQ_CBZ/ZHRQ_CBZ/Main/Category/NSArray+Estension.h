//
//  NSArray+Estension.h
//
//  Created by Mr Lai on 2017/6/22.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Estension)
/// JSON字符串数组转成OC数组
+ (NSArray *)arrayFromatFromJsonDataString:(NSString *)string;
@end
