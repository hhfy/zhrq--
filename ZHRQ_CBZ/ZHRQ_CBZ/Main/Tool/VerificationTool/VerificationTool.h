//
//  VerificationTool.h
//  ZTXWY
//
//  Created by Mr Lai on 2017/5/22.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VerificationTool : NSObject
/// 验证手机号码
+ (BOOL)validateTelNumber:(NSString *)number;
/// 验证验证码
+ (BOOL)validateVerificationCode:(NSString *)verificationCode;
/// 验证钢瓶表编码
+ (BOOL)validateCylinderCode:(NSString *)cylinderCode;
/// 验证姓名
+ (BOOL)validateName:(NSString *)name;
/// 验证身份证号码
+ (BOOL)validateIdentityNumber:(NSString *)identityNumber;
/// 验证密码格式（必须是字母和数组组合，不能为纯数字或者字母6-18位）
+ (BOOL)validatePwd:(NSString *)pwd;
@end
