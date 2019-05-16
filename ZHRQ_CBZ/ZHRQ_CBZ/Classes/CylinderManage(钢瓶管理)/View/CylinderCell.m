
//
//  CylinderCell.m
//  ZHRQ_CBZ
//
//  Created by Mr Lai on 2017/7/5.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import "CylinderCell.h"
#import "Cylinder.h"

@interface CylinderCell ()
@property (weak, nonatomic) IBOutlet UILabel *cylinderNOLabel;
@property (weak, nonatomic) IBOutlet UILabel *cylinderSpecificationLabel;
@property (weak, nonatomic) IBOutlet UILabel *cylinderStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation CylinderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    self.cylinderStatusLabel.layer.borderWidth = 0.5;
    self.cylinderStatusLabel.layer.cornerRadius = self.cylinderStatusLabel.height * 0.5;
}

- (void)setCylinder:(Cylinder *)cylinder {
    _cylinder = cylinder;
    self.cylinderSpecificationLabel.text = [NSString stringWithFormat:@"规格：%@kg", cylinder.format];
    self.cylinderNOLabel.text = [NSString stringWithFormat:@"钢瓶编号：%@", cylinder.no];
    self.timeLabel.text = [NSString stringFromTimestampFromat:cylinder.add_time formatter:FmtYMDHM];
    
    // 状态：1->正常，2->异常，3->禁用
    switch (cylinder.proc_status) {
        case 1:
        {
            self.cylinderStatusLabel.layer.borderColor = SetupColor(53, 190, 117).CGColor;
            self.cylinderStatusLabel.text = @"正常";
            self.cylinderStatusLabel.textColor = SetupColor(53, 190, 117);
        }
            break;
        case 2:
        {
            self.cylinderStatusLabel.layer.borderColor = SetupColor(237, 46, 46).CGColor;
            self.cylinderStatusLabel.text = @"异常";
            self.cylinderStatusLabel.textColor = SetupColor(237, 46, 46);
        }
            break;
        case 3:
        {
            self.cylinderStatusLabel.layer.borderColor = SetupColor(220, 159, 52).CGColor;
            self.cylinderStatusLabel.text = @"禁用";
            self.cylinderStatusLabel.textColor = SetupColor(220, 159, 52);
        }
            break;
        case 4:
        {
            self.cylinderStatusLabel.layer.borderColor = SetupColor(115, 96, 212).CGColor;
            self.cylinderStatusLabel.text = @"暂扣";
            self.cylinderStatusLabel.textColor = SetupColor(115, 96, 212);
        }
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
        [self.cylinderStatusLabel pop_addAnimation:scaleAnimation forKey:@"scalingUp"];
    } else {
        POPSpringAnimation *sprintAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
        sprintAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)];
        sprintAnimation.velocity = [NSValue valueWithCGPoint:CGPointMake(15, 15)];
        sprintAnimation.springBounciness = 20.f;
        sprintAnimation.springSpeed = 30.f;
        sprintAnimation.beginTime = CACurrentMediaTime() + 0.01;
        [self.cylinderStatusLabel pop_addAnimation:sprintAnimation forKey:@"springAnimation"];
    }
}

@end
