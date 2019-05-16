//
//  TopView.m
//  ZHRQ_CBZ
//
//  Created by Mr Lai on 2017/7/3.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import "CylinderTopView.h"

@interface CylinderTopView ()
@property (weak, nonatomic) IBOutlet UILabel *cylinderNumberLabel;
@end

@implementation CylinderTopView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    self.width = MainScreenSize.width;
    self.cylinderNumberLabel.layer.cornerRadius = self.cylinderNumberLabel.height * 0.5;
    self.cylinderNumberLabel.clipsToBounds = YES;
}

- (void)setNo:(NSString *)no {
    _no = [no copy];
    self.cylinderNumberLabel.text = [NSString stringWithFormat:@"钢瓶编号：%@", no];
}

@end
