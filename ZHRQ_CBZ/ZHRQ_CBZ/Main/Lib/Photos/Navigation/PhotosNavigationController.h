//
//  PhotosNavigationController.h
//  ImagePickerController
//
//  Created by Mr Lai on 2017/5/23.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import <UIKit/UIKit.h>

#define iOS7Later ([UIDevice currentDevice].systemVersion.floatValue >= 7.0f)
#define iOS8Later ([UIDevice currentDevice].systemVersion.floatValue >= 8.0f)
#define iOS9Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.0f)
#define iOS9_1Later ([UIDevice currentDevice].systemVersion.floatValue >= 9.1f)

@protocol PhotosNavigationControllerDelegate;

@interface PhotosNavigationController : UINavigationController

//初始化方法
- (instancetype)initWithMaxImagesCount:(NSInteger)maxImagesCount delegate:(id<PhotosNavigationControllerDelegate>)delegate;

//默认最大可选9张图片
@property (nonatomic, assign) NSInteger maxImagesCount;

//默认为YES，如果设置为NO,原图按钮将隐藏，用户不能选择发送原图
@property (nonatomic, assign) BOOL allowPickingOriginalPhoto;

//默认为YES，如果设置为NO,用户将不能选择发送视频
@property (nonatomic, assign) BOOL allowPickingVideo;

//外观颜色
@property (nonatomic, strong) UIColor *oKButtonTitleColorNormal;
@property (nonatomic, strong) UIColor *oKButtonTitleColorDisabled;

// 这个照片选择器不会自己dismiss，用户dismiss这个选择器的时候，会执行下面的handle
// 如果用户没有选择发送原图,第二个数组将是空数组
@property (nonatomic, copy) void (^didFinishPickingPhotosHandle)(NSArray<UIImage *> *photos, NSArray *assets);

@property (nonatomic, copy) void (^didFinishPickingPhotosWithInfosHandle)(NSArray<UIImage *> *photos,NSArray *assets, NSArray<NSDictionary *> *infos);

@property (nonatomic, copy) void (^PhotosNavigationControllerDidCancelHandle)();

// 如果用户选择了一个视频，下面的handle会被执行，如果系统版本大于iOS8，asset是PHAsset类的对象，否则是ALAsset类的对象
@property (nonatomic, copy) void (^didFinishPickingVideoHandle)(UIImage *coverImage, id asset);

@property (nonatomic, weak) id<PhotosNavigationControllerDelegate> pickerDelegate;

- (void)showAlertWithTitle:(NSString *)title;

- (void)showProgressHUD;

- (void)hideProgressHUD;

@end

@protocol PhotosNavigationControllerDelegate <NSObject>

@optional

// 这个照片选择器不会自己dismiss，用户dismiss这个选择器的时候，会走下面的回调，如果用户没有选择发送原图，Assets将是空数组
- (void)PhotosNavigationController:(PhotosNavigationController *)navigation didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets;

- (void)PhotosNavigationController:(PhotosNavigationController *)navigation didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets infos:(NSArray<NSDictionary *> *)infos;

- (void)PhotosNavigationControllerDidCancel:(PhotosNavigationController *)navigation;

// 如果用户选择了一个视频，下面的handle会被执行，如果系统版本大于iOS8，asset是PHAsset类的对象，否则是ALAsset类的对象
- (void)PhotosNavigationController:(PhotosNavigationController *)navigation didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset;

@end
