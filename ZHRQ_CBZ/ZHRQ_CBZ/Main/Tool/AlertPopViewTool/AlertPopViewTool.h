//
//  AlertPopViewTool.h
//  ZHRQ_CBZ
//
//  Created by Mr Lai on 2017/7/14.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertPopViewTool : UIView
+ (void)popView:(UIView *)view animated:(BOOL)animated;
+ (void)closeAnimated:(BOOL)animated;
@end
