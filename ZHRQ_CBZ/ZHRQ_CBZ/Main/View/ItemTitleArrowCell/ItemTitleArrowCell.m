
//
//  ItemTitleArrowCell.m
//  ZTXWYGL
//
//  Created by Mr Lai on 2017/6/20.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import "ItemTitleArrowCell.h"

@interface ItemTitleArrowCell ()
@property (weak, nonatomic) IBOutlet UILabel *ItemTitle;
@property (weak, nonatomic) IBOutlet UILabel *itemArrowLabel;
@end

@implementation ItemTitleArrowCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    self.itemArrowLabel.font = IconFont(15);
    self.itemArrowLabel.text = RightArrowIconUnicode;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    self.ItemTitle.text = title;
}


@end
