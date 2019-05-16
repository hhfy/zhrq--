//
//  ItemTextViewCell.h
//  ZTXWYGL
//
//  Created by Mr Lai on 2017/6/19.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ItemTextViewCell;
@protocol ItemTextViewCellDelegate <NSObject>
@optional;
- (void)itemTextViewCell:(ItemTextViewCell *)itemTextViewCell textViewInputText:(NSString *)text;
- (void)textViewDidClick:(ItemTextViewCell *)itemTextViewCell;
@end

@interface ItemTextViewCell : UITableViewCell
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *placeholderText;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, weak) id<ItemTextViewCellDelegate> delegate;
@end
