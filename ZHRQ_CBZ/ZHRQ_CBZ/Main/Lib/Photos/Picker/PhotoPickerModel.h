//
//  AlbumModel.h
//  ImagePickerController
//
//  Created by Mr Lai on 2017/5/23.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MediaType.h"

@class PHAsset;

@interface PhotoPickerModel : NSObject

@property (nonatomic, strong) id asset;             ///< PHAsset or ALAsset

@property (nonatomic, assign) BOOL isSelected;      ///< The select status of a photo, default is No

@property (nonatomic, assign) AlbumModelMediaType type;

@property (nonatomic, copy) NSString *timeLength;

//初始化照片模型
+ (instancetype)modelWithAsset:(id)asset type:(AlbumModelMediaType)type;

+ (instancetype)modelWithAsset:(id)asset type:(AlbumModelMediaType)type timeLength:(NSString *)timeLength;

@end
