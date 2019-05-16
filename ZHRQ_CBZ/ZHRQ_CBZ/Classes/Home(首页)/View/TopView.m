
//
//  TopView.m
//  ZHRQ_CBZ
//
//  Created by Mr Lai on 2017/7/1.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import "TopView.h"
#import "UserInfo.h"

@interface TopView ()
@property (weak, nonatomic) IBOutlet UIButton *QRCodeBtn;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *loginOutBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end


@implementation TopView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    self.width = MainScreenSize.width;
    self.QRCodeBtn.titleLabel.font = IconFont(25);
    [self.QRCodeBtn setTitle:ScanIconUnicode forState:UIControlStateNormal];
    self.addressLabel.font = IconFont(13);
    self.addressLabel.text = [NSString stringWithFormat:@"%@ 正在获取当前公司位置...", LocationIconUnicode];
    self.nameLabel.text = @"正在获取当前供应站名称...";
}

- (void)setUserInfo:(UserInfo *)userInfo {
    _userInfo = userInfo;
    self.addressLabel.text = [NSString stringWithFormat:@"%@ %@", LocationIconUnicode, userInfo.company_addr];
    self.nameLabel.text = [NSString stringWithFormat:@"%@：%@", userInfo.company_name, userInfo.name];
}

- (void)loginOutBtnAddTarget:(id)target action:(SEL)action {
    [self.loginOutBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)QRCodeBtnAddTarget:(id)target action:(SEL)action {
    [self.QRCodeBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}
@end
