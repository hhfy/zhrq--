//
//  NavigationController.m
//
//  Created by Mr Lai on 2017/5/16.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import "NavigationController.h"

@interface NavigationController ()

@end

@implementation NavigationController

+ (void)initialize
{
    [self setNavigationBar];
    
    [self setBarButtonItem];
}

+ (void)setNavigationBar
{
    UINavigationBar *navBar = [UINavigationBar appearance];
    navBar.barStyle = UIBarStyleBlack;
    [navBar setBackgroundImage:SetImage(@"navigationbarBackgroundBule") forBarMetrics:UIBarMetricsDefault];
    navBar.shadowImage = [[UIImage alloc] init];
    
    [navBar setTitleTextAttributes:@{
                                     NSFontAttributeName:TextBoldFont(NavBarTitleFont),
                                     NSForegroundColorAttributeName:SetupColor(255, 255, 255)
                                     }];
}

+ (void)setBarButtonItem
{
    UIBarButtonItem *barItem = [UIBarButtonItem appearance];
    
    [barItem setTitleTextAttributes:@{
                                      NSFontAttributeName: TextSystemFont(NavBarItemFont),
                                      NSForegroundColorAttributeName: SetupColor(255, 255, 255)
                                      } forState:UIControlStateNormal];
    [barItem setTitleTextAttributes:@{
                                      NSFontAttributeName: TextSystemFont(NavBarItemFont),
                                      NSForegroundColorAttributeName: SetupColor(180, 180, 180)
                                      } forState:UIControlStateDisabled];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0)
    {
//        viewController.hidesBottomBarWhenPushed = YES;
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(back) title:LeftArrowIconUnicode nomalColor:SetupColor(255, 255, 255) hightLightColor:SetupColor(180, 180, 180) titleFont:IconFont(20) top:0 left:-25 bottom:0 right:0];
    }
    return [super pushViewController:viewController animated:animated];
}

- (void)back {
    [self popViewControllerAnimated:YES];
}

@end
