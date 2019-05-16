
//
//  CylinderInformationCell.m
//  ZHRQ_CBZ
//
//  Created by Mr Lai on 2017/7/3.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import "CylinderInformationCell.h"
#import "Cylinder.h"

@interface CylinderInformationCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@end

@implementation CylinderInformationCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setCylinderInfo:(CylinderInfo *)cylinderInfo {
    _cylinderInfo = cylinderInfo;
    self.nameLabel.text = cylinderInfo.name;
    self.timeLabel.text = [NSString stringFromTimestampFromat:cylinderInfo.add_time formatter:FmtYMDHM];
    switch (cylinderInfo.proc_status) {
        case 1:
            self.statusLabel.textColor = SetupColor(70, 159, 250);
            break;
        case 2:
            self.statusLabel.textColor = SetupColor(247, 57, 57);
            break;
        default:
            break;
    }
        switch (cylinderInfo.operation) {
        case 0:
            self.statusLabel.text = @"激活";
            break;
        case 1:
            self.statusLabel.text = @"充装";
            break;
        case 2:
            self.statusLabel.text = @"送瓶";
            break;
        case 3:
            self.statusLabel.text = @"使用中";
            self.phoneLabel.text = cylinderInfo.mobile;
            break;
        case 4:
            self.statusLabel.text = @"收瓶";
            break;
        default:
            break;
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    if (self.highlighted) {
        POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewScaleXY];
        scaleAnimation.duration = 0.1;
        scaleAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)];
        scaleAnimation.beginTime = CACurrentMediaTime() + 0.01;
        [self.statusLabel pop_addAnimation:scaleAnimation forKey:@"scalingUp"];
    } else {
        POPSpringAnimation *sprintAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
        sprintAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)];
        sprintAnimation.velocity = [NSValue valueWithCGPoint:CGPointMake(15, 15)];
        sprintAnimation.springBounciness = 20.f;
        sprintAnimation.springSpeed = 30.f;
        sprintAnimation.beginTime = CACurrentMediaTime() + 0.01;
        [self.statusLabel pop_addAnimation:sprintAnimation forKey:@"springAnimation"];
    }
}

@end
