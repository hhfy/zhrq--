//
//  BaseViewController.m
//
//  Created by Mr Lai on 2017/5/16.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.sess_id = [SaveTool objectForKey:SessID];
    self.user_id = [SaveTool objectForKey:UserID];
    self.store_id = [SaveTool objectForKey:StoreId];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = SetupColor(238, 243, 248);
    self.automaticallyAdjustsScrollViewInsets = NO;
}

@end
