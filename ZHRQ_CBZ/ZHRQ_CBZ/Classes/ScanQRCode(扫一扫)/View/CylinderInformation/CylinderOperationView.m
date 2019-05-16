
//
//  CylinderOperationView.m
//  ZHRQ_CBZ
//
//  Created by Mr Lai on 2017/7/4.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import "CylinderOperationView.h"
#import "Cylinder.h"

@interface CylinderOperationView ()
@property (weak, nonatomic) IBOutlet UIButton *moveCylinderBtn;
@property (weak, nonatomic) IBOutlet UIButton *InflationCylinderBtn;
@end

@implementation CylinderOperationView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    self.width = MainScreenSize.width;
    self.moveCylinderBtn.layer.cornerRadius = self.moveCylinderBtn.height * 0.5;
    self.InflationCylinderBtn.layer.cornerRadius = self.InflationCylinderBtn.height * 0.5;
}

- (void)setCylinderInfo:(CylinderInfo *)cylinderInfo {
    _cylinderInfo = cylinderInfo;
    if (cylinderInfo.proc_status > 1) {
        self.moveCylinderBtn.enabled = NO;
        self.InflationCylinderBtn.enabled = NO;
    } else {
        self.moveCylinderBtn.enabled = [cylinderInfo.store_id isEqualToString:[SaveTool objectForKey:StoreId]] || [cylinderInfo.supply_id isEqualToString:@"0"] || (cylinderInfo.supply_id == nil);
        self.InflationCylinderBtn.enabled = [cylinderInfo.store_id isEqualToString:[SaveTool objectForKey:StoreId]] || [cylinderInfo.store_id isEqualToString:@"0"] || (cylinderInfo.store_id == nil);
    }
    
    self.moveCylinderBtn.backgroundColor = (self.moveCylinderBtn.isEnabled) ? SetupColor(74, 130, 243) : SetupColor(198, 198, 198);
    self.InflationCylinderBtn.backgroundColor = (self.InflationCylinderBtn.isEnabled) ? SetupColor(250, 125, 70) : SetupColor(198, 198, 198);
}

- (IBAction)moveCylinderBtn:(UIButton *)button {
    [LaiMethod animationWithView:button];
}

- (IBAction)inFlationCylinderBtn:(UIButton *)button {
    [LaiMethod animationWithView:button];
}


- (void)moveCylinderBtnAddTarget:(id)target action:(SEL)action {
    [self.moveCylinderBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)inFlationCylinderBtnAddTarget:(id)target action:(SEL)action {
    [self.InflationCylinderBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

@end
