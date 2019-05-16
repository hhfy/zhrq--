//
//  DataTopView.h
//  ZHRQ_CBZ
//
//  Created by Mr Lai on 2017/7/5.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DataTopView;
@protocol DataTopViewDelegate <NSObject>
@optional
- (void)didClickLeftBtn:(DataTopView *)dataTopView;
- (void)didClickRightBtn:(DataTopView *)dataTopView;
- (void)reSetDate:(DataTopView *)dataTopView;
- (void)didSelectedDate:(DataTopView *)dataTopView;
- (void)didSelectedEmployee:(DataTopView *)dataTopView;
- (void)didSelectedType:(DataTopView *)dataTopView;
@end
@interface DataTopView : UIView
@property (nonatomic, weak) id<DataTopViewDelegate> delegate;
@property (nonatomic, copy) NSString *leftDate;
@property (nonatomic, copy) NSString *rightDate;
@property (nonatomic, copy) NSString *selectedType;
@property (nonatomic, copy) NSString *selectedEmployee;
@property (nonatomic, assign) BOOL isDismiss;
- (void)resetAllSortData;
@end
