//
//  FuntionItemCell.h
//  ZHRQ_CBZ
//
//  Created by Mr Lai on 2017/7/1.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Function;
@interface FuntionItemCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (nonatomic, strong) Function *function;
@property (nonatomic, assign) BOOL isTap;
@end
