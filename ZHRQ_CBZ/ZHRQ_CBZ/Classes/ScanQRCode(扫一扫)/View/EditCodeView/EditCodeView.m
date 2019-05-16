//
//  EditCodeView.m
//  ZHRQ_CBZ
//
//  Created by Mr Lai on 2017/7/4.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import "EditCodeView.h"

@interface EditCodeView () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *editCodeTextField;
@end

@implementation EditCodeView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
    [self addTextFieldKVO];
}

- (void)setupUI {
    self.width = MainScreenSize.width;
    self.editCodeTextField.layer.borderWidth = 0.5;
    self.editCodeTextField.layer.borderColor = SetupColor(227, 227, 227).CGColor;
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, self.editCodeTextField.height)];
    self.editCodeTextField.leftView = leftView;
    self.editCodeTextField.leftViewMode = UITextFieldViewModeAlways;
    
    WeakSelf(weakSelf)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((KeyboradDuration * 2.5) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.editCodeTextField becomeFirstResponder];
    });
}

- (void)addTextFieldKVO {
    [self.editCodeTextField addTarget:self action:@selector(editCodeTextField:) forControlEvents:UIControlEventEditingChanged];
}

- (void)editCodeTextField:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(editCodeView:inputText:)]) {
        [self.delegate editCodeView:self inputText:textField.text];
    }
}

- (void)setIsEdit:(BOOL)isEdit {
    _isEdit = isEdit;
    [self.editCodeTextField becomeFirstResponder];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSInteger MaxTextLength = 12;
    
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
        
        [MBProgressHUD showError:@"编码为固定12位数字"];
        [LaiMethod wrongInputAnimationWith:textField];
        return NO;
    }
    
}


@end
