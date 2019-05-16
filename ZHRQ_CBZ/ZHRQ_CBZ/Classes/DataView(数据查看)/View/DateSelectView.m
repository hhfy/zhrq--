//
//  DateSelectView.m
//  ZHRQ_CBZ
//
//  Created by Mr Lai on 2017/7/5.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import "DateSelectView.h"

@interface DateSelectView ()
@property (weak, nonatomic) IBOutlet UILabel *lefticonLabel;
@property (weak, nonatomic) IBOutlet UILabel *righticonLabel;
@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIView *rightView;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@end

@implementation DateSelectView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
    [self showFrom:nil];
}

- (void)setupUI {
    self.size = MainScreenSize;
    self.lefticonLabel.font = self.righticonLabel.font = IconFont(15);
    self.lefticonLabel.text = self.righticonLabel.text =DateIconUnicode;
    self.leftView.layer.borderColor = self.rightView.layer.borderColor = SetupColor(227, 227, 227).CGColor;
    self.leftView.layer.borderWidth = self.rightView.layer.borderWidth = 0.5;
    self.leftView.layer.cornerRadius = self.rightView.layer.cornerRadius = 2;
}

- (void)dismiss
{
    if (self.leftDate && self.rightDate) {
        if ([self.delegate respondsToSelector:@selector(didDismiss:)]) {
            [self.delegate didDismiss:self];
        }
    }
    [self removeFromSuperview];
}

- (void)showFrom:(UIView *)from {
    [CurrentWindow addSubview:self];
    CGRect newFrame = [from convertRect:from.bounds toView:CurrentWindow];
    self.centerX = CGRectGetMidX(newFrame);
    self.y = CGRectGetMaxY(newFrame);
    
    if ([self.delegate respondsToSelector:@selector(dropdownMenuDidShow:)]) {
        [self.delegate dropdownMenuDidShow:self];
        [LaiMethod animationWithView:self.leftView];
        [LaiMethod animationWithView:self.rightView];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if ([self.delegate respondsToSelector:@selector(dropdownMenuDidDismiss:)]) {
        [self.delegate dropdownMenuDidDismiss:self];
    }
    [self dismiss];
}

- (void)leftBtnAddTarget:(id)target action:(SEL)action {
    [self.leftBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)rightBtnAddTarget:(id)target action:(SEL)action {
    [self.rightBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)setLeftDate:(NSString *)leftDate {
    _leftDate = [leftDate copy];
    [self.leftBtn setTitle:(leftDate) ? leftDate : @"请选择开始时间" forState:UIControlStateNormal];
    if (self.rightDate) {
        if ([self.delegate respondsToSelector:@selector(didSelectedDate:)]) {
            [self.delegate didSelectedDate:self];
        }
    }
}

- (void)setRightDate:(NSString *)rightDate {
    _rightDate = [rightDate copy];
    [self.rightBtn setTitle:(rightDate) ? rightDate : @"请选择结束时间" forState:UIControlStateNormal];
    if (self.leftDate) {
        if ([self.delegate respondsToSelector:@selector(didSelectedDate:)]) {
            [self.delegate didSelectedDate:self];
        }
    }
}

@end
