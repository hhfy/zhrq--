//
//  LaiMethod.h
//  ZTXWY
//
//  Created by Mr Lai on 2017/6/8.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LaiMethod : NSObject
/// 系统弹窗两个选项
+ (void)alertControllerWithTitle:(NSString *)title message:(NSString *)message defaultActionTitle:(NSString *)actionTitle style:(UIAlertActionStyle)style cancelTitle:(NSString *)cancelTitle preferredStyle:(UIAlertControllerStyle)preferredStyle handler:(void(^)())handler;

/// 系统弹窗一个个选项
+ (void)alertControllerWithTitle:(NSString *)title message:(NSString *)message defaultActionTitle:(NSString *)actionTitle style:(UIAlertActionStyle)style handler:(void(^)())handler;

/// 跳转控制器封装
+ (void)toPushVC:(NSString *)vcName viewController:(UIViewController *)superViewController andTitle:(NSString *)vcTitle;

/// 按钮点击动画
+ (void)animationWithView:(UIView *)view;

/// 摇摆动画
+ (void)wrongInputAnimationWith:(UIView *)view;

//判断相机权限是否打开
+ (BOOL)isUserCameraPowerOpen;

/// 前往设置开启权限
+ (void)openRootPowerWithTitle:(NSString *)title message:(NSString *)message actionTitle:(NSString *)actionTitle;

/// 设置下拉刷新
+ (void)setupDownRefreshWithTableView:(UITableView *)tableView target:(id)target action:(SEL)action;

/// 设置上拉刷新
+ (void)setupUpRefreshWithTableView:(UITableView *)tableView target:(id)target action:(SEL)action;

/// 设置Datepicker
+ (void)setupKSDatePickerWithMinDate:(NSDate *)minDate maxDate:(NSDate *)maxDate dateMode:(UIDatePickerMode)dateMode headerColor:(UIColor *)headerColor result:(void (^)(NSDate *selected))result;

/// runtime跳转控制器
+ (void)runtimePushVcName:(NSString *)vcName dic:(NSDictionary *)dic nav:(UINavigationController *)nav;
@end
