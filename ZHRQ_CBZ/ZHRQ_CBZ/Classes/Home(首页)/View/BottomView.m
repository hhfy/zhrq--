
//
//  BottomView.m
//  ZHRQ_CBZ
//
//  Created by Mr Lai on 2017/7/1.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import "BottomView.h"

@interface BottomView ()
@end

@implementation BottomView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    self.width = MainScreenSize.width;
    if (iPhone5) {
        self.height = 100;
    } else if (iPhone6) {
        self.height = 120;
    } else if (iPhone6P) {
        self.height = 140;
    }
}

@end
