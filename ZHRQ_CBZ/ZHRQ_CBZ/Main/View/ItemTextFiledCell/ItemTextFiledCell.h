//
//  ItemTextFiledCell.h
//  ZTXWYGL
//
//  Created by Mr Lai on 2017/6/14.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    InputTextTypeTelphone = 0,
    InputTextTypeString,
    InputTextTypeName,
    InputTextTypeBulidingNO,
    InputTextTypeBulidingFloorCount,
    InputTextTypeBulidingHouseCount,
    InputTextTypeBulidingLiftCount,
    InputTextTypeHouseArea,
    InputTextTypeSort,
    InputTextTypePwd
} InputTextType;

@class ItemTextFiledCell;
@protocol ItemTextFiledCellDelegate <NSObject>
@optional;
- (void)itemTextFiledCell:(ItemTextFiledCell *)cell itemTextFieldInputTextField:(UITextField *)textField;
- (void)itemTextFiledCell:(ItemTextFiledCell *)cell itemTextFieldDidClickWithTag:(NSUInteger)tag;
@end
@interface ItemTextFiledCell : UITableViewCell
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *placeholderText;
@property (nonatomic, copy) NSString *unit;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) UIKeyboardType keyboardType;
@property (nonatomic, assign) InputTextType textType;
@property (nonatomic, weak) id<ItemTextFiledCellDelegate> delegate;
@end
