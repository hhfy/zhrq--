//
//  EmployeeManageVC.m
//  ZHRQ_CBZ
//
//  Created by Mr Lai on 2017/7/1.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import "EmployeeManageVC.h"
#import "EmployeeCell.h"
#import "Employee.h"
#import "AddEmployVC.h"
#import "ResetEmployPwdVC.h"
#import "ReExaminationEmployeeVC.h"

@interface EmployeeManageVC () <UITableViewDataSource, UITableViewDelegate, EmployeeCellDelegate>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *employees;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) UIWebView *webView;
@end

@implementation EmployeeManageVC

- (UIWebView *)webView
{
    if (_webView == nil)
    {
        _webView = [[UIWebView alloc] init];
    }
    return _webView;
}


- (NSMutableArray *)employees
{
    if (_employees == nil)
    {
        _employees = [NSMutableArray array];
    }
    return _employees;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getNewEmployeeData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupValue];
    [self setupTableView];
    [LaiMethod setupDownRefreshWithTableView:self.tableView target:self action:@selector(getNewEmployeeData)];
    [self setupNav];
}

- (void)setupNav {
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(addEmploy)];
}

- (void)setupValue {
    self.title = self.titleString;
    self.count = 0;
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - NavHeight) style:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.estimatedRowHeight = 45.0f;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    _tableView = tableView;
}

#pragma mark - 接口
- (void)getNewEmployeeData {
    self.currentPage = 1;
    [self getEmployeeData];
}

- (void)getMoreEmployeeData {
    self.currentPage++;
    [self getEmployeeData];
}

- (void)getEmployeeData {
    if (self.tableView.scrollsToTop == NO) return;
    NSString *url = [MainURL stringByAppendingPathComponent:@"store/staff"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[SessID] = self.sess_id;
    params[Page] = @(self.currentPage);
    params[Type] = MainType;
    
    WeakSelf(weakSelf)
    [HttpTool getWithURL:url params:params progress:nil success:^(id json) {
        if (weakSelf.currentPage == 1) [weakSelf.employees removeAllObjects];
        NSArray *employeeArr = [Employee mj_objectArrayWithKeyValuesArray:json[Data][List]];
        [weakSelf.employees addObjectsFromArray:employeeArr];
        [LaiMethod setupUpRefreshWithTableView:weakSelf.tableView target:weakSelf action:@selector(getMoreEmployeeData)];
        weakSelf.count = 1;
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
        if (self.employees.count == [json[Data][Total] integerValue]) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        if (weakSelf.currentPage > 1) self.currentPage--;
        weakSelf.count = 1;
        [weakSelf.tableView reloadData];
    }];
}

#pragma mark - tableView数据和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (self.employees.count > 0) ? self.employees.count : self.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        if (self.employees.count == 0) {
            self.tableView.scrollEnabled = NO;
            NoDataCell *cell = [NoDataCell cellFromXibWithTableView:tableView];
            return cell;
        } else {
            EmployeeCell *cell = [EmployeeCell cellFromXibWithTableView:tableView];
            cell.tag = indexPath.row;
            cell.delegate = self;
            Employee *employee = self.employees[indexPath.row];
            cell.employee = employee;
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
    Employee *employee = self.employees[indexPath.row];
    
    switch (employee.is_overdue) {
        case 0:
        {
            ResetEmployPwdVC *resetEmployPwdVc = [[ResetEmployPwdVC alloc] init];
            resetEmployPwdVc.employee = employee;
            [self.navigationController pushViewController:resetEmployPwdVc animated:YES];
        }
            break;
        case 1:
        {
            ReExaminationEmployeeVC *reExamitionVc = [[ReExaminationEmployeeVC alloc] init];
            reExamitionVc.employee = employee;
            [self.navigationController pushViewController:reExamitionVc animated:YES];
        }
            break;
        default:
            break;
    }
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [EmployeeCell creatAnimationWithCell:cell];
}

#pragma mark - EmployeeCellDelegate
- (void)employeeCell:(EmployeeCell *)employeeCell callPhoneBtnDidClic:(UIButton *)button {
    Employee *employee = self.employees[button.tag];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", employee.account]]]];
}

#pragma mark - addEmploy
- (void)addEmploy {
    AddEmployVC *addEmployVc = [[AddEmployVC alloc] init];
    [self.navigationController pushViewController:addEmployVc animated:YES];
}

@end
