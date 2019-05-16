//
//  PhotosDataModel.h
//  ImagePickerController
//
//  Created by Mr Lai on 2017/5/23.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PHFetchResult, PHAsset;

@interface PhotosDataModel : NSObject

//相册名
@property (nonatomic, strong) NSString *name;

//照片个数
@property (nonatomic, assign) NSInteger count;

// < PHFetchResult<PHAsset> or ALAssetsGroup<ALAsset>
@property (nonatomic, strong) id result;

@end
