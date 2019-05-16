//
//  CustomDatePicker.m
//  YWY2
//
//  Created by Mr Lai on 2017/4/26.
//  Copyright © 2017年 Mr Lai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CustomDatePickerDataSource <NSObject>
@required
/**设置行数数量*/
- (NSInteger)CpickerView:(UIPickerView *_Nullable)pickerView numberOfRowsInPicker:(NSInteger)component;
@optional
/**设置每行的显示富文本字体*/
- (NSAttributedString *_Nonnull)CpickerView:(UIPickerView *_Nullable)pickerView attributedTitleForRowTtile:(NSInteger)row forComponent:(NSInteger)component;
/**设置每行返回的view*/
- (UIView *_Nullable)CpickerView:(UIPickerView *_Nonnull)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(nullable UIView *)view;
@end

@protocol CustomDatePickerDelegate <NSObject>
/**设置每行高度*/
@optional
- (CGFloat)CpickerView:(UIPickerView *_Nonnull)pickerView rowHeightForPicker:(NSInteger)component;
- (void)CpickerView:(UIPickerView *_Nonnull)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
- (void)CpickerView:(UIPickerView *_Nonnull)pickerView didSelectRow:(NSInteger)row;
@end

@interface CustomDatePicker : UIView
@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic, weak) id<CustomDatePickerDataSource>  dataSource;
@property (nonatomic, weak) id<CustomDatePickerDelegate>  delegate;

-(void)selectRow:(NSInteger)rows compant:(NSInteger)Compant withAnimate:(BOOL)Animate;

- (id _Nonnull )initWithSureBtnTitle:(NSString *_Nullable)title mainTitle:(NSString *_Nonnull)mainTitle otherButtonTitle:(NSString *_Nonnull)otherButtonTitle;
/**展现视图*/
- (void)show;
/**移除视图*/
-(void)dismisView;

@end
