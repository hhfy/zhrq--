//
//  SaveTool.h
//
//  Created by Mr Lai on 2016/11/24.
//  Copyright © 2016年 赖同学. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SaveTool : NSObject

+ (void)setObject:(id)value forKey:(NSString *)defaultName;
+ (void)setBool:(BOOL)value forKey:(NSString *)defaultName;
+ (id)objectForKey:(NSString *)defaultName;

@end
