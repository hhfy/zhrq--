


//
//  EditCodeVC.m
//  ZHRQ_CBZ
//
//  Created by Mr Lai on 2017/7/4.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import "EditCodeVC.h"
#import "EditCodeView.h"
#import "Cylinder.h"
#import "CylinderInformationVC.h"
#import "CylinderActivationVC.h"
#import "HomeVC.h"

@interface EditCodeVC () <EditCodeViewDelegate>
@property (nonatomic, weak) EditCodeView *topView;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) CylinderInfo *cylinderInfo;
@end

@implementation EditCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupValue];
    [self setupNav];
    [self setupTopView];
    [self setupDoneView];
}

- (void)setupValue {
    self.title = @"手动输入编号";
}

- (void)setupNav {
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(backAction) title:LeftArrowIconUnicode nomalColor:SetupColor(255, 255, 255) hightLightColor:SetupColor(180, 180, 180) titleFont:IconFont(20) top:0 left:-25 bottom:0 right:0];
}

- (void)setupTopView {
    EditCodeView *topView = [EditCodeView viewFromXib];
    topView.delegate = self;
    [self.view addSubview:topView];
    _topView = topView;
}

- (void)setupDoneView {
    NormalBottomView *doneView = [NormalBottomView viewFromXib];
    doneView.y = self.topView.maxY + SpaceHeight * 3;
    doneView.title = @"完成";
    [doneView addTarget:self action:@selector(doneViewClick)];
    [self.view addSubview:doneView];
}

#pragma mark - 接口
- (void)getCylinderInfoWithNo:(NSString *)no {
    NSString *url = [MainURL stringByAppendingPathComponent:@"store/scanning"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[SessID] = self.sess_id;
    params[@"no"] = no;
    
    WeakSelf(weakSelf)
    [HttpTool getWithURL:url params:params progress:nil success:^(id json) {
        CylinderInfo *cylinderInfo = [CylinderInfo mj_objectWithKeyValues:json[Data]];
        switch (cylinderInfo.cylinder_status) {
            case 1:
            {
                CylinderActivationVC *cylinderActivationVc = [[CylinderActivationVC alloc] init];
                cylinderActivationVc.cylinderInfo = cylinderInfo;
                [weakSelf.navigationController pushViewController:cylinderActivationVc animated:YES];
            }
                break;
            case 2:
            {
                if (cylinderInfo.need_check == 1) {
                    if ([cylinderInfo.store_id isEqualToString:self.store_id]) {
                        [LaiMethod alertControllerWithTitle:@"年检提示" message:@"该钢瓶的年检已过期!" defaultActionTitle:@"重新年检" style:UIAlertActionStyleDefault handler:^{
                            CylinderActivationVC *cylinderActivationVc = [[CylinderActivationVC alloc] init];
                            cylinderActivationVc.cylinderInfo = cylinderInfo;
                            [weakSelf.navigationController pushViewController:cylinderActivationVc animated:YES];
                        }];
                    } else {
                        [LaiMethod alertControllerWithTitle:@"年检提示" message:@"该钢瓶的年检已过期!" defaultActionTitle:@"确定" style:UIAlertActionStyleDefault handler:^{
                            [weakSelf.navigationController popViewControllerAnimated:YES];
                        }];
                    }
                } else {
                    CylinderInformationVC *cylinderInformationVc = [[CylinderInformationVC alloc] init];
                    cylinderInformationVc.cylinderInfo = cylinderInfo;
                    [weakSelf.navigationController pushViewController:cylinderInformationVc animated:YES];
                }
            }
                break;
            case 3:
            {
                [LaiMethod alertControllerWithTitle:@"查询结果" message:@"查询不到该编码对应的钢瓶!" defaultActionTitle:@"确定" style:UIAlertActionStyleDefault handler:^{
                    weakSelf.topView.isEdit = YES;
                }];
            }
                break;
            case 4:
            {
                [LaiMethod alertControllerWithTitle:@"扫描结果" message:@"该钢瓶已被禁用，请联系管理员!" defaultActionTitle:@"确定" style:UIAlertActionStyleDefault handler:^{
                    weakSelf.topView.isEdit = YES;
                }];
            }
                break;
            case 5:
            {
                [LaiMethod alertControllerWithTitle:@"扫描结果" message:@"该钢瓶已被暂扣，请联系管理员!" defaultActionTitle:@"确定" style:UIAlertActionStyleDefault handler:^{
                    weakSelf.topView.isEdit = YES;
                }];
            }
                break;
        }
    } failure:^(NSError *error) {
    }];
}

#pragma EditCodeViewDelegate
- (void)editCodeView:(EditCodeView *)editCodeView inputText:(NSString *)text {
    self.text = text;
}

#pragma mark - doneViewClick
- (void)doneViewClick {
    [self.view endEditing:YES];
    if (self.text.length == 0) {
        [MBProgressHUD showError:@"请输入钢瓶编号"];
        return;
    } else if (![VerificationTool validateCylinderCode:self.text]) {
        [MBProgressHUD showError:@"钢瓶编号格式不正确"]; // 170705030686
        return;
    }
    [self getCylinderInfoWithNo:self.text];
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
