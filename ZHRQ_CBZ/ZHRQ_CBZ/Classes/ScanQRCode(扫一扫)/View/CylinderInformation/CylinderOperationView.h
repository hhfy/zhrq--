//
//  CylinderOperationView.h
//  ZHRQ_CBZ
//
//  Created by Mr Lai on 2017/7/4.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CylinderInfo;
@interface CylinderOperationView : UIView
@property (nonatomic, strong) CylinderInfo *cylinderInfo;
- (void)moveCylinderBtnAddTarget:(id)target action:(SEL)action;
- (void)inFlationCylinderBtnAddTarget:(id)target action:(SEL)action;
@end
