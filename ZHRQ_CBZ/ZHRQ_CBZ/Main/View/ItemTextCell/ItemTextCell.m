//
//  ItemTextCell.m
//  ZTXWYGL
//
//  Created by Mr Lai on 2017/6/14.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import "ItemTextCell.h"

@interface ItemTextCell ()
@property (weak, nonatomic) IBOutlet UILabel *itemTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemTextLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *itemTextLeftSpace;
@end

@implementation ItemTextCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupValue];
}

- (void)setupValue {
    if (iPhone5) {
        self.itemTextLeftSpace.constant = 30;
    } else if (iPhone6) {
        self.itemTextLeftSpace.constant = 40;
    } else if (iPhone6P) {
        self.itemTextLeftSpace.constant = 50;
    }
}

- (void)setText:(NSString *)text {
    _text = [text copy];
    self.itemTextLabel.text = text;
}

- (void)setTitle:(NSString *)title {
    _title = [title copy];
    self.itemTitleLabel.text = title;
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    self.itemTextLabel.textColor = textColor;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    if (self.highlighted) {
        POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewScaleXY];
        scaleAnimation.duration = 0.1;
        scaleAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)];
        scaleAnimation.beginTime = CACurrentMediaTime() + 0.01;
        [self.itemTextLabel pop_addAnimation:scaleAnimation forKey:@"scalingUp"];
    } else {
        POPSpringAnimation *sprintAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
        sprintAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)];
        sprintAnimation.velocity = [NSValue valueWithCGPoint:CGPointMake(2, 2)];
        sprintAnimation.springBounciness = 20.f;
        sprintAnimation.beginTime = CACurrentMediaTime() + 0.01;
        [self.itemTextLabel pop_addAnimation:sprintAnimation forKey:@"springAnimation"];
    }
}

@end
