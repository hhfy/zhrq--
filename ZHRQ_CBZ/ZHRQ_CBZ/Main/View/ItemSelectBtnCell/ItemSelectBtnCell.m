//
//  ItemSelectBtnCell.m
//  ZTXWYGL
//
//  Created by Mr Lai on 2017/6/17.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import "ItemSelectBtnCell.h"

@interface ItemSelectBtnCell ()
@property (weak, nonatomic) IBOutlet UILabel *itemTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondTextLabel;
@property (weak, nonatomic) IBOutlet UIButton *fristSelectBtn;
@property (weak, nonatomic) IBOutlet UIButton *secondSelectBtn;
@end

@implementation ItemSelectBtnCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
    [self setupValue];
}

- (void)setupValue {
    self.fristSelectBtn.selected = YES;
}

- (void)setupUI {
    self.fristSelectBtn.titleLabel.font = self.secondSelectBtn.titleLabel.font = IconFont(18);
    // \U0000e64e 空心  \U0000e650打钩
    [self.fristSelectBtn setTitle:@"\U0000e650" forState:UIControlStateSelected];
    [self.fristSelectBtn setTitle:@"\U0000e64e" forState:UIControlStateNormal];
    [self.fristSelectBtn setTitleColor:SetupColor(104, 121, 242) forState:UIControlStateSelected];
    [self.fristSelectBtn setTitleColor:SetupColor(227, 227, 227) forState:UIControlStateNormal];
    
    [self.secondSelectBtn setTitle:@"\U0000e650" forState:UIControlStateSelected];
    [self.secondSelectBtn setTitle:@"\U0000e64e" forState:UIControlStateNormal];
    [self.secondSelectBtn setTitleColor:SetupColor(104, 121, 242) forState:UIControlStateSelected];
    [self.secondSelectBtn setTitleColor:SetupColor(227, 227, 227) forState:UIControlStateNormal];
}

- (void)setTitle:(NSString *)title {
    _title = [title copy];
    self.itemTitleLabel.text = title;
}

- (void)setFirstText:(NSString *)firstText {
    _firstText = firstText;
    self.firstTextLabel.text = firstText;
}

- (void)setSecondText:(NSString *)secondText {
    _secondText = secondText;
    self.secondTextLabel.text = secondText;
}

- (IBAction)firstSelectBtnClick:(UIButton *)button {
    button.selected = YES;
    self.secondSelectBtn.selected = NO;
    if (button.isSelected) {
        if ([self.delegate respondsToSelector:@selector(itemSelectBtnCell:didSelectedWithSelectedBtnIndex:cellId:)]) {
            [self.delegate itemSelectBtnCell:self didSelectedWithSelectedBtnIndex:1 cellId:self.ID];
        }
    }
}

- (IBAction)secondSelectBtnClick:(UIButton *)button {
    button.selected = YES;
    self.fristSelectBtn.selected = NO;
    if (button.isSelected) {
        if ([self.delegate respondsToSelector:@selector(itemSelectBtnCell:didSelectedWithSelectedBtnIndex:cellId:)]) {
            [self.delegate itemSelectBtnCell:self didSelectedWithSelectedBtnIndex:2 cellId:self.ID];
        }
    }
}
@end
