//
//  DataBottomView.h
//  ZHRQ_CBZ
//
//  Created by Mr Lai on 2017/7/6.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DataRecord;
@interface DataBottomView : UIView
@property (nonatomic, strong) DataRecord *dataRecord;
@property (nonatomic, copy) NSString *timeSort;
@property (nonatomic, copy) NSString *employeeSort;
@property (nonatomic, copy) NSString *typeSort;
@end
