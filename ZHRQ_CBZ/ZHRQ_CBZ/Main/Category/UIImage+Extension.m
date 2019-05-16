//
//  UIImage+Extension.m
//  新浪微博
//
//  Created by Mr Lai on 2017/1/28.
//  Copyright © 2017年 赖同学. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)

// 图片裁剪
+ (UIImage *)imageWithName:(NSString *)name border:(CGFloat)boeder boederColor:(UIColor *)color
{
    // 圆环宽度
    CGFloat borderW = boeder;
    
    // 加载旧的图片
    UIImage *oldImg = [UIImage imageNamed:name];
    
    // 新的图片尺寸
    CGFloat imgW = oldImg.size.width + 2 * borderW;
    CGFloat imgH = oldImg.size.height + 2 * borderW;
    
    // 在开发中遇到实际问题是，长方形的图片裁剪会有锯齿
    CGFloat circleW = imgW > imgH ? imgH : imgW;
    
    // 开启上下文
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(circleW, circleW), NO, 0.0);
    
    // 先画一个大圆
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, circleW, circleW)];
    // 获取当前的上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextAddPath(ctx, path.CGPath);
    
    [[UIColor whiteColor] set];
    
    // 渲染到视图
    CGContextFillPath(ctx);
    
    CGRect clipR = CGRectMake(borderW, borderW, oldImg.size.width, oldImg.size.height);
    
    // 画圆，正切与旧圆的圆
    UIBezierPath *clipPath = [UIBezierPath bezierPathWithOvalInRect:clipR];
    
    // 设置裁剪区域
    [clipPath addClip];
    
    [oldImg drawAtPoint:CGPointMake(borderW, borderW)];
    
    // 生成新图片
    UIImage *newImg = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭上下文
    UIGraphicsEndImageContext();
    
    return newImg;
}

// 截屏功能
+ (instancetype)imageWithCaptureView:(UIView *)view
{
    // 开启上下文
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 0.0);
    
    // 获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 渲染控制器View的图层到上下文(图层只能用渲染，不能用draw）
    [view.layer renderInContext:ctx];
    
    // 获取截屏图片
    UIImage *newImg = UIGraphicsGetImageFromCurrentImageContext();
    
    // 关闭上下文
    UIGraphicsEndImageContext();
    
    return newImg;
}

// 拉升图片1
+ (UIImage *)resizableReszieWithImageName:(NSString *)imageName
{
    UIImage *nomalImg = [UIImage imageNamed:imageName];
    CGFloat ImgW = nomalImg.size.width * 0.5f - 1;
    CGFloat ImgH = nomalImg.size.height * 0.5f - 1;
    
    UIImage *reszieImg = [nomalImg resizableImageWithCapInsets:UIEdgeInsetsMake(ImgH, ImgW, ImgH, ImgW)];
    return reszieImg;
}

// 拉升图片2
+ (UIImage *)stretchableReszieWithImageName:(NSString *)imageName
{
    UIImage *nomalImg = [UIImage imageNamed:imageName];
    CGFloat ImgW = nomalImg.size.width * 0.5f;
    CGFloat ImgH = nomalImg.size.height * 0.5;
    
    UIImage *reszieImg = [nomalImg stretchableImageWithLeftCapWidth:ImgW topCapHeight:ImgH];
    return reszieImg;
}


+ (UIImage *)compressImageWithOriginalImage:(UIImage *)image scale:(CGFloat)scale {
    NSData *imgData = UIImageJPEGRepresentation(image, scale);
    return [UIImage imageWithData:imgData];
}


+ (UIImage *)fixOrientation:(UIImage *)image {
    if (image.imageOrientation == UIImageOrientationUp) return image;
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch (image.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, image.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, image.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (image.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    CGContextRef ctx = CGBitmapContextCreate(NULL, image.size.width, image.size.height,
                                             CGImageGetBitsPerComponent(image.CGImage), 0,
                                             CGImageGetColorSpace(image.CGImage),
                                             CGImageGetBitmapInfo(image.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (image.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.height,image.size.width), image.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.width,image.size.height), image.CGImage);
            break;
    }
    
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

@end
