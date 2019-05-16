//
//  TopView.h
//  ZHRQ_CBZ
//
//  Created by Mr Lai on 2017/7/1.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserInfo;
@interface TopView : UIView
@property (nonatomic, strong) UserInfo *userInfo;
- (void)loginOutBtnAddTarget:(id)target action:(SEL)action;
- (void)QRCodeBtnAddTarget:(id)target action:(SEL)action;
@end
