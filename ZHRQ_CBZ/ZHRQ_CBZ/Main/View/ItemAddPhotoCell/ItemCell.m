//
//  ItemCell.m
//  ZTXWYGL
//
//  Created by Mr Lai on 2017/6/19.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import "ItemCell.h"

@implementation ItemCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.userInteractionEnabled = YES;
        _imageView.layer.cornerRadius = 5;
        _imageView.clipsToBounds = YES;
        _imageView.layer.borderColor = SetupColor(227, 227, 227).CGColor;
        _imageView.layer.borderWidth = 1;
        [self addSubview:_imageView];
        self.clipsToBounds = YES;
        
        UIButton *closeBtn = [[UIButton alloc] init];
        [closeBtn setImage:[UIImage imageNamed:@"itemAddCellimages.bundle/error_wine"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_imageView addSubview:closeBtn];
        _closeBtn = closeBtn;
    }
    return self;
}

- (void)closeBtnClick:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(itemCell:closeBtnDidClick:)]) {
        [self.delegate itemCell:self closeBtnDidClick:button];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _imageView.frame = self.bounds;
    _closeBtn.frame = CGRectMake(_imageView.width-20, 0, 20, 20);
}
@end
