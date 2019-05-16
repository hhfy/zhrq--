
//
//  LaiMethod.m
//  ZTXWY
//
//  Created by Mr Lai on 2017/6/8.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import "LaiMethod.h"

#define currentWindow

@implementation LaiMethod
/// 封装系统弹出框（两个选项）
+ (void)alertControllerWithTitle:(NSString *)title message:(NSString *)message defaultActionTitle:(NSString *)actionTitle style:(UIAlertActionStyle)style cancelTitle:(NSString *)cancelTitle preferredStyle:(UIAlertControllerStyle)preferredStyle handler:(void(^)())handler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:preferredStyle];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:actionTitle style:style handler:^(UIAlertAction * _Nonnull action) {
        if (handler) {
            handler();
        }
    }];
    [alertController addAction:cancel];
    [alertController addAction:defaultAction];
    [CurrentWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
}

/// 封装系统弹出框（一个选项）
+ (void)alertControllerWithTitle:(NSString *)title message:(NSString *)message defaultActionTitle:(NSString *)actionTitle style:(UIAlertActionStyle)style handler:(void(^)())handler {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:actionTitle style:style handler:^(UIAlertAction * _Nonnull action) {
        if (handler) {
            handler();
        }
    }];
    [alertController addAction:defaultAction];
    [CurrentWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
}

+ (void)toPushVC:(NSString *)vcName viewController:(UIViewController *)superViewController andTitle:(NSString *)vcTitle {
    NSString *class =[NSString stringWithFormat:@"%@",vcName];
    const char *className = [class cStringUsingEncoding:NSASCIIStringEncoding];
    // 从一个字串返回一个类
    Class newClass = objc_getClass(className);
    if (!newClass) {
        // 创建一个类
        Class superClass = [NSObject class];
        newClass = objc_allocateClassPair(superClass, className, 0);
        // 注册你创建的这个类
        objc_registerClassPair(newClass);
    }
    // 创建对象
    id instance = [[newClass alloc] init];
    if (vcTitle) {
        [instance setValue:vcTitle forKey:@"titleString"];
    }
    [superViewController.navigationController pushViewController:instance animated:YES];
}

+ (BOOL)isUserCameraPowerOpen {
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) return NO;
    return YES;
}

+ (void)openRootPowerWithTitle:(NSString *)title message:(NSString *)message actionTitle:(NSString *)actionTitle {
    [LaiMethod alertControllerWithTitle:title message:message defaultActionTitle:actionTitle style:UIAlertActionStyleCancel handler:^{
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString]; // @"App-Prefs:root=Photos"
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }];
}

+ (void)animationWithView:(UIView *)view {
    POPSpringAnimation *sprintAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    sprintAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)];
    sprintAnimation.velocity = [NSValue valueWithCGPoint:CGPointMake(7, 7)];
    sprintAnimation.springSpeed = 20;
    sprintAnimation.springBounciness = 15.f;
    sprintAnimation.beginTime = CACurrentMediaTime() + 0.01;
    [view pop_addAnimation:sprintAnimation forKey:@"springAnimation"];
}

+ (void)wrongInputAnimationWith:(UIView *)view {
    if (view.centerX != MainScreenSize.width * 0.5) return;
    POPSpringAnimation *shake = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    shake.springBounciness = 20;
    shake.velocity = @(1500);
    shake.springSpeed = 60;
    shake.beginTime = CACurrentMediaTime() + 0.01;
    [view.layer pop_addAnimation:shake forKey:@"shakeView"];
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

+ (void)setupDownRefreshWithTableView:(UITableView *)tableView target:(id)target action:(SEL)action {
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:target refreshingAction:action];
    header.lastUpdatedTimeLabel.hidden = YES;
    [header setTitle:@"   下拉刷新" forState:MJRefreshStateIdle];
    [header setTitle:@"   释放刷新" forState:MJRefreshStatePulling];
    [header setTitle:@"   加载中..." forState:MJRefreshStateRefreshing];
    header.stateLabel.font = TextSystemFont(14);
    header.stateLabel.textColor = SetupColor(135, 135, 135);
    header.labelLeftInset = 5;
    header.automaticallyChangeAlpha = YES;
    tableView.mj_header = header;
}

+ (void)setupUpRefreshWithTableView:(UITableView *)tableView target:(id)target action:(SEL)action {
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:target refreshingAction:action];
    footer.labelLeftInset = 5;
    [footer setTitle:@"点击加载更多" forState:MJRefreshStateIdle];
    [footer setTitle:@"   加载中..." forState:MJRefreshStateRefreshing];
    [footer setTitle:@"没有更多了" forState:MJRefreshStateNoMoreData];
    footer.stateLabel.font = TextSystemFont(13);
    footer.stateLabel.textColor = SetupColor(157, 157, 157);
    tableView.mj_footer = footer;
}

+ (void)setupKSDatePickerWithMinDate:(NSDate *)minDate maxDate:(NSDate *)maxDate dateMode:(UIDatePickerMode)dateMode headerColor:(UIColor *)headerColor result:(void (^)(NSDate *selected))result {
    KSDatePicker* picker = [[KSDatePicker alloc] initWithFrame:CGRectMake(0, 0, MainScreenSize.width - 40, 300)];
    picker.appearance.radius = 5;
    picker.appearance.minimumDate = minDate;
    picker.appearance.maximumDate = maxDate;
    picker.appearance.datePickerMode = dateMode;
    picker.appearance.headerBackgroundColor = headerColor;
    //设置回调
    picker.appearance.resultCallBack = ^void(KSDatePicker* datePicker,NSDate* currentDate,KSDatePickerButtonType buttonType){
        if (buttonType == KSDatePickerButtonCommit) {
            if (result) result(currentDate);
        }
    };
    [picker show];
}

+ (void)runtimePushVcName:(NSString *)vcName dic:(NSDictionary *)dic nav:(UINavigationController *)nav {
    const char *className = [vcName cStringUsingEncoding:NSASCIIStringEncoding];
    Class newClass = objc_getClass(className);
    if (!newClass) {
        Class superClass = [NSObject class];
        newClass = objc_allocateClassPair(superClass, className, 0);
        objc_registerClassPair(newClass);
    }
    id instance = [[newClass alloc] init];
    [dic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([self checkIsExistPropertyWithInstance:instance verifyPropertyName:key]) {
            NSLog(@"%@,%@",obj,key);
            [instance setValue:obj forKey:key];
        }else {
            NSLog(@"不包含key=%@的属性",key);
        }
    }];
    [nav pushViewController:instance animated:YES];
}

/// runtime检测对象是否存在该属性
+ (BOOL)checkIsExistPropertyWithInstance:(id)instance verifyPropertyName:(NSString *)verifyPropertyName {
    unsigned int outCount, i;
    // 获取对象里的属性列表
    objc_property_t * properties = class_copyPropertyList([instance class], &outCount);
    
    for (i = 0; i < outCount; i++) {
        objc_property_t property =properties[i];
        //  属性名转成字符串
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        // 判断该属性是否存在
        if ([propertyName isEqualToString:verifyPropertyName]) {
            free(properties);
            return YES;
        }
    }
    free(properties);
    
    // 再遍历父类中的属性
    Class superClass = class_getSuperclass([instance class]);
    
    //通过下面的方法获取属性列表
    unsigned int outCount2;
    objc_property_t *properties2 = class_copyPropertyList(superClass, &outCount2);
    
    for (int i = 0 ; i < outCount2; i++) {
        objc_property_t property2 = properties2[i];
        //  属性名转成字符串
        NSString *propertyName2 = [[NSString alloc] initWithCString:property_getName(property2) encoding:NSUTF8StringEncoding];
        // 判断该属性是否存在
        if ([propertyName2 isEqualToString:verifyPropertyName]) {
            free(properties2);
            return YES;
        }
    }
    free(properties2); //释放数组
    return NO;
}

@end
