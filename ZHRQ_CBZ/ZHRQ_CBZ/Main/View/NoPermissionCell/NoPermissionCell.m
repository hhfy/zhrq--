//
//  NoPermissionCell.m
//  ZTXWYGL
//
//  Created by Mr Lai on 2017/6/23.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import "NoPermissionCell.h"

@interface NoPermissionCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellHeightSpace;
@end

@implementation NoPermissionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    self.cellHeightSpace.constant = MainScreenSize.height - NavHeight;
}

@end
