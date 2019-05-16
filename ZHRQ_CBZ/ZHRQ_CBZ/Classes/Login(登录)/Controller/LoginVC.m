
//
//  LoginVC.m
//  ZHRQ_CBZ
//
//  Created by Mr Lai on 2017/7/4.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import "LoginVC.h"
#import "LoginView.h"

@interface LoginVC () <LoginViewDelegate>
@property (nonatomic, weak) LoginView *loginView;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *pwd;
@property (nonatomic, assign) BOOL isLogin;
@end

@implementation LoginVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.isLogin = NO;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (!self.isLogin)[self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupLoginView];
    [self addNotification];
    [self setupValue];
}

- (void)setupValue {
    self.userName = [SaveTool objectForKey:UserName];
    self.pwd = [SaveTool objectForKey:Pwd];
}

- (void)setupLoginView {
    LoginView *loginView = [LoginView viewFromXib];
    loginView.delegate = self;
    loginView.userName = [SaveTool objectForKey:UserName];
    loginView.pwd = [SaveTool objectForKey:Pwd];
    [loginView loginBtnaddTarget:self action:@selector(loginAction)];
    [self.view addSubview:loginView];
    _loginView = loginView;
}

#pragma mark - 接口
- (void)postLoginRequset {
    NSString *url = [MainURL stringByAppendingPathComponent:@"login/index"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[Account] = self.userName;
    params[Password] = self.pwd;
    params[Type] = MainType;
    
    WeakSelf(weakSelf)
    [HttpTool postWithURL:url params:params success:^(id json) {
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
        [weakSelf saveLoginDataWithJson:json];
    } failure:^(NSError *error) {
        weakSelf.loginView.shakeViewType = ShakeViewTypeLoginBtn;
    }];
}

#pragma mark - 保存数据
- (void)saveLoginDataWithJson:(id)json {
    [SaveTool setObject:json[Data][SessID] forKey:SessID];
    [SaveTool setObject:json[Data][@"user_info"][StoreId] forKey:StoreId];
    [SaveTool setObject:json[Data][@"user_info"][@"id"] forKey:UserID];
    [SaveTool setObject:json[Data][@"user_info"][@"company_name"] forKey:CompanyName];
    [SaveTool setObject:self.userName forKey:UserName];
    [SaveTool setObject:self.pwd forKey:Pwd];
    [SaveTool setObject:json[Data][@"telephone"] forKey:ServicePhone];
    [SaveTool setObject:json[Data][@"img"] forKey:ServiceImg];
}
 

#pragma mark - loginAction
- (void)loginAction {
    [self recoveryPostion];
    if (self.userName.length == 0) {
        [MBProgressHUD showError:@"请输入手机号"];
        self.loginView.shakeViewType = ShakeViewTypeUserName;
        return;
    } else if (![VerificationTool validateTelNumber:self.userName]) {
        [MBProgressHUD showError:@"手机号格式错误"];
        self.loginView.shakeViewType = ShakeViewTypeUserName;
        return;
    } else if (self.pwd.length == 0) {
        [MBProgressHUD showError:@"请输入密码"];
        self.loginView.shakeViewType = ShakeViewTypePwd;
        return;
    }
    
    self.isLogin = YES;
    [self postLoginRequset];
}


#pragma mark - LoginViewDelegate
- (void)didClickInputTextFieldWithLoginView:(LoginView *)loginView {
    WeakSelf(weakSelf)
    [UIView animateWithDuration:KeyboradDuration animations:^{
        if (iPhone5) {
            weakSelf.loginView.y = -ItemCellHeight * 1.5;
        } else if (iPhone6) {
            weakSelf.loginView.y = -ItemCellHeight * 0.5;
        } 
    }];
}

- (void)didClickLoginView:(LoginView *)loginView {
    [self recoveryPostion];
}

- (void)loginView:(LoginView *)loginView userName:(NSString *)text {
    self.userName = text;
}

- (void)loginView:(LoginView *)loginView passWord:(NSString *)text {
    self.pwd = text;
}

- (void)recoveryPostion {
    [self.view endEditing:YES];
    WeakSelf(weakSelf)
    [UIView animateWithDuration:KeyboradDuration animations:^{
        weakSelf.loginView.y = 0;
    }];
}

#pragma mark - addNotification
- (void)addNotification {
    WeakSelf(weakSelf)
    [[NSNotificationCenter defaultCenter] addObserverForName:Code500WithDataInnerCodeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        weakSelf.loginView.shakeViewType = ShakeViewTypeLoginBtn;
    }];
    [[NSNotificationCenter defaultCenter] addObserverForName:Code301WithDataInnerCodeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        weakSelf.loginView.shakeViewType = ShakeViewTypeLoginBtn;
    }];
}

@end
