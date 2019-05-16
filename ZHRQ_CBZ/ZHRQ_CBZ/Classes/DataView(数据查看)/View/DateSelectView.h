//
//  DateSelectView.h
//  ZHRQ_CBZ
//
//  Created by Mr Lai on 2017/7/5.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DateSelectView;
@protocol DataSelectViewDelegate <NSObject>
@optional;
- (void)dropdownMenuDidDismiss:(DateSelectView *)menu;
- (void)dropdownMenuDidShow:(DateSelectView *)menu;
- (void)dateSelectView:(DateSelectView *)dateSelectView leftBtnClick:(UIButton *)leftBtn;
- (void)dateSelectView:(DateSelectView *)dateSelectView rightBtnClick:(UIButton *)rightBtn;
- (void)didSelectedDate:(DateSelectView *)menu;
- (void)didDismiss:(DateSelectView *)dateSelectView;
@end

@interface DateSelectView : UIView
@property (nonatomic, weak) id<DataSelectViewDelegate> delegate;
@property (nonatomic, copy) NSString *leftDate;
@property (nonatomic, copy) NSString *rightDate;
- (void)leftBtnAddTarget:(id)target action:(SEL)action;
- (void)rightBtnAddTarget:(id)target action:(SEL)action;
- (void)showFrom:(UIView *)from;
- (void)dismiss;
@end
