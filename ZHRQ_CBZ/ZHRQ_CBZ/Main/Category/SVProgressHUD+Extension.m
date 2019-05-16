//
//  SVProgressHUD+Extension.m
//
//  Created by Mr Lai on 2017/6/28.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import "SVProgressHUD+Extension.h"

@implementation SVProgressHUD (Extension)

/// SVProgress增强版
+ (void)showBeginAnimation {
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setActivityIndicatorType:DDActivityIndicatorAnimationTypeBallClipRotateMultiple];
    [SVProgressHUD setActivityIndicatorTintColor:[UIColor whiteColor]];
    [SVProgressHUD show];
}

@end
