//
//  ItemSelectBtnCell.h
//  ZTXWYGL
//
//  Created by Mr Lai on 2017/6/17.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ItemSelectBtnCell;
@protocol ItemSelectBtnCellDelegate <NSObject>
@optional;
- (void)itemSelectBtnCell:(ItemSelectBtnCell *)itemSelectBtnCell didSelectedWithSelectedBtnIndex:(NSInteger)index cellId:(NSInteger)cellId;
@end

@interface ItemSelectBtnCell : UITableViewCell
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *firstText;
@property (nonatomic, copy) NSString *secondText;
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, weak) id<ItemSelectBtnCellDelegate> delegate;
@end
