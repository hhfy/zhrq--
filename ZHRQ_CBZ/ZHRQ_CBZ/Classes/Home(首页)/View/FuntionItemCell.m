
//
//  FuntionItemCell.m
//  ZHRQ_CBZ
//
//  Created by Mr Lai on 2017/7/1.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import "FuntionItemCell.h"
#import "Function.h"

@interface FuntionItemCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@end

@implementation FuntionItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

#define LineW 0.5
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [SetupColor(227, 227, 227) setFill];
    UIRectFill(CGRectMake(0, rect.size.height - LineW, rect.size.width, LineW));
    UIRectFill(CGRectMake(rect.size.width - LineW, 0, LineW, rect.size.height));
}

- (void)setFunction:(Function *)function {
    _function = function;
    self.titleTextLabel.text = function.title;
    self.subTitleLabel.text = function.subTitle;
    self.iconView.image = function.icon;
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    if (self.highlighted) {
        POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewScaleXY];
        scaleAnimation.duration = 0.1;
        scaleAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)];
        scaleAnimation.beginTime = CACurrentMediaTime() + 0.01;
        [self.iconView pop_addAnimation:scaleAnimation forKey:@"scalingUp"];
    } else {
        POPSpringAnimation *sprintAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
        sprintAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)];
        sprintAnimation.velocity = [NSValue valueWithCGPoint:CGPointMake(15, 15)];
        sprintAnimation.springBounciness = 20.f;
        sprintAnimation.springSpeed = 30.f;
        sprintAnimation.beginTime = CACurrentMediaTime() + 0.01;
        [self.iconView pop_addAnimation:sprintAnimation forKey:@"springAnimation"];
    }
}

@end
