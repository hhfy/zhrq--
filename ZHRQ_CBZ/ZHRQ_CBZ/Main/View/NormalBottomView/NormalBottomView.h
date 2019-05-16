//
//  NormalBottomView.h
//  ZTXWY
//
//  Created by Mr Lai on 2017/5/16.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NormalBottomView : UIView
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIColor *bgColor;
@property (nonatomic, strong) UIColor *titleColor;
- (void)addTarget:(id)target action:(SEL)action;
@end
