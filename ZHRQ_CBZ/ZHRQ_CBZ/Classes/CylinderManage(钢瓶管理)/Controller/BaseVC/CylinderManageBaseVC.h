//
//  CulinderManageBaseVC.h
//  ZHRQ_CBZ
//
//  Created by Mr Lai on 2017/7/5.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import "BaseViewController.h"

typedef enum {
    CylinderTypeAll = 0,
    CylinderTypeNormal = 1,
    CylinderTypeAbnormal,
    CylinderTypeDisable,
    CylinderTypeWithhold
} CylinderType;

@interface CylinderManageBaseVC : BaseViewController
@property (nonatomic, assign, readonly) CylinderType cylinderType;
@end
