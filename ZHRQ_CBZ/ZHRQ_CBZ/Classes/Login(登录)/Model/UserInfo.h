//
//  UserInfo.h
//  ZHRQ_CBZ
//
//  Created by Mr Lai on 2017/7/6.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject
@property (nonatomic, copy) NSString *ID;
@property (nonatomic, copy) NSString *name;             // '员工名称'
@property (nonatomic, copy) NSString *account;          // '员工等录帐号',
@property (nonatomic, copy) NSString *type;             // '员工类型：1->储备站，2->供应站',
@property (nonatomic, copy) NSString *level;            // '员工等级：1->管理员，2->员工',
@property (nonatomic, copy) NSString *store_id;         // '员工所属储配站id'
@property (nonatomic, copy) NSString *supply_id;        // '员工所属供应站id',
@property (nonatomic, copy) NSString *images;           // '工作证件图片'
@property (nonatomic, copy) NSString *is_checked;       // '是否通过审核：1->待审核；2->已通过；3->未通过'
@property (nonatomic, copy) NSString *add_time;         // '创建时间',
@property (nonatomic, copy) NSString *company_name;     // '单位名称
@property (nonatomic, copy) NSString *company_addr;     // '单位地址
@end
