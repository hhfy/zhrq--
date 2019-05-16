//
//  IDPhotoInstructionView.m
//  ZHRQ_CBZ
//
//  Created by Mr Lai on 2017/7/28.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import "IDPhotoInstructionView.h"

@interface IDPhotoInstructionView ()
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@end

@implementation IDPhotoInstructionView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    self.size = MainScreenSize;
    self.closeBtn.titleLabel.font = IconFont(22);
    [self.closeBtn setTitle:CloseIconUnicode forState:UIControlStateNormal];
}

- (void)show {
    [AlertPopViewTool popView:self animated:YES];
}

- (void)dismiss {
    [AlertPopViewTool closeAnimated:YES];
}
- (IBAction)closeBtnClick {
    [self dismiss];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismiss];
}

@end
