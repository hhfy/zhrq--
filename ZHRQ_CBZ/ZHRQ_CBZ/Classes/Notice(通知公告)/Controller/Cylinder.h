//
//  Cylinder.h
//  ZHRQ_CBZ
//
//  Created by Mr Lai on 2017/7/7.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Cylinder : NSObject
@property (nonatomic, copy) NSString *no;                   // 编号
@property (nonatomic, copy) NSString *format;               // 规格
@property (nonatomic, assign) NSInteger proc_status;        //  状态：1->正常，2->异常，3->禁用, 4->暂扣
@property (nonatomic, copy) NSString *add_time;             // 编号生成时间
@end

@interface CylinderInfo : NSObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *bottle_id;
@property (nonatomic, copy) NSString *bottle_no;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *add_time;
@property (nonatomic, assign) NSInteger operation;          // ：0->激活，1->充装，2->送瓶，3->使用中，4->收瓶
@property (nonatomic, assign) NSInteger proc_status;        // 报警状态：1->正常，2->异常，3->禁用
@property (nonatomic, assign) NSInteger cylinder_status;
@property (nonatomic, copy) NSString *store_id;
@property (nonatomic, copy) NSString *supply_id;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, assign) NSInteger status;             // 0->未激活，1->已激活，2->充装，3->送瓶，4->使用中，5->收瓶'
@property (nonatomic, assign) NSInteger need_check;         // 1:需年检 0：无须年检
@end

@interface CylinderSite : NSObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *name;
@end
