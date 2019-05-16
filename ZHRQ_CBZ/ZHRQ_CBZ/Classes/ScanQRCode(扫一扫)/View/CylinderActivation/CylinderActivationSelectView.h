//
//  CylinderActivationSelectView.h
//  ZHRQ_CBZ
//
//  Created by Mr Lai on 2017/7/3.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CylinderActivationSelectView;
@protocol CylinderActivationSelectViewDelegate <NSObject>
@optional;
- (void)cylinderActivationSelectView:(CylinderActivationSelectView *)cylinderActivationSelectView didSelectedWithSpecification:(CGFloat)specification;
- (void)didTapCylinderActivationSelectView:(CylinderActivationSelectView *)cylinderActivationSelectView;
@end
@interface CylinderActivationSelectView : UIView
@property (nonatomic, weak) id<CylinderActivationSelectViewDelegate> delegate;
@property (nonatomic, copy) NSString *seletedDate;
@end
