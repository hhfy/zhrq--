//
//  ResetEmployPwdVC.m
//  ZHRQ_CBZ
//
//  Created by Mr Lai on 2017/7/24.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import "ResetEmployPwdVC.h"
#import "Employee.h"
#import "LoginVC.h"
#import "HomeVC.h"

@interface ResetEmployPwdVC () <UITableViewDelegate, UITableViewDataSource, ItemTextFiledCellDelegate>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, copy) NSString *pwd;
@end

@implementation ResetEmployPwdVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupValue];
    [self setupTableView];
    [self setupAddView];
}

- (void)setupValue {
    self.title = @"重置密码";
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - NavHeight) style:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.estimatedRowHeight = 45.0f;
    tableView.scrollEnabled = NO;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    _tableView = tableView;
}

- (void)setupAddView {
    NormalBottomView *addView = [NormalBottomView viewFromXib];
    addView.title = @"保存";
    [addView addTarget:self action:@selector(addViewAction)];
    self.tableView.tableFooterView = addView;
}

#pragma mark - 接口
- (void)postResetPwdRequest {
    NSString *url = [MainURL stringByAppendingPathComponent:@"store/reset_pwd"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[SessID] = self.sess_id;
    params[@"id"] = self.employee.ID;
    params[@"password"] = self.pwd;
    
    WeakSelf(weakSelf)
    [HttpTool postWithURL:url params:params success:^(id json) {
        [MBProgressHUD showSuccess:@"保存成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(JumpVcDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([weakSelf.employee.account isEqualToString:[SaveTool objectForKey:UserName]]) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(JumpVcDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [MBProgressHUD showMessage:@"正在重新登录..."];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(JumpVcDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [MBProgressHUD hideHUD];
                        LoginVC *logniVc = [[LoginVC alloc] init];
                        logniVc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
                        [weakSelf presentViewController:logniVc animated:YES completion:nil];
                    });
                });
            } else {
                [weakSelf backAction];
            }
        });
    } failure:^(NSError *error) {
    }];
}

#pragma mark - tableView代理和数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ItemTextCell *cell = [ItemTextCell cellFromXibWithTableView:tableView];
    switch (indexPath.row) {
        case 0:
        {
            cell.title = @"员工姓名";
            cell.text = self.employee.name;
        }
            break;
        case 1:
        {
            cell.title = @"手机号码";
            cell.text = self.employee.account;
        }
            break;
        case 2:
        {
            ItemTextFiledCell *cell = [ItemTextFiledCell cellFromXibWithTableView:tableView];
            cell.title = @"重置密码";
            cell.textType = InputTextTypePwd;
            cell.placeholderText = @"请设置重置密码";
            cell.delegate = self;
            return cell;
        }
            break;
        default:
            break;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return NoneSpace;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section {
    return SpaceHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

#pragma mark - ItemTextFiledCellDelegate
- (void)itemTextFiledCell:(ItemTextFiledCell *)cell itemTextFieldInputTextField:(UITextField *)textField {
    self.pwd = textField.text;
}

#pragma mark - addViewAction
- (void)addViewAction {
    [self.view endEditing:YES];
    if (self.pwd.length == 0) {
        [MBProgressHUD showError:@"请输入新密码"];
        return;
    } else if (![VerificationTool validatePwd:self.pwd]) {
        [MBProgressHUD showError:@"密码为6-15位数字字母"];
        return;
    }
    [self postResetPwdRequest];
}

#pragma mark - backAction
- (void)backAction {
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[HomeVC class]]) {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}

@end
