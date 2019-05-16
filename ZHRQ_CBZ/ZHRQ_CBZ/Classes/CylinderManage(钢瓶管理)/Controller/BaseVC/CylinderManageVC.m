
//
//  CylinderManageVC.m
//  ZHRQ_CBZ
//
//  Created by Mr Lai on 2017/7/1.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import "CylinderManageVC.h"
#import "DisableCylinderVC.h"
#import "AllCylinderVC.h"
#import "NormalCylinderVC.h"
#import "AbnormalCylinderVC.h"
#import "WithholdCylinderVC.h"

@interface CylinderManageVC ()

@end

@implementation CylinderManageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupValue];
}

- (void)setupValue {
    self.title = self.titleString;
}

- (void)addChildVC {
    AllCylinderVC *allCylinderVc = [[AllCylinderVC alloc] init];
    allCylinderVc.title = @"全部钢瓶";
    [self addChildViewController:allCylinderVc];

    NormalCylinderVC *normalCylinderVc = [[NormalCylinderVC alloc] init];
    normalCylinderVc.title = @"正常钢瓶";
    [self addChildViewController:normalCylinderVc];
   
    AbnormalCylinderVC *abnormalCylinderVc = [[AbnormalCylinderVC alloc] init];
    abnormalCylinderVc.title = @"异常钢瓶";
    [self addChildViewController:abnormalCylinderVc];
   
    DisableCylinderVC *disableCylinderVc = [[DisableCylinderVC alloc] init];
    disableCylinderVc.title = @"禁用钢瓶";
    [self addChildViewController:disableCylinderVc];
    
    WithholdCylinderVC *withholdCylinderVc = [[WithholdCylinderVC alloc] init];
    withholdCylinderVc.title = @"暂扣钢瓶";
    [self addChildViewController:withholdCylinderVc];
}

@end
