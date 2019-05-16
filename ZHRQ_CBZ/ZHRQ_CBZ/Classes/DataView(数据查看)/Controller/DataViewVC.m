//
//  DataViewVC.m
//  ZHRQ_CBZ
//
//  Created by Mr Lai on 2017/7/1.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import "DataViewVC.h"
#import "DataTopView.h"
#import "DataViewCell.h"
#import "Employee.h"
#import "DataBottomView.h"
#import "DataView.h"

@interface DataViewVC () <DataTopViewDelegate, UITableViewDelegate, UITableViewDataSource, CustomDatePickerDelegate, CustomDatePickerDataSource>
@property (nonatomic, weak) DataTopView *topView;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) CustomDatePicker * pickerView;
@property (nonatomic, weak) DataBottomView *bottomView;
@property (nonatomic, copy) NSString *leftDate;
@property (nonatomic, copy) NSString *rightDate;
@property (nonatomic, copy) NSString *selectedType;
@property (nonatomic, copy) NSString *selectedEmployeeId;
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, strong) NSArray *types;
@property (nonatomic, strong) NSArray *employees;
@property (nonatomic, strong) DataRecord *dataRecord;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger typeTag;
@end

@implementation DataViewVC

- (NSMutableArray *)datas
{
    if (_datas == nil)
    {
        _datas = [NSMutableArray array];
    }
    return _datas;
}

- (NSArray *)types
{
    if (_types == nil)
    {
        _types = @[@"激活", @"充装"];
    }
    return _types;
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.topView.isDismiss = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getNewData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupValue];
    [self setupNav];
    [self setupTopView];
    [self setupBottomView];
    [self setupTableView];
    [LaiMethod setupDownRefreshWithTableView:self.tableView target:self action:@selector(getNewData)];
}

- (void)setupValue {
    self.title = @"数据查看";
    self.count = 0;
    [self types];
}

- (void)setupNav {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"清空条件" style:UIBarButtonItemStylePlain target:self action:@selector(clearSortAction)];
}

- (void)setupTopView {
    DataTopView *topView = [DataTopView viewFromXib];
    topView.delegate = self;
    [self.view addSubview:topView];
    _topView = topView;
}

- (void)setupDatePickerWithReloadIndex:(NSInteger)index {
    KSDatePicker* picker = [[KSDatePicker alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 40, 300)];
    picker.appearance.radius = 5;
    picker.appearance.maximumDate = [NSDate date];
    //设置回调
    WeakSelf(weakSelf)
    picker.appearance.resultCallBack = ^void(KSDatePicker* datePicker,NSDate* currentDate,KSDatePickerButtonType buttonType){
        if (buttonType == KSDatePickerButtonCommit) {
            switch (index) {
                case 0:
                {
                    NSString *left = [NSString stringFormDateFromat:currentDate formatter:FmtYMD2];
                    if (weakSelf.rightDate) {
                        NSInteger result = [NSString compareDateStr:left withOtherDateStr:weakSelf.rightDate formatter:FmtYMD2];
                        if (result != 1) {
                            weakSelf.topView.leftDate = weakSelf.leftDate = left;
                        } else {
                            weakSelf.topView.leftDate = weakSelf.leftDate = left;
                            weakSelf.topView.rightDate = weakSelf.rightDate = [NSString stringFormDateFromat:[NSDate dateWithTimeInterval:24*60*60 sinceDate:[NSDate dateFromStringFormat:left formatter:FmtYMD2]] formatter:FmtYMD2];;
                        }
                    } else {
                        weakSelf.topView.leftDate = weakSelf.leftDate = left;
                    }
                }
                    break;
                case 1:
                {
                    NSString *right = [NSString stringFormDateFromat:currentDate formatter:FmtYMD2];
                    if (weakSelf.leftDate) {
                        NSInteger result = [NSString compareDateStr:right withOtherDateStr:weakSelf.leftDate formatter:FmtYMD2];
                        if (result != -1) {
                            weakSelf.topView.rightDate = weakSelf.rightDate = right;
                        } else {
                            weakSelf.topView.rightDate = weakSelf.rightDate = right;
                            weakSelf.topView.leftDate = weakSelf.leftDate = [NSString stringFormDateFromat:[NSDate dateWithTimeInterval:-24*60*60 sinceDate:[NSDate dateFromStringFormat:right formatter:FmtYMD2]] formatter:FmtYMD2];;
                        }
                    } else {
                        weakSelf.topView.rightDate = weakSelf.rightDate = right;
                    }

                }
                    break;
                default:
                    break;
            }
        }
    };
    [picker show];
}

- (void)setupCustomPickerWithTitle:(NSString *)title{
    CustomDatePicker * pickerView = [[CustomDatePicker alloc] initWithSureBtnTitle:@"取消" mainTitle:title otherButtonTitle:@"确定"];
    pickerView.tintColor = SetupColor(70, 159, 250);
    pickerView.delegate = self;
    pickerView.dataSource = self;
    [pickerView show];
    _pickerView = pickerView;
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.topView.maxY + SpaceHeight, self.view.width, self.view.height - NavHeight - self.bottomView.height - self.topView.height - SpaceHeight) style:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.estimatedRowHeight = 45.0f;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    _tableView = tableView;
}

- (void)setupBottomView {
    DataBottomView *bottomView = [DataBottomView viewFromXib];
    bottomView.y = self.view.height - bottomView.height;
    [self.view addSubview:bottomView];
    _bottomView = bottomView;
}

#pragma mark - 接口
/* 获取通知列表 */
- (void)getNewData {
    self.currentPage = 1;
    [self getData];
}

- (void)getMoreData {
    self.currentPage++;
    [self getData];
}

- (void)getData {
    if (self.tableView.scrollsToTop == NO) return;
    NSString *url = [MainURL stringByAppendingPathComponent:@"supply/data_view"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[SessID] = self.sess_id;
    params[Type] = MainType;
    params[Page] = @(self.currentPage);
    params[@"start_time"] = self.leftDate;
    params[@"end_time"] = self.rightDate;
    params[@"worker_id"] = self.selectedEmployeeId;
    params[@"status"] = self.selectedType;
    
    WeakSelf(weakSelf)
    [HttpTool getWithURL:url params:params progress:nil success:^(id json) {
        if (weakSelf.currentPage == 1) [weakSelf.datas removeAllObjects];
        NSArray *dataViewArr = [DataView mj_objectArrayWithKeyValuesArray:json[Data][List]];
        [weakSelf.datas addObjectsFromArray:dataViewArr];
        self.dataRecord = [DataRecord mj_objectWithKeyValues:json[Data][@"record"]];
        self.bottomView.dataRecord = self.dataRecord;
        [LaiMethod setupUpRefreshWithTableView:weakSelf.tableView target:weakSelf action:@selector(getMoreData)];
        weakSelf.count = 1;
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
        if (self.datas.count == [json[Data][Total] integerValue]) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        if (weakSelf.currentPage > 1) self.currentPage--;
        weakSelf.count = 1;
        [weakSelf.tableView reloadData];
    }];
}

- (void)getEmployeeData {
    NSString *url = [MainURL stringByAppendingPathComponent:@"store/all_staff"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[SessID] = self.sess_id;
    params[Type] = MainType;
    
    WeakSelf(weakSelf)
    [HttpTool getWithURL:url params:params progress:nil success:^(id json) {
        weakSelf.employees = [Employee mj_objectArrayWithKeyValuesArray:json[Data][List]];
        if (weakSelf.employees.count) {
            [weakSelf setupCustomPickerWithTitle:@"选择员工"];
        } else {
            [MBProgressHUD showError:@"获取员工失败"];
        }
    } failure:^(NSError *error) {
    }];
}

#pragma mark - tableView数据和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (self.datas.count > 0) ? self.datas.count : self.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.datas.count == 0) {
        self.tableView.scrollEnabled = NO;
        NoDataCell *cell = [NoDataCell cellFromXibWithTableView:tableView];
        return cell;
    } else {
        self.tableView.scrollEnabled = YES;
        DataViewCell *cell = [DataViewCell cellFromXibWithTableView:tableView];
        DataView *dataView = self.datas[indexPath.row];
        cell.dataView = dataView;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return NoneSpace;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return NoneSpace;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - DataTopViewDelegate
- (void)didClickLeftBtn:(DataTopView *)dataTopView {
    [self setupDatePickerWithReloadIndex:0];
}

- (void)didClickRightBtn:(DataTopView *)dataTopView {
    [self setupDatePickerWithReloadIndex:1];
}

- (void)didSelectedDate:(DataTopView *)dataTopView {
    self.bottomView.timeSort = [NSString stringWithFormat:@"%@~%@", self.leftDate, self.rightDate];
    [self.tableView.mj_header beginRefreshing];
}

- (void)reSetDate:(DataTopView *)dataTopView {
    self.topView.leftDate = self.topView.rightDate = self.leftDate = self.rightDate = nil;
}

- (void)didSelectedEmployee:(DataTopView *)dataTopView {
    self.typeTag = 0;
    [self getEmployeeData];
}

- (void)didSelectedType:(DataTopView *)dataTopView {
    self.typeTag = 1;
    [self setupCustomPickerWithTitle:@"请选择类型"];
}

#pragma mark - CustomDatePicker
-(NSInteger)CpickerView:(UIPickerView *)pickerView numberOfRowsInPicker:(NSInteger)component {
    return (self.typeTag == 1) ? self.types.count : self.employees.count;
}

-(UIView *)CpickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel * cellTitle = [[UILabel alloc] init];
    cellTitle.textColor = [UIColor blackColor];
    cellTitle.font = TextSystemFont(20);
    cellTitle.textAlignment = NSTextAlignmentCenter;
    switch (self.typeTag) {
        case 0:
        {
            Employee *employee = self.employees[row];
            cellTitle.text = employee.name;
        }
            break;
        case 1:
            cellTitle.text = self.types[row];
        default:
            break;
    }

    return cellTitle;
}

- (void)CpickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row {
    switch (self.typeTag) {
        case 0:
        {
            Employee *employee = self.employees[row];
            self.topView.selectedEmployee = employee.name;
            self.selectedEmployeeId = employee.ID;
            self.bottomView.employeeSort = employee.name;
        }
            break;
        case 1:
            self.topView.selectedType = self.types[row];
            self.bottomView.typeSort = self.types[row];
            switch (row) {
                case 0:
                    self.selectedType = @"0";
                    break;
                case 1:
                    self.selectedType = @"1";
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
    [self.pickerView dismisView];
    WeakSelf(weakSelf)
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(KeyboradDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [weakSelf.tableView.mj_header beginRefreshing];
    });
}

-(CGFloat)CpickerView:(UIPickerView *)pickerView rowHeightForPicker:(NSInteger)component {
    return Height44;
}

#pragma mark - clearSortAction
- (void)clearSortAction {
    self.leftDate = self.rightDate = self.selectedEmployeeId = self.selectedType = nil;
    self.bottomView.timeSort = self.bottomView.employeeSort = self.bottomView.typeSort = nil;
    [self.topView resetAllSortData];
    [self.tableView.mj_header beginRefreshing];
}

@end
