
//
//  TitleButton.m
//  ZTXWY
//
//  Created by Mr Lai on 2017/6/7.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import "TitleButton.h"

@implementation TitleButton

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.titleLabel.font = TextSystemFont(13);
        [self setTitleColor:SetupColor(51, 51, 51) forState:UIControlStateNormal];
        [self setTitleColor:SetupColor(70, 159, 250) forState:UIControlStateSelected];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted {}

@end
