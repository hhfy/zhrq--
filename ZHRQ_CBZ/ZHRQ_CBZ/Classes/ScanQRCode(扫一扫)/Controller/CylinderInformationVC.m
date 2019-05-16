
//
//  CylinderInformationVC.m
//  ZHRQ_CBZ
//
//  Created by Mr Lai on 2017/7/3.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import "CylinderInformationVC.h"
#import "HomeVC.h"
#import "CylinderTopView.h"
#import "CylinderInformationCell.h"
#import "CylinderOperationView.h"
#import "Cylinder.h"
#import "CylinderInfoStatusView.h"

@interface CylinderInformationVC () <UITableViewDelegate, UITableViewDataSource, CustomDatePickerDelegate, CustomDatePickerDataSource>
@property (nonatomic, weak) CylinderTopView *topView;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) CylinderOperationView *bottomView;
@property (nonatomic, strong) NSArray *cylinders;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, weak) CustomDatePicker * pickerView;
@property (nonatomic, strong) NSArray *sites;
//@property (nonatomic,assign) int isUse; //按钮是否可用（1:都不可用2：送瓶可用 3：收瓶可用 4：充装可用）储备站仅4可用
@end

static NSString *success = @"操作成功";

@implementation CylinderInformationVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getCylinderData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self setupValue];
    [self setupTopView];
    [self setupTableView];
    [self setupBottomView];
    [LaiMethod setupDownRefreshWithTableView:self.tableView target:self action:@selector(getCylinderData)];
}

- (void)setupNav {
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(backAction) title:LeftArrowIconUnicode nomalColor:SetupColor(255, 255, 255) hightLightColor:SetupColor(180, 180, 180) titleFont:IconFont(20) top:0 left:-25 bottom:0 right:0];
}

- (void)setupValue {
    self.title = @"钢瓶信息";
    self.count = 0;
}

- (void)setupTopView {
    CylinderTopView *topView = [CylinderTopView viewFromXib];
    [self.view addSubview:topView];
    topView.no = self.cylinderInfo.bottle_no;
    _topView = topView;
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.topView.maxY, self.view.width, self.view.height - self.topView.maxY- NavHeight - 60) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.estimatedRowHeight = 45.0f;
    tableView.estimatedSectionHeaderHeight = 30.0f;
    tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    _tableView = tableView;
}

- (void)setupBottomView {
    CylinderOperationView *bottomView = [CylinderOperationView viewFromXib];
    bottomView.y = self.view.height - bottomView.height;
    bottomView.cylinderInfo = self.cylinderInfo;
    [bottomView moveCylinderBtnAddTarget:self action:@selector(moveCylinder)];
    [bottomView inFlationCylinderBtnAddTarget:self action:@selector(fillingCylidner)];
    [self.view addSubview:bottomView];
    _bottomView = bottomView;
}

- (void)setupCustomPickerWithTitle:(NSString *)title{
    CustomDatePicker * pickerView = [[CustomDatePicker alloc] initWithSureBtnTitle:@"取消" mainTitle:title otherButtonTitle:@"确定"];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    [pickerView show];
    _pickerView = pickerView;
}

#pragma mark - 接口
- (void)getCylinderData {
    NSString *url = [MainURL stringByAppendingPathComponent:@"store/cylinder_info"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[SessID] = self.sess_id;
    params[@"no"] = self.cylinderInfo.bottle_no;
    
    WeakSelf(weakSelf)
    [HttpTool getWithURL:url params:params progress:nil success:^(id json) {
        weakSelf.cylinders = [CylinderInfo mj_objectArrayWithKeyValuesArray:json[Data][List]];
        [weakSelf.tableView.mj_header endRefreshing];
        weakSelf.count = 1;
        [weakSelf.tableView reloadData];
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        weakSelf.count = 1;
        [weakSelf.tableView reloadData];
    }];
}

- (void)postFillCylinderRequest {
    NSString *url = [MainURL stringByAppendingPathComponent:@"store/filling"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[SessID] = self.sess_id;
    params[@"bottle_id"] = self.cylinderInfo.bottle_id;
    params[@"bottle_no"] = self.cylinderInfo.bottle_no;
    params[@"name"] = [SaveTool objectForKey:CompanyName];
    
    WeakSelf(weakSelf)
    [HttpTool postWithURL:url params:params success:^(id json) {
        [MBProgressHUD showSuccess:success];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(JumpVcDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf backAction];
        });
    } failure:^(NSError *error) {
    }];
}

- (void)postMoveCylinderRequestWithSiteId:(NSString *)siteId {
    NSString *url = [MainURL stringByAppendingPathComponent:@"store/transfers"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[SessID] = self.sess_id;
    params[Type] = MainType;
    params[@"bottle_id"] = self.cylinderInfo.bottle_id;
    params[@"bottle_no"] = self.cylinderInfo.bottle_no;
    params[@"from_id"] = self.store_id;
    params[@"to_id"] = siteId;
    params[@"worker_id"] = [SaveTool objectForKey:UserID];
    
    WeakSelf(weakSelf)
    [HttpTool postWithURL:url params:params success:^(id json) {
        [MBProgressHUD showSuccess:success];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(JumpVcDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf backAction];
        });
    } failure:^(NSError *error) {
    }];
}

- (void)getSitesData {
    NSString *url = [MainURL stringByAppendingPathComponent:@"store/get_site"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[SessID] = self.sess_id;
    params[@"site_status"] = @"2";
    
    WeakSelf(weakSelf)
    [HttpTool getWithURL:url params:params progress:nil success:^(id json) {
        weakSelf.sites = [CylinderSite mj_objectArrayWithKeyValuesArray:json[Data]];
        if (weakSelf.sites.count == 0) {
            [MBProgressHUD showError:@"暂无钢瓶转移站点"];
        } else {
            [weakSelf setupCustomPickerWithTitle:@"请选择转移站点"];
        }
    } failure:^(NSError *error) {
    }];
}

#pragma mark - tableView数据和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (self.cylinders.count > 0) ? self.cylinders.count : self.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        if (self.cylinders.count == 0) {
            self.tableView.scrollEnabled = NO;
            NoDataCell *cell = [NoDataCell cellFromXibWithTableView:tableView];
            return cell;
        } else {
            self.tableView.scrollEnabled = YES;
            CylinderInformationCell *cell = [CylinderInformationCell cellFromXibWithTableView:tableView];
            CylinderInfo *cylinderInfo = self.cylinders[indexPath.row];
            cell.cylinderInfo = cylinderInfo;
            return cell;
        }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return NoneSpace;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return (self.cylinderInfo.proc_status == 2) ? 30 : NoneSpace;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [CylinderInformationCell creatAnimationWithCell:cell];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CylinderInfoStatusView *statusView = [CylinderInfoStatusView headerViewFromXibWithTableView:tableView];
    return (self.cylinderInfo.proc_status == 2) ? statusView : nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

#pragma mark - CustomDatePicker代理和数据源
-(NSInteger)CpickerView:(UIPickerView *)pickerView numberOfRowsInPicker:(NSInteger)component {
    return self.sites.count;
}

-(UIView *)CpickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel * cellTitle = [[UILabel alloc] init];
    cellTitle.textColor = [UIColor blackColor];
    cellTitle.font = TextSystemFont(20);
    cellTitle.textAlignment = NSTextAlignmentCenter;
    CylinderSite *cylinderSite = self.sites[row];
    cellTitle.text = cylinderSite.name;
    return cellTitle;
}

- (void)CpickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row {
    CylinderSite *cylinderSite = self.sites[row];
    [self postMoveCylinderRequestWithSiteId:cylinderSite.ID];
    [self.pickerView dismisView];
}

-(CGFloat)CpickerView:(UIPickerView *)pickerView rowHeightForPicker:(NSInteger)component {
    return Height44;
}

#pragma mark - CylinderOperation
- (void)moveCylinder {
    WeakSelf(weakSelf)
    [LaiMethod alertControllerWithTitle:@"温馨提示" message:@"确定要转移钢瓶吗?" defaultActionTitle:@"确定" style:UIAlertActionStyleDefault cancelTitle:@"取消" preferredStyle:UIAlertControllerStyleAlert handler:^{
        [weakSelf getSitesData];
    }];
}

- (void)fillingCylidner {
    WeakSelf(weakSelf)
    [LaiMethod alertControllerWithTitle:@"温馨提示" message:@"确定要充装钢瓶吗?" defaultActionTitle:@"确定" style:UIAlertActionStyleDefault cancelTitle:@"取消" preferredStyle:UIAlertControllerStyleAlert handler:^{
        [weakSelf postFillCylinderRequest];
    }];
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
