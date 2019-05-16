


//
//  NoDataCell.m
//  ZTXWYGL
//
//  Created by Mr Lai on 2017/6/15.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import "NoDataCell.h"

@interface NoDataCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellHeightSpace;
@end

@implementation NoDataCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    self.cellHeightSpace.constant = MainScreenSize.height - NavHeight;
}

@end
