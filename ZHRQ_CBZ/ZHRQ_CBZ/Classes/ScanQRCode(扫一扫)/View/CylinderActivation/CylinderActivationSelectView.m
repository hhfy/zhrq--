//
//  CylinderActivationSelectView.m
//  ZHRQ_CBZ
//
//  Created by Mr Lai on 2017/7/3.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import "CylinderActivationSelectView.h"

@interface CylinderActivationSelectView ()
@property (weak, nonatomic) IBOutlet UIButton *firstBtn;
@property (weak, nonatomic) IBOutlet UIButton *secondBtn;
@property (weak, nonatomic) IBOutlet UIButton *thirdBtn;
@property (weak, nonatomic) IBOutlet UILabel *arrowLabel;
@property (weak, nonatomic) IBOutlet UIView *dateView;
@property (weak, nonatomic) IBOutlet UILabel *seletedDateLabel;
@end

@implementation CylinderActivationSelectView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

#define NormalColor SetupColor(153, 153, 153)
#define SelectedColor SetupColor(255, 255, 255)

- (void)setupUI {
    self.width = MainScreenSize.width;
    self.firstBtn.layer.cornerRadius = self.secondBtn.layer.cornerRadius = self.thirdBtn.layer.cornerRadius = 5;
    self.firstBtn.layer.borderWidth = self.secondBtn.layer.borderWidth = self.thirdBtn.layer.borderWidth = 0.5;
    self.firstBtn.layer.borderColor = self.secondBtn.layer.borderColor = self.thirdBtn.layer.borderColor = NormalColor.CGColor;
    self.arrowLabel.font = IconFont(15);
    self.arrowLabel.text = RightArrowIconUnicode;
    [self.dateView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dateViewTap)]];
    [self.firstBtn setTitleColor:NormalColor forState:UIControlStateNormal];
    [self.firstBtn setTitleColor:SelectedColor forState:UIControlStateSelected];
    [self.secondBtn setTitleColor:NormalColor forState:UIControlStateNormal];
    [self.secondBtn setTitleColor:SelectedColor forState:UIControlStateSelected];
    [self.thirdBtn setTitleColor:NormalColor forState:UIControlStateNormal];
    [self.thirdBtn setTitleColor:SelectedColor forState:UIControlStateSelected];
}

- (IBAction)firstBtnClick:(UIButton *)button {
    [self changeSelectStatusWithBtn:button otherBtnA:self.secondBtn otherBtnB:self.thirdBtn];
    [self currentSelectedSpecification:5.0f];
    [LaiMethod animationWithView:button];
}

- (IBAction)secondBtnClick:(UIButton *)button {
    [self changeSelectStatusWithBtn:button otherBtnA:self.firstBtn otherBtnB:self.thirdBtn];
    [self currentSelectedSpecification:15.0f];
    [LaiMethod animationWithView:button];
}

- (IBAction)thirdBtnClick:(UIButton *)button {
    [self changeSelectStatusWithBtn:button otherBtnA:self.firstBtn otherBtnB:self.secondBtn];
    [self currentSelectedSpecification:50.0f];
    [LaiMethod animationWithView:button];
}

- (void)changeSelectStatusWithBtn:(UIButton *)btn otherBtnA:(UIButton *)btnA otherBtnB:(UIButton *)btnB {
    btn.selected = YES;
    btnA.selected = NO;
    btnB.selected = NO;
    if (btn.isSelected) {
        btn.backgroundColor = SetupColor(70, 159, 250);
        btnA.backgroundColor = btnB.backgroundColor = SetupColor(255, 255, 255);
        btnA.layer.borderWidth = btnB.layer.borderWidth = 0.5;
        btn.layer.borderWidth = 0;
    } else {
        btn.backgroundColor = SetupColor(255, 255, 255);
        btnA.backgroundColor = btnB.backgroundColor = SetupColor(70, 159, 250);
        btnA.layer.borderWidth = btnB.layer.borderWidth = 0.5;
        btn.layer.borderWidth = 0.5;
    }
}

- (void)setSeletedDate:(NSString *)seletedDate {
    _seletedDate = [seletedDate copy];
    self.seletedDateLabel.text = (seletedDate) ? seletedDate : @"请选择年检时间";
}

- (void)dateViewTap {
    if ([self.delegate respondsToSelector:@selector(didTapCylinderActivationSelectView:)]) {
        [self.delegate didTapCylinderActivationSelectView:self];
    }
}

- (void)currentSelectedSpecification:(CGFloat)specification {
    if ([self.delegate respondsToSelector:@selector(cylinderActivationSelectView:didSelectedWithSpecification:)]) {
        [self.delegate cylinderActivationSelectView:self didSelectedWithSpecification:specification];
    }
}

@end
