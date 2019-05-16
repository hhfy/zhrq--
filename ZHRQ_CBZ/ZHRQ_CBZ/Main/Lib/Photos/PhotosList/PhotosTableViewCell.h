//
//  PhotosTableViewCell.h
//  ImagePickerController
//
//  Created by Mr Lai on 2017/5/23.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import <UIKit/UIKit.h>

static const CGFloat AlbumListCellHeight = 70.0;

@class PhotosDataModel;

@interface PhotosTableViewCell : UITableViewCell

@property (nonatomic, strong) PhotosDataModel *model;

@end
