//
//  NoticeVC.m
//  ZHRQ_CBZ
//
//  Created by Mr Lai on 2017/7/1.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import "NoticeVC.h"
#import "NoticeCell.h"
#import "Notice.h"
#import "NoticeDetialVC.h"

@interface NoticeVC () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *notices;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger count;
@end

@implementation NoticeVC
- (NSMutableArray *)notices
{
    if (_notices == nil)
    {
        _notices = [NSMutableArray array];
    }
    return _notices;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getNewNoticeData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupValue];
    [self setupTableView];
    [LaiMethod setupDownRefreshWithTableView:self.tableView target:self action:@selector(getNewNoticeData)];
}

- (void)setupValue {
    self.title = (self.titleString) ? self.titleString : @"通知公告";
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
/* 获取通知列表 */
- (void)getNewNoticeData {
    self.currentPage = 1;
    [self getNoticeData];
}

- (void)getMoreNoticeData {
    self.currentPage++;
    [self getNoticeData];
}

- (void)getNoticeData {
    if (self.tableView.scrollsToTop == NO) return;
    NSString *url = [MainURL stringByAppendingPathComponent:@"store/notice"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[SessID] = self.sess_id;
    params[Page] = @(self.currentPage);
    params[Type] = @(self.type);
    
    WeakSelf(weakSelf)
    [HttpTool getWithURL:url params:params progress:nil success:^(id json) {
        if (weakSelf.currentPage == 1) [weakSelf.notices removeAllObjects];
        NSArray *noticeArr = [Notice mj_objectArrayWithKeyValuesArray:json[Data][List]];
        [weakSelf.notices addObjectsFromArray:noticeArr];
        weakSelf.count = 1;
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
        if (self.type == 1) return;
        [LaiMethod setupUpRefreshWithTableView:weakSelf.tableView target:weakSelf action:@selector(getMoreNoticeData)];
        if (self.notices.count == [json[Data][Total] integerValue]) {
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
    return (self.notices.count > 0) ? self.notices.count : self.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.notices.count == 0) {
        self.tableView.scrollEnabled = NO;
        NoDataCell *cell = [NoDataCell cellFromXibWithTableView:tableView];
        return cell;
    } else {
        self.tableView.scrollEnabled = YES;
        NoticeCell *cell = [NoticeCell cellFromXibWithTableView:tableView];
        Notice *notice = self.notices[indexPath.row];
        cell.notice = notice;
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
    if (self.notices.count == 0) return;
    Notice *notice = self.notices[indexPath.row];
    NoticeDetialVC *noticeDetialVc = [[NoticeDetialVC alloc] init];
    noticeDetialVc.noticeId = notice.ID;
    [self.navigationController pushViewController:noticeDetialVc animated:YES];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [NoticeCell creatAnimationWithCell:cell];
}

@end
