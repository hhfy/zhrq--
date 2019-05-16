//
//  CylinderActivationVC.m
//  ZHRQ_CBZ
//
//  Created by Mr Lai on 2017/7/3.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import "CylinderActivationVC.h"
#import "CylinderTopView.h"
#import "CylinderInformationVC.h"
#import "CylinderActivationSelectView.h"
#import "CylinderYearlynspectionView.h"
#import "HomeVC.h"
#import "Cylinder.h"

typedef enum : NSUInteger {
    CylinderCheckTypeActivation,
    CylinderCheckTypeYearlyInspection,
} CylinderCheckType;

@interface CylinderActivationVC () <CylinderActivationSelectViewDelegate, CylinderYearlynspectionViewDelegate>
@property (nonatomic, weak) CylinderTopView *topView;
@property (nonatomic, weak) CylinderActivationSelectView *selectView;
@property (nonatomic, weak) CylinderYearlynspectionView *yearlynspectionView;
@property (nonatomic, assign) NSInteger selectedSpecification;
@property (nonatomic, copy) NSString *seletedDate;
@property (nonatomic, assign) CylinderCheckType checkType;
@end

@implementation CylinderActivationVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self setupValue];
    [self setupTopView];
    [self setupSelectView];
    [self setupActivationView];
}

- (void)setupNav {
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(backAction) title:LeftArrowIconUnicode nomalColor:SetupColor(255, 255, 255) hightLightColor:SetupColor(180, 180, 180) titleFont:IconFont(20) top:0 left:-25 bottom:0 right:0];
}

- (void)setupValue {
    if (self.cylinderInfo.status == 0) {
        self.checkType = CylinderCheckTypeActivation;
        self.title = @"钢瓶激活";
    } else {
        switch (self.cylinderInfo.need_check) {
            case 0:
            {
                self.checkType = CylinderCheckTypeActivation;
                self.title = @"钢瓶激活";
            }
                break;
            case 1:
            {
                self.checkType = CylinderCheckTypeYearlyInspection;
                self.title = @"设置年检";
            }
                break;
            default:
                break;
        }
    }
}

- (void)setupTopView {
    CylinderTopView *topView = [CylinderTopView viewFromXib];
    topView.no = self.cylinderInfo.bottle_no;
    [self.view addSubview:topView];
    _topView = topView;
}

- (void)setupSelectView {
    switch (self.checkType) {
        case CylinderCheckTypeActivation:
        {
            CylinderActivationSelectView *selectView = [CylinderActivationSelectView viewFromXib];
            selectView.delegate = self;
            selectView.y = self.topView.maxY;
            [self.view addSubview:selectView];
            _selectView = selectView;
        }
            break;
        case CylinderCheckTypeYearlyInspection:
        {
            CylinderYearlynspectionView *yearlynspectionView = [CylinderYearlynspectionView viewFromXib];
            yearlynspectionView.delegate = self;
            yearlynspectionView.y = self.topView.maxY;
            [self.view addSubview:yearlynspectionView];
            _yearlynspectionView = yearlynspectionView;
        }
            break;
        default:
            break;
    }
}

- (void)setupActivationView {
    NormalBottomView *activationView = [NormalBottomView viewFromXib];
    activationView.y = (self.checkType == CylinderCheckTypeActivation) ? (self.selectView.maxY + 50) : (self.yearlynspectionView.maxY + 50);
    activationView.title = (self.checkType == CylinderCheckTypeActivation) ? @"激活钢瓶" : @"提交年检";
    [activationView addTarget:self action:@selector(activationCylinder)];
    [self.view addSubview:activationView];
}

#pragma mark - 接口
- (void)postActiveCylinderRequest {
    NSString *url = [MainURL stringByAppendingPathComponent:@"store/cylinder_active"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[SessID] = self.sess_id;
    params[StoreId] = self.store_id;
    params[@"bottle_id"] = self.cylinderInfo.bottle_id;
    params[@"bottle_no"] = self.cylinderInfo.bottle_no;
    params[@"format"] = @(self.selectedSpecification);
    params[@"name"] = [SaveTool objectForKey:CompanyName];
    params[@"next_check_time"] = self.seletedDate;
    
    WeakSelf(weakSelf)
    [HttpTool postWithURL:url params:params success:^(id json) {
        [MBProgressHUD showSuccess:@"钢瓶已激活"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(JumpVcDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf backAction];
        });
    } failure:^(NSError *error) {
    }];
}

- (void)postYearlyInspectionRequest {
    NSString *url = [MainURL stringByAppendingPathComponent:@"store/set_check_time"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[SessID] = self.sess_id;
    params[@"id"] = self.cylinderInfo.bottle_id;
    params[@"next_check_time"] = self.seletedDate;
    
    WeakSelf(weakSelf)
    [HttpTool postWithURL:url params:params success:^(id json) {
        [MBProgressHUD showSuccess:@"年检成功"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(JumpVcDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf backAction];
        });
    } failure:^(NSError *error) {
    }];
}

#pragma mark - CylinderActivationSelectViewDelegate
- (void)cylinderActivationSelectView:(CylinderActivationSelectView *)cylinderActivationSelectView didSelectedWithSpecification:(CGFloat)specification {
    self.selectedSpecification = specification;
}

- (void)didTapCylinderActivationSelectView:(CylinderActivationSelectView *)cylinderActivationSelectView {
    WeakSelf(weakSelf)
    [LaiMethod setupKSDatePickerWithMinDate:[NSDate localDate] maxDate:nil dateMode:UIDatePickerModeDate headerColor:SetupColor(70, 159, 250) result:^(NSDate *selected) {
        weakSelf.seletedDate = [NSString stringFormDateFromat:selected formatter:FmtYMD];
        weakSelf.selectView.seletedDate = weakSelf.seletedDate;
    }];
}

#pragma mark - CylinderYearlynspectionViewDelegate
- (void)didTapCylinderYearlynspectionView:(CylinderYearlynspectionView *)cylinderYearlynspectionView {
    WeakSelf(weakSelf)
    [LaiMethod setupKSDatePickerWithMinDate:[NSDate localDate] maxDate:nil dateMode:UIDatePickerModeDate headerColor:SetupColor(70, 159, 250) result:^(NSDate *selected) {
        weakSelf.seletedDate = [NSString stringFormDateFromat:selected formatter:FmtYMD];
        weakSelf.yearlynspectionView.seletedDate = weakSelf.seletedDate;
    }];
}

#pragma mark - activationCylinder
- (void)activationCylinder {
    switch (self.checkType) {
        case CylinderCheckTypeActivation:
        {
            if (self.selectedSpecification == 0) {
                [MBProgressHUD showError:@"请选择激活钢瓶规格"];
                return;
            } else if (!self.seletedDate) {
                [MBProgressHUD showError:@"请选择年检时间"];
                return;
            }
            WeakSelf(weakSelf)
            [LaiMethod alertControllerWithTitle:nil message:@"确定是否激活钢瓶？" defaultActionTitle:@"确定" style:UIAlertActionStyleDefault cancelTitle:@"取消" preferredStyle:UIAlertControllerStyleAlert handler:^{
                [weakSelf postActiveCylinderRequest];
            }];
        }
            break;
        case CylinderCheckTypeYearlyInspection:
        {
            if (!self.seletedDate) {
                [MBProgressHUD showError:@"请选择年检时间"];
                return;
            }
            WeakSelf(weakSelf)
            [LaiMethod alertControllerWithTitle:nil message:@"确定是否提交年检时间？" defaultActionTitle:@"确定" style:UIAlertActionStyleDefault cancelTitle:@"取消" preferredStyle:UIAlertControllerStyleAlert handler:^{
                [weakSelf postYearlyInspectionRequest];
            }];
        }
            break;
        default:
            break;
    }
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
