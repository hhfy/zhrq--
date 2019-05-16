//
//  CylinderTotalView.m
//  ZHRQ_CBZ
//
//  Created by Mr Lai on 2017/7/27.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import "CylinderTotalView.h"

@interface CylinderTotalView ()
@property (weak, nonatomic) IBOutlet UILabel *totalCylinderLabel;
@end

@implementation CylinderTotalView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setpUI];
}

- (void)setpUI {
    self.width = MainScreenSize.width;
}

- (void)setTotalText:(NSString *)totalText {
    _totalText = [totalText copy];
    self.totalCylinderLabel.text = totalText;
}

@end
