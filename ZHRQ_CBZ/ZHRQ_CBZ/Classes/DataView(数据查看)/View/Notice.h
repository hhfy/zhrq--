//
//  Notice.h
//  ZHRQ_CBZ
//
//  Created by Mr Lai on 2017/7/6.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Notice : NSObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *is_del;
@property (nonatomic, copy) NSString *add_time;
@end
