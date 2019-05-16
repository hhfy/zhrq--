//
//  EmployeeCell.h
//  ZHRQ_CBZ
//
//  Created by Mr Lai on 2017/7/1.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Employee, EmployeeCell;
@protocol EmployeeCellDelegate <NSObject>
@optional
- (void)employeeCell:(EmployeeCell *)employeeCell callPhoneBtnDidClic:(UIButton *)button;
@end

@interface EmployeeCell : UITableViewCell
@property (nonatomic, strong) Employee *employee;
@property (nonatomic, weak) id<EmployeeCellDelegate> delegate;
@end
