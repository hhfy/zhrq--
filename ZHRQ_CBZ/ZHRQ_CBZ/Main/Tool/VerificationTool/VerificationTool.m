//
//  VerificationTool.m
//  ZTXWY
//
//  Created by Mr Lai on 2017/5/22.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import "VerificationTool.h"

@implementation VerificationTool
/// 验证手机号码
+ (BOOL)validateTelNumber:(NSString *)number {
    NSString *regex = @"^[0-9]{11,11}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:number];
}

/// 验证验证码
+ (BOOL)validateVerificationCode:(NSString *)verificationCode {
    NSString *regex = @"^[0-9]{6,6}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:verificationCode];
}

/// 验证钢瓶编码
+ (BOOL)validateCylinderCode:(NSString *)cylinderCode {
    NSString *regex = @"^[0-9]{12,12}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:cylinderCode];
}

/// 验证密码格式（必须是字母和数组组合，不能为纯数字或者字母6-18位）
+ (BOOL)validatePwd:(NSString *)pwd
{
    NSString *regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[a-zA-Z0-9]{6,18}"; // 必须是字母和数组组合，不能为纯数字或者字母
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:pwd];    //判读userNameField的值是否吻合
    return isMatch;
}

/// 验证姓名
+ (BOOL)validateName:(NSString *)name {
    if (name.length < 2) return NO;
    for(int i=0; i < name.length;i++) {
        int a =[name characterAtIndex:i];
        if( a >0x4e00&& a <0x9fff){
            return YES;
        }
    }
    return NO;
}

/// 验证身份证号码
+ (BOOL)validateIdentityNumber:(NSString *)identityNumber {
    
    if (identityNumber.length != 18) return NO;
    // 正则表达式判断基本 身份证号是否满足格式
    NSString *regex = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
    NSPredicate *identityStringPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    //如果通过该验证，说明身份证格式正确，但准确性还需计算
    if(![identityStringPredicate evaluateWithObject:identityNumber]) return NO;
    
    //** 开始进行校验 *//
    
    //将前17位加权因子保存在数组里
    NSArray *idCardWiArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
    
    //这是除以11后，可能产生的11位余数、验证码，也保存成数组
    NSArray *idCardYArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
    
    //用来保存前17位各自乖以加权因子后的总和
    NSInteger idCardWiSum = 0;
    for(int i = 0;i < 17;i++) {
        NSInteger subStrIndex = [[identityNumber substringWithRange:NSMakeRange(i, 1)] integerValue];
        NSInteger idCardWiIndex = [[idCardWiArray objectAtIndex:i] integerValue];
        idCardWiSum+= subStrIndex * idCardWiIndex;
    }
    
    //计算出校验码所在数组的位置
    NSInteger idCardMod = idCardWiSum%11;
    //得到最后一位身份证号码
    NSString *idCardLast = [identityNumber substringWithRange:NSMakeRange(17, 1)];
    //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
    if(idCardMod == 2) {
        if([idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"]) {
            return YES;
        } else {
            return NO;
        }
    }
    else{
        //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
        if(![idCardLast isEqualToString: [idCardYArray objectAtIndex:idCardMod]]) {
            return NO;
        }
    }
    return YES;
}
@end
