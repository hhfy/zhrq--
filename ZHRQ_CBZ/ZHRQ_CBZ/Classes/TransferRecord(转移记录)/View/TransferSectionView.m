//
//  TransferSectionView.m
//  ZHRQ_CBZ
//
//  Created by Mr Lai on 2017/7/4.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import "TransferSectionView.h"

@implementation TransferSectionView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.width = MainScreenSize.width;
    self.backgroundColor = SetupColor(255, 255, 255);
}

@end
