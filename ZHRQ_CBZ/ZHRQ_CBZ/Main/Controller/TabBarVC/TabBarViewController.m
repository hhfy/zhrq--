//
//  TabBarVcViewController.m
//
//  Created by Mr Lai on 2017/5/16.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import "TabBarViewController.h"
#import "NavigationController.h"


@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    CommunityVC *communityVC = [[CommunityVC alloc] init];
//    [self addChildViewController:communityVC title:@"社区" image:@"community" selectedImage:@"community_selected"];
//    
//    ServiceVC *serviceVC = [[ServiceVC alloc] init];
//    [self addChildViewController:serviceVC title:@"服务" image:@"service" selectedImage:@"service_selected"];
//    
//    ProfileVC *profileVC = [[ProfileVC alloc] init];
//    [self addChildViewController:profileVC title:@"我的" image:@"profile" selectedImage:@"profile_selected"];
//
//    
//    // 设置默认启动控制器(默认的是0)
//    self.selectedViewController = self.childViewControllers[0];
}

- (void)addChildViewController:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectdeImage
{
    childVc.title = title;
    childVc.tabBarItem.image = SetImage(image);
    childVc.tabBarItem.selectedImage = [SetImage(selectdeImage) imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [childVc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:SetupColor(146, 146, 146)} forState:UIControlStateNormal];
    [childVc.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:SetupColor(104, 121, 242)} forState:UIControlStateSelected];
    NavigationController *nav = [[NavigationController alloc] initWithRootViewController:childVc];
    [self addChildViewController:nav];
}



@end
