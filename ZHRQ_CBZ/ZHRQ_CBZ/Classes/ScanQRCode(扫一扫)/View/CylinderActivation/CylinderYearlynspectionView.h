//
//  CylinderYearlynspectionView.h
//  ZHRQ_CBZ
//
//  Created by Mr Lai on 2017/8/26.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CylinderYearlynspectionView;
@protocol CylinderYearlynspectionViewDelegate <NSObject>
@optional;
- (void)didTapCylinderYearlynspectionView:(CylinderYearlynspectionView *)cylinderYearlynspectionView;
@end
@interface CylinderYearlynspectionView : UIView
@property (nonatomic, weak) id<CylinderYearlynspectionViewDelegate> delegate;
@property (nonatomic, copy) NSString *seletedDate;
@end
