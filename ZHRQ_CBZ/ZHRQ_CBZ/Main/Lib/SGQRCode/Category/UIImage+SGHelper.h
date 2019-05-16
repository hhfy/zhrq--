

#import <UIKit/UIKit.h>

@interface UIImage (SGHelper)
/// 返回一张不超过屏幕尺寸的 image
+ (UIImage *)imageSizeWithScreenImage:(UIImage *)image;

@end
