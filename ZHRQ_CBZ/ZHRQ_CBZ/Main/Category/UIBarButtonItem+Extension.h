//
//  UIBarButtonItem+Extension.h
//
//  Created by Mr Lai on 2017/1/28.
//  Copyright © 2017年 赖同学. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)
/// 自定义UIBarButtonItem图片和高亮图片还有上下左右间距
+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image hightLightImage:(NSString *)hightLightImage selectedImage:(NSString *)selectedImage top:(CGFloat)top left:(CGFloat)left bottom:(CGFloat)bottom right:(CGFloat)right;
/// 自定义UIBarButtonItem标题，普通和高亮颜色还有上下左右间距
+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action title:(NSString *)title nomalColor:(UIColor *)nomalColor hightLightColor:(UIColor *)hightLightColor titleFont:(UIFont *)titleFont top:(CGFloat)top left:(CGFloat)left bottom:(CGFloat)bottom right:(CGFloat)right;
/// 自定义UIBarButtonItem标题，普通和高亮颜色、图片和高亮图片还有上下左右间距
+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action title:(NSString *)title nomalColor:(UIColor *)nomalColor hightLightColor:(UIColor *)hightLightColor titleFont:(UIFont *)titleFont image:(NSString *)image hightLightImage:(NSString *)hightLightImage top:(CGFloat)top left:(CGFloat)left bottom:(CGFloat)bottom right:(CGFloat)right;
@end
