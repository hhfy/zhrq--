//
//  MBProgressHUD+LAI.m
//
//  Created by Mr Lai on 2017/3/7.
//  Copyright © 2017年 赖同学. All rights reserved.
//

#import "MBProgressHUD+LAI.h"

/* 文字颜色 */
#define LabelColor [UIColor whiteColor];
/* 背景颜色 */
#define BezelViewColor [UIColor colorWithWhite:0.0 alpha:0.7]
/* 文字大小 */
#define LabelTextFont [UIFont systemFontOfSize:14.0f]

@implementation MBProgressHUD (LAI)
#pragma mark 显示信息
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = text;
    hud.label.font = LabelTextFont;
    
    // 修改文字颜色
    hud.contentColor = LabelColor;
    // 修改背景颜色
    hud.bezelView.color = BezelViewColor;
    
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1秒之后再消失
    // [hud hide:YES afterDelay:0.7];
    [hud hideAnimated:YES afterDelay:1];
}

#pragma mark 显示错误信息
+ (void)showError:(NSString *)error toView:(UIView *)view{
    [self show:error icon:@"error.png" view:view];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view
{
    [self show:success icon:@"success.png" view:view];
}

#pragma mark 显示一些信息
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view {
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = message;
    hud.label.font = LabelTextFont;
    // 修改文字颜色
    hud.contentColor = LabelColor;
    // 修改背景颜色
    hud.bezelView.color = BezelViewColor;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    
    // dimBackground已经被弃用
    //hud.dimBackground = YES;
    
    return hud;
}

+ (void)showSuccess:(NSString *)success
{
    [self showSuccess:success toView:nil];
}

+ (void)showError:(NSString *)error
{
    [self showError:error toView:nil];
}

+ (MBProgressHUD *)showMessage:(NSString *)message
{
    return [self showMessage:message toView:nil];
}

+ (void)hideHUDForView:(UIView *)view
{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    [self hideHUDForView:view animated:YES];
}

+ (void)hideHUD
{
    [self hideHUDForView:nil];
}
@end
