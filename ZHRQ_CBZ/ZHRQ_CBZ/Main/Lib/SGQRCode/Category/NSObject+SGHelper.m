

#import "NSObject+SGHelper.h"

@implementation NSObject (SGHelper)

/// 获取当前控制器
- (UIViewController *)SG_getCurrentViewController {
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    if (vc.presentedViewController) {
        if ([vc.presentedViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *navVc = (UINavigationController *)vc.presentedViewController;
            vc = navVc.visibleViewController;
        } else if ([vc.presentedViewController isKindOfClass:[UITabBarController class]]){
            UITabBarController *tabVc = (UITabBarController *)vc.presentedViewController;
            if ([tabVc.selectedViewController isKindOfClass:[UINavigationController class]]) {
                UINavigationController *navVc = (UINavigationController *)tabVc.selectedViewController;
                return navVc.visibleViewController;
            } else {
                return tabVc.selectedViewController;
            }
        } else {
            vc = vc.presentedViewController;
        }
        
    } else {
        if ([vc isKindOfClass:[UITabBarController class]]) {
            UITabBarController *tabVc = (UITabBarController *)vc;
            if ([tabVc.selectedViewController isKindOfClass:[UINavigationController class]]) {
                UINavigationController *navVc = (UINavigationController *)tabVc.selectedViewController;
                return navVc.visibleViewController;
            } else{
                return tabVc.selectedViewController;
            }
        } else if ([vc isKindOfClass:[UINavigationController class]]){
            UINavigationController *navVc = (UINavigationController *)vc;
            vc = navVc.visibleViewController;
        }
    }
    return vc;
}


@end
