
//
//  ItemTextFiledCell.m
//  ZTXWYGL
//
//  Created by Mr Lai on 2017/6/14.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import "ItemTextFiledCell.h"

@interface ItemTextFiledCell () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *itemTitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *ItemTextField;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *itemTextFieldLeftSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *itemTitleW;
@end

@implementation ItemTextFiledCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
    [self addTextFieldKVO];
    [self setupValue];
}

- (void)setupValue {
    self.keyboardType = UIKeyboardTypeDefault;
    self.textType = InputTextTypeString;
    self.unitLabel.text = nil;
    self.title = nil;
}

- (void)setupUI {
    if (iPhone5) {
        self.itemTextFieldLeftSpace.constant = 30;
    } else if (iPhone6) {
        self.itemTextFieldLeftSpace.constant = 40;
    } else if (iPhone6P) {
        self.itemTextFieldLeftSpace.constant = 50;
    }
    
    [self.ItemTextField setValue:SetupColor(153, 153, 153) forKeyPath:@"_placeholderLabel.textColor"];
    WeakSelf(weakSelf)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((KeyboradDuration * 2.5) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (weakSelf.tag == 0) {
            [weakSelf.ItemTextField becomeFirstResponder];
        }
    });
}

- (void)addTextFieldKVO {
    [self.ItemTextField addTarget:self action:@selector(itemTextField:) forControlEvents:UIControlEventEditingChanged];
}

- (void)itemTextField:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(itemTextFiledCell:itemTextFieldInputTextField:)]) {
        [self.delegate itemTextFiledCell:self itemTextFieldInputTextField:textField];
    }
}

- (void)setTitle:(NSString *)title {
    _title = [title copy];
    self.ItemTextField.tag = self.tag;
    self.itemTitleLabel.text = title;
    if (title) {
        self.itemTitleW.constant = 65;
        if (iPhone5) {
            self.itemTextFieldLeftSpace.constant = 30;
        } else if (iPhone6) {
            self.itemTextFieldLeftSpace.constant = 40;
        } else if (iPhone6P) {
            self.itemTextFieldLeftSpace.constant = 50;
        }
    } else {
        self.itemTitleW.constant = 0;
        self.itemTextFieldLeftSpace.constant = 0;
    }
}

- (void)setPlaceholderText:(NSString *)placeholderText {
    _placeholderText = [placeholderText copy];
    self.ItemTextField.tag = self.tag;
    self.ItemTextField.placeholder = placeholderText;
}

- (void)setUnit:(NSString *)unit {
    _unit = unit;
    self.unitLabel.text = unit;
}

- (void)setKeyboardType:(UIKeyboardType)keyboardType {
    _keyboardType = keyboardType;
    self.ItemTextField.keyboardType = keyboardType;
}

- (void)setText:(NSString *)text {
    _text = [text copy];
    self.ItemTextField.text = text;
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(itemTextFiledCell:itemTextFieldDidClickWithTag:)]) {
        [self.delegate itemTextFiledCell:self itemTextFieldDidClickWithTag:textField.tag];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
        NSInteger MaxTextLength = 0;
        switch (self.textType) {
            case InputTextTypeTelphone:
                MaxTextLength = 11;
                break;
            case InputTextTypeString:
                MaxTextLength = 30;
                break;
            case InputTextTypeName:
                MaxTextLength = 6;
                break;
            case InputTextTypeBulidingNO:
                 MaxTextLength = 5;
                break;
            case InputTextTypeBulidingFloorCount:
                MaxTextLength = 4;
                break;
            case InputTextTypeBulidingHouseCount:
                MaxTextLength = 4;
                break;
            case InputTextTypeBulidingLiftCount:
                MaxTextLength = 3;
                break;
            case InputTextTypeHouseArea:
                MaxTextLength = 4;
                break;
            case InputTextTypeSort:
                MaxTextLength = 3;
                break;
            case InputTextTypePwd:
                MaxTextLength = 15;
            default:
                break;
        }
    
        // 切割字符串
        NSString *comcatStr = [textField.text stringByReplacingCharactersInRange:range withString:string];
        NSInteger canInputLength = MaxTextLength - comcatStr.length;
    
        if (canInputLength >= 0)
        {
            return YES;
        }
        else
        {
            NSInteger len = string.length + canInputLength;
            //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
            NSRange rg = {0,MAX(len,0)};
    
            if (rg.length > 0)
            {
                NSString *s = [string substringWithRange:rg];
    
                [textField setText:[string stringByReplacingCharactersInRange:range withString:s]];
            }
            
            switch (self.textType) {
                case InputTextTypeTelphone:
                    [MBProgressHUD showError:@"手机号最长11位"];
                    break;
                case InputTextTypeString:
                    [MBProgressHUD showError:@"文本最长不超过30位"];
                    break;
                case InputTextTypeName:
                    [MBProgressHUD showError:@"姓名不超过6位"];
                    break;
                case InputTextTypeBulidingNO:
                    [MBProgressHUD showError:@"楼栋号不超过5位"];
                    break;
                case InputTextTypeBulidingFloorCount:
                     [MBProgressHUD showError:@"楼层不超过4位"];
                    break;
                case InputTextTypeBulidingHouseCount:
                    [MBProgressHUD showError:@"户数不超过4位"];
                    break;
                case InputTextTypeBulidingLiftCount:
                    [MBProgressHUD showError:@"电梯数不超过3位"];
                    break;
                case InputTextTypeHouseArea:
                    [MBProgressHUD showError:@"面积数不超过4位"];
                    break;
                case InputTextTypeSort:
                    [MBProgressHUD showError:@"排序数不超过3位"];
                    break;
                case InputTextTypePwd:
                    [MBProgressHUD showError:@"密码不超过15位"];
                    break;
                default:
                    break;
            }
            return NO;
        }
}

@end
