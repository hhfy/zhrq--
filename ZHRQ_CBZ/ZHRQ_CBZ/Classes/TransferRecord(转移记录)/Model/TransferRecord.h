//
//  TransferRecord.h
//  ZHRQ_CBZ
//
//  Created by Mr Lai on 2017/7/5.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TransferRecord : NSObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *company;          // 单位名称
@property (nonatomic, copy) NSString *outcount;         // 转出
@property (nonatomic, copy) NSString *incount;          // 转入
@end
