//
//  UIColor+Extension.m
//
//  Created by Mr Lai on 2017/5/16.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import "UIColor+Extension.h"

@implementation UIColor (Extension)

#pragma mark - UIColor Normal
+ (UIColor*) colorWithHex:(NSString *)hexColor
{
    return [UIColor colorWithHex:hexColor alpha:1.0f];
}

#pragma mark - UIColor With Alpha
+ (UIColor *)colorWithHex:(NSString *)hexColor alpha:(float)opacity
{
    unsigned int red, green, blue;
    NSRange range;
    range.length = 2;
    
    range.location = 1;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
    range.location = 3;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
    range.location = 5;
    [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
    return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green/255.0f) blue:(float)(blue/255.0f) alpha:1.0f];
}
@end
