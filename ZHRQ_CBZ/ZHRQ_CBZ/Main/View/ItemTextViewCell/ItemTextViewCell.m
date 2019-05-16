
//
//  ItemTextViewCell.m
//  ZTXWYGL
//
//  Created by Mr Lai on 2017/6/19.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import "ItemTextViewCell.h"


@interface ItemTextViewCell () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *itemTitleLabel;
@property (weak, nonatomic) IBOutlet TextView *itemTextView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewLeftSpace;
@end
@implementation ItemTextViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    if (iPhone5) {
        self.textViewLeftSpace.constant = 30;
    } else if (iPhone6) {
        self.textViewLeftSpace.constant = 40;
    } else if (iPhone6P) {
        self.textViewLeftSpace.constant = 50;
    }
    self.itemTextView.layer.borderWidth = 0.5;
    self.itemTextView.layer.borderColor = SetupColor(227, 227, 227).CGColor;
    self.itemTextView.layer.cornerRadius = 5;
}

- (void)setTitle:(NSString *)title {
    _title = [title copy];
    self.itemTitleLabel.text = title;
}

- (void)setPlaceholderText:(NSString *)placeholderText {
    _placeholderText = placeholderText;
    self.itemTextView.placeholder = placeholderText;
}

- (void)setText:(NSString *)text {
    _text = [text copy];
    self.itemTextView.text = text;
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    if ([self.delegate respondsToSelector:@selector(itemTextViewCell:textViewInputText:)]) {
        [self.delegate itemTextViewCell:self textViewInputText:textView.text];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([self.delegate respondsToSelector:@selector(textViewDidClick:)]) {
        [self.delegate textViewDidClick:self];
    }
}

@end
