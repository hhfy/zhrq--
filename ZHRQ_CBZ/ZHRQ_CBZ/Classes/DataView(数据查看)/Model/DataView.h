//
//  DataView.h
//  ZHRQ_CBZ
//
//  Created by Mr Lai on 2017/7/6.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataView : NSObject
@property (nonatomic, copy) NSString *no;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, copy) NSString *add_time;
@property (nonatomic, copy) NSString *name;
@end

@interface DataRecord : NSObject
@property (nonatomic, copy) NSString *activation;       // 激活数
@property (nonatomic, copy) NSString *filling;          // 充装数
@end
