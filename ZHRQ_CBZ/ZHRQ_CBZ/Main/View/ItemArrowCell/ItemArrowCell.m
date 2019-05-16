//
//  ItemArrowCell.m
//  ZTXWYGL
//
//  Created by Mr Lai on 2017/6/15.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import "ItemArrowCell.h"

@interface ItemArrowCell ()
@property (weak, nonatomic) IBOutlet UILabel *itemTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *itemTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *arrowIconLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *itemTextLeftSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *itemTitleW;
@end

@implementation ItemArrowCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    self.itemTitleW.constant = 0;
    self.itemTextLeftSpace.constant = 0;
    self.arrowIconLabel.font = IconFont(15);
    self.arrowIconLabel.text = RightArrowIconUnicode;
}

- (void)setTitle:(NSString *)title {
    _title = [title copy];
    self.itemTitleLabel.text = title;
    if (title) {
        if (iPhone5) {
            self.itemTextLeftSpace.constant = 30;
        } else if (iPhone6) {
            self.itemTextLeftSpace.constant = 40;
        } else if (iPhone6P) {
            self.itemTextLeftSpace.constant = 50;
        }
        self.itemTitleW.constant = 77;
    } else {
        self.itemTitleW.constant = 0;
        self.itemTextLeftSpace.constant = 0;
    }
}

- (void)setText:(NSString *)text {
    _text = [text copy];
    self.itemTextLabel.text = text;
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    self.itemTextLabel.textColor = textColor;
}

@end
