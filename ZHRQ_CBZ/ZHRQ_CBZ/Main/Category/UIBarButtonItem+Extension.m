//
//  UIBarButtonItem+Extension.m
//
//  Created by Mr Lai on 2017/1/28.
//  Copyright © 2017年 赖同学. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"

@implementation UIBarButtonItem (Extension)

+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image hightLightImage:(NSString *)hightLightImage selectedImage:(NSString *)selectedImage top:(CGFloat)top left:(CGFloat)left bottom:(CGFloat)bottom right:(CGFloat)right
{
    UIButton *itemBtn = [[UIButton alloc] init];
    [itemBtn setImage:SetImage(image) forState:UIControlStateNormal];
    [itemBtn setImage:SetImage(hightLightImage) forState:UIControlStateHighlighted];
    [itemBtn setImage:SetImage(selectedImage) forState:UIControlStateSelected];
    [itemBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [itemBtn sizeToFit];
    itemBtn.contentEdgeInsets = UIEdgeInsetsMake(top, left, bottom, right);
    return [[UIBarButtonItem alloc] initWithCustomView:itemBtn];
}

+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action title:(NSString *)title nomalColor:(UIColor *)nomalColor hightLightColor:(UIColor *)hightLightColor titleFont:(UIFont *)titleFont top:(CGFloat)top left:(CGFloat)left bottom:(CGFloat)bottom right:(CGFloat)right
{
    UIButton *itemBtn = [[UIButton alloc] init];
    [itemBtn setTitle:title forState:UIControlStateNormal];
    [itemBtn setTitleColor:nomalColor forState:UIControlStateNormal];
    [itemBtn setTitleColor:hightLightColor forState:UIControlStateHighlighted];
    [itemBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    itemBtn.titleLabel.font = titleFont;
    [itemBtn sizeToFit];
    itemBtn.contentEdgeInsets = UIEdgeInsetsMake(top, left, bottom, right);
    return [[UIBarButtonItem alloc] initWithCustomView:itemBtn];
}

+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action title:(NSString *)title nomalColor:(UIColor *)nomalColor hightLightColor:(UIColor *)hightLightColor titleFont:(UIFont *)titleFont image:(NSString *)image hightLightImage:(NSString *)hightLightImage top:(CGFloat)top left:(CGFloat)left bottom:(CGFloat)bottom right:(CGFloat)right
{
    UIButton *itemBtn = [[UIButton alloc] init];
    [itemBtn setTitle:title forState:UIControlStateNormal];
    [itemBtn setTitleColor:nomalColor forState:UIControlStateNormal];
    [itemBtn setTitleColor:hightLightColor forState:UIControlStateHighlighted];
    [itemBtn setImage:SetImage(image) forState:UIControlStateNormal];
    [itemBtn setImage:SetImage(hightLightImage) forState:UIControlStateHighlighted];
    [itemBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    itemBtn.titleLabel.font = titleFont;
    [itemBtn sizeToFit];
    itemBtn.contentEdgeInsets = UIEdgeInsetsMake(top, left, bottom, right);
    return [[UIBarButtonItem alloc] initWithCustomView:itemBtn];
}

@end
