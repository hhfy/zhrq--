//
//  ItemAddPhotoCell.h
//  ZTXWYGL
//
//  Created by Mr Lai on 2017/6/19.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ItemAddPhotoCell;
@protocol ItemAddPhotoCellDelegate <NSObject>
@optional;
- (void)itemAddPhotoCell:(ItemAddPhotoCell *)itemAddPhotoCell selectedPhotos:(NSArray <UIImage *>*)photos;
- (void)photosViewDidClick:(ItemAddPhotoCell *)itemAddPhotoCell;
- (void)didReloadTableView:(ItemAddPhotoCell *)itemAddPhotoCell;
- (void)itemAddPhotoCell:(ItemAddPhotoCell *)itemAddPhotoCell helpBtnDidClick:(UIButton *)button;
@end

@interface ItemAddPhotoCell : UITableViewCell
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSInteger photoCount;
@property (nonatomic, assign, getter=isHiddenHelpBtn) BOOL hiddenHelpBtn;
@property (nonatomic, weak) id<ItemAddPhotoCellDelegate> delegate;
@end
