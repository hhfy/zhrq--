//
//  KSDatePicker.h
//  ZTXWY
//
//Copyright © 2017年 Xu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KSDatePickerAppearance.h"

@interface KSDatePicker : UIView

@property (nonatomic, strong) KSDatePickerAppearance* appearance;

- (void)reloadAppearance;

- (void)show;
- (void)hidden;

@end

