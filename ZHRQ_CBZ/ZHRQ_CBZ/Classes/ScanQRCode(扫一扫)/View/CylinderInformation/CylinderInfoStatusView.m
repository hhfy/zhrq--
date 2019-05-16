

//
//  CylinderInfoStatusView.m
//  ZHRQ_CBZ
//
//  Created by Mr Lai on 2017/7/10.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import "CylinderInfoStatusView.h"

@interface CylinderInfoStatusView ()
@property (weak, nonatomic) IBOutlet UILabel *iconLabel;

@end

@implementation CylinderInfoStatusView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    self.width = MainScreenSize.width;
    self.iconLabel.font = IconFont(20);
    self.iconLabel.text = WarnningIconUnicode;
    self.contentView.backgroundColor = SetupColor(251, 244, 121);
}

@end
