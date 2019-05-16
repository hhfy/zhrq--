
//
//  LoginView.m
//  ZHRQ_CBZ
//
//  Created by Mr Lai on 2017/7/4.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import "LoginView.h"

@interface LoginView () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *setupPwdBtn;
@end

@implementation LoginView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
    [self addTextFieldKVO];
}

- (void)setupUI {
    self.size = MainScreenSize;
    self.userNameTextField.layer.borderWidth = self.pwdTextField.layer.borderWidth = 0.5;
    self.userNameTextField.layer.borderColor = self.pwdTextField.layer.borderColor = SetupColor(215, 215, 215).CGColor;
    self.userNameTextField.layer.cornerRadius = self.pwdTextField.layer.cornerRadius = 2;
    self.userNameTextField.leftViewMode = self.pwdTextField.leftViewMode = UITextFieldViewModeAlways;
    self.userNameTextField.leftView = [self creatLeftViewWithText:PhoneIconUnicode];
    self.pwdTextField.leftView = [self creatLeftViewWithText:PasswordIconUnicode];
}

- (void)addTextFieldKVO {
    [self.userNameTextField addTarget:self action:@selector(userNameTextField:) forControlEvents:UIControlEventEditingChanged];
    [self.pwdTextField addTarget:self action:@selector(pwdTextField:) forControlEvents:UIControlEventEditingChanged];
}

- (UIView *)creatLeftViewWithText:(NSString *)text {
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, self.userNameTextField.height)];
    UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -2, leftView.width, leftView.height)];
    leftLabel.font = IconFont(20);
    leftLabel.text = text;
    leftLabel.textAlignment = NSTextAlignmentCenter;
    leftLabel.textColor = SetupColor(215, 215, 215);
    [leftView addSubview:leftLabel];
    return leftView;
}

- (void)loginBtnaddTarget:(id)target action:(SEL)action {
    [self.loginBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self endEditing:YES];
    if ([self.delegate respondsToSelector:@selector(didClickLoginView:)]) {
        [self.delegate didClickLoginView:self];
    }
}

#pragma mark - KVO
- (void)userNameTextField:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(loginView:userName:)]) {
        [self.delegate loginView:self userName:textField.text];
    }
}

- (void)pwdTextField:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(loginView:passWord:)]) {
        [self.delegate loginView:self passWord:textField.text];
    }
}

#pragma mark - UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(didClickInputTextFieldWithLoginView:)]) {
        [self.delegate didClickInputTextFieldWithLoginView:self];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSInteger MaxTextLength = 0;
    
    if ([textField isEqual:self.userNameTextField]) {
        MaxTextLength = 11;
    }  else {
        MaxTextLength = 15;
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
        
        if ([textField isEqual:self.userNameTextField]) {
            [MBProgressHUD showError:@"手机号不超过11位"];
            [LaiMethod wrongInputAnimationWith:textField];
        } else {
            [MBProgressHUD showError:@"密码最长不超过15位"];
            [LaiMethod wrongInputAnimationWith:textField];
        }
        return NO;
    }
    
}

- (void)setShakeViewType:(ShakeViewType)shakeViewType {
    _shakeViewType = shakeViewType;
    switch (shakeViewType) {
        case ShakeViewTypeUserName:
            [LaiMethod wrongInputAnimationWith:self.userNameTextField];
            break;
        case ShakeViewTypePwd:
            [LaiMethod wrongInputAnimationWith:self.pwdTextField];
            break;
        case ShakeViewTypeLoginBtn:
            [LaiMethod wrongInputAnimationWith:self.loginBtn];
            break;
        default:
            break;
    }
}

- (void)setUserName:(NSString *)userName {
    _userName = [userName copy];
    self.userNameTextField.text = userName;
}

- (void)setPwd:(NSString *)pwd {
    _pwd = [pwd copy];
    self.pwdTextField.text = pwd;
}

@end
