//
//  AlertPopViewTool.m
//  ZHRQ_CBZ
//
//  Created by Mr Lai on 2017/7/14.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import "AlertPopViewTool.h"

static UIView *_currentView;
static UIView *_currentBgView;

@implementation AlertPopViewTool

+ (void)popView:(UIView *)view animated:(BOOL)animated {
    // 保存当前弹出的视图
    _currentView = view;
    
    CGFloat halfScreenWidth = [[UIScreen mainScreen] bounds].size.width * 0.5;
    CGFloat halfScreenHeight = [[UIScreen mainScreen] bounds].size.height * 0.5;
    // 屏幕中心
    CGPoint screenCenter = CGPointMake(halfScreenWidth, halfScreenHeight);
    view.center = screenCenter;
    UIWindow *keyWindow = [self getCurrentWindowView];
    UIView *bgView = [[UIView alloc] init];
    bgView.size = MainScreenSize;
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = 0;
    [keyWindow addSubview:bgView];
    [keyWindow addSubview:view];
    _currentBgView = bgView;
    
    if (animated) {
        [UIView animateWithDuration:0.3 animations:^{
            bgView.alpha = 0.3;
        }];
        CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        popAnimation.duration = 0.4;
        popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                                [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                                [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                                [NSValue valueWithCATransform3D:CATransform3DIdentity]];
        popAnimation.keyTimes = @[@0.0f, @0.5f, @0.75f, @1.0f];
        popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                         [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                         [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [view.layer addAnimation:popAnimation forKey:nil];
    }
}

+ (void)closeAnimated:(BOOL)animated {
    if (animated) {
        [UIView animateWithDuration:0.2
                         animations:^{
                             // 第一步： 以动画的形式将view慢慢放大至原始大小的1.2倍
                             _currentView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
                         }
                         completion:^(BOOL finished) {
                             [UIView animateWithDuration:0.3
                                              animations:^{
                                                  // 第二步： 以动画的形式将view缩小至原来的1/1000分之1倍
                                                  _currentBgView.alpha = 0;
                                                  _currentView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
                                              }
                                              completion:^(BOOL finished) {
                                                  // 第三步： 移除
                                                  [_currentView removeFromSuperview];
                                              }];
                         }];
    } else {
        [_currentView removeFromSuperview];
    }
}

+ (UIWindow *)getCurrentWindowView {
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    return window;
}
@end
