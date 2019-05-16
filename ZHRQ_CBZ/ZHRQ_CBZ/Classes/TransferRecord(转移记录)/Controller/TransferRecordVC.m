
//
//  TransferRecordVC.m
//  ZHRQ_CBZ
//
//  Created by Mr Lai on 2017/7/1.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import "TransferRecordVC.h"
#import "TransferSectionView.h"
#import "TransferRecordCell.h"
#import "TransferRecord.h"

@interface TransferRecordVC () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, weak) TransferSectionView *topView;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) NSMutableArray *records;
@end

@implementation TransferRecordVC

- (NSMutableArray *)records
{
    if (_records == nil)
    {
        _records = [NSMutableArray array];
    }
    return _records;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getNewRecordData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupValue];
    [self setupTopView];
    [self setupTableView];
    [LaiMethod setupDownRefreshWithTableView:self.tableView target:self action:@selector(getNewRecordData)];
}

- (void)setupValue {
    self.title = @"转移记录";
    self.count = 0;
}

- (void)setupTopView {
    TransferSectionView *topView = [TransferSectionView viewFromXib];
    [self.view addSubview:topView];
    _topView = topView;
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.topView.maxY, self.view.width, self.view.height - NavHeight - self.topView.height) style:UITableViewStylePlain];
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
- (void)getNewRecordData {
    self.currentPage = 1;
    [self getRecordData];
}

- (void)getMoreRecordData {
    self.currentPage++;
    [self getRecordData];
}

- (void)getRecordData {
    if (self.tableView.scrollsToTop == NO) return;
    NSString *url = [MainURL stringByAppendingPathComponent:@"store/transfer"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[SessID] = self.sess_id;
    params[Page] = @(self.currentPage);
    params[Type] = MainType;
    
    WeakSelf(weakSelf)
    [HttpTool getWithURL:url params:params progress:nil success:^(id json) {
        if (weakSelf.currentPage == 1) [weakSelf.records removeAllObjects];
        NSArray *recordArr = [TransferRecord mj_objectArrayWithKeyValuesArray:json[Data][List]];
        [weakSelf.records addObjectsFromArray:recordArr];
        [LaiMethod setupUpRefreshWithTableView:weakSelf.tableView target:weakSelf action:@selector(getMoreRecordData)];
        weakSelf.count = 1;
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
        if (self.records.count == [json[Data][Total] integerValue]) {
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        if (weakSelf.currentPage > 1) self.currentPage--;
        weakSelf.count = 1;
        [weakSelf.tableView reloadData];
    }];
}


#pragma mark - 数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (self.records.count > 0) ? self.records.count : self.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        if (self.records.count == 0) {
            self.tableView.scrollEnabled = NO;
            NoDataCell *cell = [NoDataCell cellFromXibWithTableView:tableView];
            return cell;
        } else {
            self.tableView.scrollEnabled = YES;
            TransferRecordCell *cell = [TransferRecordCell cellFromXibWithTableView:tableView];
            TransferRecord *transferRecord = self.records[indexPath.row];
            cell.transferRecord = transferRecord;
            return cell;
        }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return NoneSpace;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
