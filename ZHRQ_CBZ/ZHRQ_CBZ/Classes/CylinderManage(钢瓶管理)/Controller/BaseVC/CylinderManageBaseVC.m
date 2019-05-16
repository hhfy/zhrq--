
//
//  CulinderManageBaseVC.m
//  ZHRQ_CBZ
//
//  Created by Mr Lai on 2017/7/5.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import "CylinderManageBaseVC.h"
#import "CylinderCell.h"
#import "Cylinder.h"
#import "CylinderTotalView.h"

@interface CylinderManageBaseVC () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *cylinders;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, weak) CylinderTotalView *bottomView;
@end

@implementation CylinderManageBaseVC

- (NSMutableArray *)cylinders
{
    if (_cylinders == nil)
    {
        _cylinders = [NSMutableArray array];
    }
    return _cylinders;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getNewCylinderData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupBottomView];
    [self setupTableView];
    [LaiMethod setupDownRefreshWithTableView:self.tableView target:self action:@selector(getNewCylinderData)];
    [self addNotification];
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - NavHeight - self.bottomView.height) style:UITableViewStylePlain];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.estimatedRowHeight = 45.0f;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.contentInset = UIEdgeInsetsMake(Height44 + SpaceHeight, 0, 0, 0);
    tableView.scrollIndicatorInsets = tableView.contentInset;
    [self.view addSubview:tableView];
    _tableView = tableView;
}

- (void)setupBottomView {
    CylinderTotalView *bottomView = [CylinderTotalView viewFromXib];
    bottomView.y = self.view.height - bottomView.height - 64;
    [self.view addSubview:bottomView];
    _bottomView = bottomView;
}

- (void)setupBottomViewInfo {
    NSString *titleName = nil;
    switch (self.cylinderType) {
        case CylinderTypeAll:
            titleName = @"全部钢瓶";
            break;
        case CylinderTypeNormal:
            titleName = @"正常钢瓶";
            break;
        case CylinderTypeAbnormal:
            titleName = @"异常钢瓶";
            break;
        case CylinderTypeDisable:
            titleName = @"禁用钢瓶";
            break;
        case CylinderTypeWithhold:
            titleName = @"暂扣钢瓶";
            break;
        default:
            break;
    }
    
    self.bottomView.totalText = [NSString stringWithFormat:@"%@%zd个", titleName, self.cylinders.count];
}

#pragma mark - 接口
- (void)getNewCylinderData {
    self.currentPage = 1;
    [self getCylinderData];
}

- (void)getMoreCylinderData {
    self.currentPage++;
    [self getCylinderData];
}

- (void)getCylinderData {
    if (self.tableView.scrollsToTop == NO) return;
    NSString *url = [MainURL stringByAppendingPathComponent:@"store/cylinder"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[SessID] = self.sess_id;
    params[Page] = @(self.currentPage);
    params[StoreId] = self.store_id;
    params[@"proc_status"] = (self.cylinderType == 0) ? nil : @(self.cylinderType);
    
    WeakSelf(weakSelf)
    [HttpTool getWithURL:url params:params progress:nil success:^(id json) {
        if (weakSelf.currentPage == 1) [weakSelf.cylinders removeAllObjects];
        NSArray *cylinderArr = [Cylinder mj_objectArrayWithKeyValuesArray:json[Data][List]];
        [weakSelf.cylinders addObjectsFromArray:cylinderArr];
        [LaiMethod setupUpRefreshWithTableView:weakSelf.tableView target:weakSelf action:@selector(getMoreCylinderData)];
        [weakSelf setupBottomViewInfo];
        weakSelf.count = 1;
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
        if (self.cylinders.count == [json[Data][Total] integerValue]) {
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
    return (self.cylinders.count > 0) ? self.cylinders.count : self.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        if (self.cylinders.count == 0) {
            self.tableView.scrollEnabled = NO;
            NoDataCell *cell = [NoDataCell cellFromXibWithTableView:tableView];
            return cell;
        } else {
            CylinderCell *cell = [CylinderCell cellFromXibWithTableView:tableView];
            Cylinder *cylinder = self.cylinders[indexPath.row];
            cell.cylinder = cylinder;
            return cell;
        }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return NoneSpace;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return NoneSpace;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [CylinderCell creatAnimationWithCell:cell];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

#pragma mark - 监听通知
- (void)addNotification {
    WeakSelf(weakSelf)
    [[NSNotificationCenter defaultCenter] addObserverForName:TitleButtonDidRepeatClickNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        if (weakSelf.view.window == nil) return;
        if (weakSelf.tableView.scrollsToTop == NO) return;
        [weakSelf.tableView.mj_header beginRefreshing];
    }];
}

@end
