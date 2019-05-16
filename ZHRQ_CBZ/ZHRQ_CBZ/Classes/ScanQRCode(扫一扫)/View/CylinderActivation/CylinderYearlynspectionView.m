//
//  CylinderYearlynspectionView.m
//  ZHRQ_CBZ
//
//  Created by Mr Lai on 2017/8/26.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import "CylinderYearlynspectionView.h"

@interface CylinderYearlynspectionView ()
@property (weak, nonatomic) IBOutlet UILabel *selectedLabel;
@property (weak, nonatomic) IBOutlet UILabel *arrowLabel;

@end

@implementation CylinderYearlynspectionView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    self.width = MainScreenSize.width;
    self.arrowLabel.font = IconFont(15);
    self.arrowLabel.text = RightArrowIconUnicode;
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)]];
}

- (void)tap {
    if ([self.delegate respondsToSelector:@selector(didTapCylinderYearlynspectionView:)]) {
        [self.delegate didTapCylinderYearlynspectionView:self];
    }
}

- (void)setSeletedDate:(NSString *)seletedDate {
    _seletedDate = [seletedDate copy];
    self.selectedLabel.text = seletedDate;
}

@end
