//
//  EmployeeCell.m
//  ZHRQ_CBZ
//
//  Created by Mr Lai on 2017/7/1.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import "EmployeeCell.h"
#import "Employee.h"

@interface EmployeeCell ()
@property (weak, nonatomic) IBOutlet UIButton *callPhoneBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@end

@implementation EmployeeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    self.callPhoneBtn.titleLabel.font = IconFont(17);
    [self.callPhoneBtn setTitle:CallPhoneUnicode forState:UIControlStateNormal];
}

- (void)setEmployee:(Employee *)employee {
    _employee = employee;
    self.callPhoneBtn.tag = self.tag;
    self.nameLabel.text = employee.name;
    self.phoneLabel.text = employee.account;
}

- (IBAction)callPhoneBtnClick:(UIButton *)button {
    [self animationWithButton:button];
}

- (void)animationWithButton:(UIButton *)button {
    if (button.width != self.callPhoneBtn.width) return;
    POPSpringAnimation *sprintAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    sprintAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)];
    sprintAnimation.velocity = [NSValue valueWithCGPoint:CGPointMake(20, 20)];
    sprintAnimation.springSpeed = 20;
    sprintAnimation.springBounciness = 10.f;
    sprintAnimation.beginTime = CACurrentMediaTime() + 0.01;
    [button pop_addAnimation:sprintAnimation forKey:@"springAnimation"];
    
    WeakSelf(weakSelf)
    sprintAnimation.animationDidReachToValueBlock = ^(POPAnimation *anim) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((KeyboradDuration * 0.1) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([weakSelf.delegate respondsToSelector:@selector(employeeCell:callPhoneBtnDidClic:)]) {
                [weakSelf.delegate employeeCell:self callPhoneBtnDidClic:button];
            }
        });
    };
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    if (self.highlighted) {
        POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewScaleXY];
        scaleAnimation.duration = 0.1;
        scaleAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)];
        scaleAnimation.beginTime = CACurrentMediaTime() + 0.01;
        [self.callPhoneBtn pop_addAnimation:scaleAnimation forKey:@"scalingUp"];
    } else {
        POPSpringAnimation *sprintAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
        sprintAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)];
        sprintAnimation.velocity = [NSValue valueWithCGPoint:CGPointMake(15, 15)];
        sprintAnimation.springBounciness = 20.f;
        sprintAnimation.springSpeed = 30.f;
        sprintAnimation.beginTime = CACurrentMediaTime() + 0.01;
        [self.callPhoneBtn pop_addAnimation:sprintAnimation forKey:@"springAnimation"];
    }
}

@end
