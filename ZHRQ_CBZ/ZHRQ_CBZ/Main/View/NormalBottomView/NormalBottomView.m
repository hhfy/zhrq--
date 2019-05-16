//
//  NormalBottomView.m
//  ZTXWY
//
//  Created by Mr Lai on 2017/5/16.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import "NormalBottomView.h"

@interface NormalBottomView ()
@property (weak, nonatomic) IBOutlet UIButton *itemButton;
@end

@implementation NormalBottomView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    self.width = MainScreenSize.width;
    self.height = 60;
    self.itemButton.layer.cornerRadius = self.itemButton.height * 0.5;
    self.itemButton.clipsToBounds = YES;
}

- (void)setTitle:(NSString *)title {
     _title = [title copy];
    [self.itemButton setTitle:title forState:UIControlStateNormal];
}

- (void)setBgColor:(UIColor *)bgColor {
    _bgColor = bgColor;
    self.itemButton.backgroundColor = bgColor;
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    [self.itemButton setTitleColor:titleColor forState:UIControlStateNormal];
}

- (void)addTarget:(id)target action:(SEL)action {
    [self.itemButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (IBAction)nextStepBtn:(UIButton *)button {
    POPSpringAnimation *sprintAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    sprintAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)];
    sprintAnimation.velocity = [NSValue valueWithCGPoint:CGPointMake(5, 5)];
    sprintAnimation.springSpeed = 20;
    sprintAnimation.springBounciness = 10.f;
    sprintAnimation.beginTime = CACurrentMediaTime() + 0.01;
    [button pop_addAnimation:sprintAnimation forKey:@"springAnimation"];
}

@end
