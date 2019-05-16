//
//  HomeVC.m
//  ZHRQ_CBZ
//
//  Created by Mr Lai on 2017/7/1.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import "HomeVC.h"
#import "TopView.h"
#import "NoticeView.h"
#import "FuntionItemCell.h"
#import "BottomView.h"
#import "Function.h"
#import "ScanQRcodeVC.h"
#import "LoginVC.h"
#import "UserInfo.h"
#import "NoticeVC.h"
#import "Notice.h"

typedef enum : NSUInteger {
    LoginTypeAdministrators = 1,        // 管理员
    LoginTypeAverageUser,               // 员工
    LoginTypeNetworkInterruption        // 断网
} LoginType;

@interface HomeVC () <NoticeViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, weak) TopView *topView;
@property (nonatomic, weak) NoticeView *noticeView;
@property (nonatomic, weak) BottomView *bottomView;
@property (nonatomic, weak) UICollectionView *funView;
@property(nonatomic,strong) NSArray *titles;
@property(nonatomic,strong) NSArray<UIImage *> *icons;
@property (nonatomic, strong) NSArray *subTitles;
@property(nonatomic,strong) NSArray *vcs;
@property (nonatomic, assign) NSInteger itemCount;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;
@property(nonatomic,copy)NSString *servicePhone;
@property (nonatomic, strong) UIWebView *webView;
@end

@implementation HomeVC

#pragma mark - view设置
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self setupLoginStatus];
    [self getNoticeData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.noticeView shutDownTimer];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTopView];
    [self setupNoticeView];
    [self setupBottmView];
    [self setupFunctionView];
    [self addNotification];
}

#pragma mark - 初始化

- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] init];
    }
    return _webView;
}

- (void)setupDataSourceWithLoginType:(LoginType)loginType {
        switch (loginType) {
            case LoginTypeAdministrators:
                _titles = @[@"员工管理",@"数据查看",@"通知公告",@"钢瓶管理",@"转移记录"];
                _vcs = @[@"EmployeeManageVC",@"DataViewVC",@"NoticeVC",@"CylinderManageVC",@"TransferRecordVC"];
                _subTitles = @[@"站内员工统一管理",@"员工数据随时查看",@"紧急通知方便获取",@"钢瓶信息一件管理",@"钢瓶转移实时记录"];
                _icons = @[SetImage(@"员工管理"), SetImage(@"数据查看"), SetImage(@"通知公告"), SetImage(@"钢瓶管理"), SetImage(@"转移记录")];
                _itemCount = 5;
                break;
            case LoginTypeAverageUser:
                _titles = @[@"数据查看",@"通知公告"];
                _vcs = @[@"DataViewVC",@"NoticeVC"];
                _subTitles = @[@"员工数据随时查看",@"紧急通知方便获取"];
                _icons = @[SetImage(@"数据查看"), SetImage(@"通知公告")];
                _itemCount = 2;
                break;
            case LoginTypeNetworkInterruption:
                _titles = nil;
                _vcs = nil;
                _subTitles = nil;
                _icons = nil;
                _itemCount = 1;
            default:
                break;
        }
}

- (void)setupTopView {
    TopView *topView = [TopView viewFromXib];
    topView.x = topView.y = 0;
    [topView loginOutBtnAddTarget:self action:@selector(loginOut)];
    [topView QRCodeBtnAddTarget:self action:@selector(QRCode)];
    [self.view addSubview:topView];
    _topView = topView;
}

- (void)setupNoticeView {
    NoticeView *noticeView = [NoticeView viewFromXib];
    noticeView.y = self.topView.maxY;
    noticeView.delegate = self;
    [self.view addSubview:noticeView];
    _noticeView = noticeView;
}

static NSString * const ID = @"ItemCell";
static NSString * const NoDataID = @"NoDataID";

- (void)setupFunctionView {
    CGFloat itemW = self.view.width / 2;
    CGFloat itemH = (self.bottomView.y - self.noticeView.maxY - SpaceHeight) / 3;
    self.layout = [[UICollectionViewFlowLayout alloc] init];
    self.layout.itemSize = CGSizeMake(itemW, itemH);
    self.layout.minimumInteritemSpacing = 0;
    self.layout.minimumLineSpacing = 0;
    
    UICollectionView *funView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.noticeView.maxY, self.view.width, itemH * 3) collectionViewLayout:self.layout];
    funView.backgroundColor = [UIColor whiteColor];
    funView.scrollEnabled = NO;
    funView.dataSource = self;
    funView.delegate = self;
    UINib *xib = [UINib nibWithNibName:@"FuntionItemCell" bundle:nil];
    [funView registerNib:xib forCellWithReuseIdentifier:ID];
    [self.view addSubview:funView];
    _funView = funView;
}

- (void)setupBottmView {
    BottomView *bottomView = [BottomView viewFromXib];
    bottomView.y = self.view.height - bottomView.height;
    [self.view addSubview:bottomView];
    self.servicePhone = [SaveTool objectForKey:ServicePhone];
    NSString *serviceImg = [SaveTool objectForKey:ServiceImg];
    [bottomView.imgView sd_setImageWithURL:[NSURL URLWithString:serviceImg] placeholderImage:[UIImage imageNamed:@"构建安全社会"] options:SDWebImageRetryFailed];
    _bottomView = bottomView;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickTapAction)];
    [_bottomView addGestureRecognizer:tap];
}

-(void)clickTapAction {
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.servicePhone]]]];
}

- (void)setupLoginStatus {
    if (![SaveTool objectForKey:SessID]) {
        LoginVC *loginVc = [[LoginVC alloc] init];
        loginVc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:[[NavigationController alloc] initWithRootViewController:loginVc] animated:YES completion:nil];
    } else {
        [self postLoginRequset];
    }
}

#pragma mark - 接口
- (void)postLoginRequset {
    NSString *url = [MainURL stringByAppendingPathComponent:@"login/index"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[Account] = [SaveTool objectForKey:UserName];
    params[Password] = [SaveTool objectForKey:Pwd];
    params[Type] = MainType;
    
    WeakSelf(weakSelf)
    [HttpTool postWithURL:url params:params success:^(id json) {
        UserInfo *userInfo = [UserInfo mj_objectWithKeyValues:json[Data][Userinfo]];
        weakSelf.topView.userInfo = userInfo;
        switch ([userInfo.level integerValue]) {
            case 1:
                [weakSelf setupDataSourceWithLoginType:LoginTypeAdministrators];
                break;
            case 2:
                [weakSelf setupDataSourceWithLoginType:LoginTypeAverageUser];
                break;
            default:
                break;
        }
        CGFloat itemW = weakSelf.view.width / 2;
        CGFloat itemH = (weakSelf.bottomView.y - weakSelf.noticeView.maxY - SpaceHeight) / 3;
        weakSelf.layout.itemSize = CGSizeMake(itemW, itemH);
        [weakSelf.funView reloadData];
    } failure:^(NSError *error) {
        [weakSelf setupDataSourceWithLoginType:LoginTypeNetworkInterruption];
    }];
}

- (void)getNoticeData {
    NSString *url = [MainURL stringByAppendingPathComponent:@"store/notice"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[SessID] = self.sess_id;
    params[Type] = @1;
    
    WeakSelf(weakSelf)
    [HttpTool getWithURL:url params:params progress:nil success:^(id json) {
        NSArray *noticeArr = [Notice mj_objectArrayWithKeyValuesArray:json[Data][List]];
        NSMutableArray *arrM = [NSMutableArray array];
        for (Notice *notice in noticeArr) {
            [arrM addObject:notice.title];
        }
        weakSelf.noticeView.texts = arrM;
    } failure:^(NSError *error) {
    }];
}


#pragma mark - CollectionView代理和数据源
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.itemCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.itemCount == 1) {
        NoDataCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NoDataID forIndexPath:indexPath];
        return cell;
    } else {
        FuntionItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
        Function *function = [[Function alloc] init];
        function.title = self.titles[indexPath.item];
        function.icon = self.icons[indexPath.item];
        function.subTitle = self.subTitles[indexPath.item];
        cell.function = function;
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *vcStr = self.vcs[indexPath.item];
    if (vcStr.length>0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(KeyboradDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [LaiMethod toPushVC:self.vcs[indexPath.item] viewController:self andTitle:self.titles[indexPath.item]];
        });
    }
}

#pragma mark - NoticeViewDelegate
- (void)didTapWithNoticeView:(NoticeView *)noticeView {
    NoticeVC *noticeVc = [[NoticeVC alloc] init];
    noticeVc.type = 1;
    [self.navigationController pushViewController:noticeVc animated:YES];
}

#pragma mark - loginOut
- (void)loginOut {
    LoginVC *loginVc = [[LoginVC alloc] init];
    loginVc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    WeakSelf(weakSelf)
    [LaiMethod alertControllerWithTitle:nil message:@"确定退出登录?" defaultActionTitle:@"退出" style:UIAlertActionStyleDestructive cancelTitle:@"取消" preferredStyle:UIAlertControllerStyleAlert handler:^{
        [weakSelf presentViewController:[[NavigationController alloc] initWithRootViewController:loginVc] animated:YES completion:nil];
    }];
}

#pragma QRCode
- (void)QRCode {
    ScanQRcodeVC *scanQRcodeVc = [[ScanQRcodeVC alloc] init];
    [self.navigationController pushViewController:scanQRcodeVc animated:YES];
}

#pragma mark - addNotification
- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reLoadData) name:ReloadDataNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkInterruption) name:NetworkInterruptionNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginIn) name:Code301WithDataInnerCodeNotification object:nil];
}

- (void)loginIn {
    LoginVC *loginVc = [[LoginVC alloc] init];
    loginVc.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:[[NavigationController alloc] initWithRootViewController:loginVc] animated:YES completion:nil];
}

- (void)networkInterruption {
    [self setupDataSourceWithLoginType:LoginTypeNetworkInterruption];
    CGFloat itemW = self.view.width;
    CGFloat itemH = (self.bottomView.y - self.noticeView.maxY - SpaceHeight);
    self.layout.itemSize = CGSizeMake(itemW, itemH);
    UINib *xib = [UINib nibWithNibName:@"NoDataCollectionViewCell" bundle:nil];
    [self.funView registerNib:xib forCellWithReuseIdentifier:NoDataID];
    [self reLoadData];
}

- (void)reLoadData {
    [self getNoticeData];
    [self setupLoginStatus];
    [self.funView reloadData];
}

@end
