//
//  UIImage+Extension.h
//  新浪微博
//
//  Created by Mr Lai on 2017/1/28.
//  Copyright © 2017年 赖同学. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)
/// 图片裁剪
+ (UIImage *)imageWithName:(NSString *)name border:(CGFloat)boeder boederColor:(UIColor *)color;

/// 截屏功能
+ (instancetype)imageWithCaptureView:(UIView *)view;

/// 图片拉伸
+ (UIImage *)resizableReszieWithImageName:(NSString *)imageName;

/// 图片拉伸2
+ (UIImage *)stretchableReszieWithImageName:(NSString *)imageName;

/// 图片压缩
+ (UIImage *)compressImageWithOriginalImage:(UIImage *)image scale:(CGFloat)scale;

/// 修正照相机拍照方向
+ (UIImage *)fixOrientation:(UIImage *)image;
@end
