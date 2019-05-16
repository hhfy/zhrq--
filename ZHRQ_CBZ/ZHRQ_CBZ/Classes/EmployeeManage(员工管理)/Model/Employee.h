//
//  Employee.h
//  ZHRQ_CBZ
//
//  Created by Mr Lai on 2017/7/1.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Employee : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *account;
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, assign) NSInteger is_overdue;
@end
