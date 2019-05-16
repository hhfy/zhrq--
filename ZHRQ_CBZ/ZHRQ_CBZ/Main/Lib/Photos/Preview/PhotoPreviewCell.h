//
//  PhotoPreviewCell.h
//  ImagePickerController
//
//  Created by Mr Lai on 2017/5/23.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhotoPickerModel;

@interface PhotoPreviewCell : UICollectionViewCell

@property (nonatomic, strong) PhotoPickerModel *model;

@property (nonatomic, copy) void (^singleTapGestureBlock)();

@property (nonatomic, copy) void (^doubleTapGestureBlock)();

@end
