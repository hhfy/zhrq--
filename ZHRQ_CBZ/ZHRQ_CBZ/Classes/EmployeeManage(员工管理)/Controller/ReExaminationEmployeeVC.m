//
//  ReExaminationEmployeeVC.m
//  ZHRQ_CBZ
//
//  Created by Mr Lai on 2017/7/28.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import "ReExaminationEmployeeVC.h"
#import "Employee.h"

@interface ReExaminationEmployeeVC () <UITableViewDelegate, UITableViewDataSource, ItemAddPhotoCellDelegate>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, copy) NSString *employeeCardDate;
@property (nonatomic, strong) NSArray<UIImage *> *seletedImages;
@property (nonatomic, copy) NSString *employeeCardImages;
@end

@implementation ReExaminationEmployeeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupValue];
    [self setupTableView];
    [self setupAddView];
}

- (void)setupValue {
    self.title = @"过期审核";
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - NavHeight) style:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIColor clearColor];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.estimatedRowHeight = 45.0f;
    tableView.scrollEnabled = YES;
    tableView.rowHeight = UITableViewAutomaticDimension;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableView];
    _tableView = tableView;
}

- (void)setupAddView {
    NormalBottomView *addView = [NormalBottomView viewFromXib];
    addView.title = @"提交";
    [addView addTarget:self action:@selector(addViewAction)];
    self.tableView.tableFooterView = addView;
}

- (void)setupDatePickerWithReloadIndex:(NSInteger)index {
    KSDatePicker* picker = [[KSDatePicker alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width - 40, 300)];
    picker.appearance.radius = 5;
    picker.appearance.minimumDate = [NSDate date];
    //设置回调
    WeakSelf(weakSelf)
    picker.appearance.resultCallBack = ^void(KSDatePicker* datePicker,NSDate* currentDate,KSDatePickerButtonType buttonType){
        if (buttonType == KSDatePickerButtonCommit) {
            weakSelf.employeeCardDate = [NSString stringFormDateFromat:currentDate formatter:FmtYMD];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
            [weakSelf.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
    };
    [picker show];
}

#pragma mark - 接口
- (void)postReExaminationEmployeeRequest {
    NSString *url = [MainURL stringByAppendingPathComponent:@"store/modify_info"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[SessID] = self.sess_id;
    params[@"id"] = self.employee.ID;
    params[@"images"] = self.employeeCardImages;
    params[@"expiration_time"] = self.employeeCardDate;
    
    WeakSelf(weakSelf)
    [HttpTool postWithURL:url params:params success:^(id json) {
        [MBProgressHUD showSuccess:@"添加成功,请等待审核!"];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(JumpVcDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        });
    } failure:^(NSError *error) {
    }];
}

- (void)uploadImages {
    NSString *url = [MainURL stringByAppendingPathComponent:@"store/upload_image"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[SessID] = self.sess_id;
    
    NSMutableArray *formDataArray = [NSMutableArray array];
    for (int i = 0 ; i < self.seletedImages.count; i++) {
        UIImage *image = self.seletedImages[i];
        FormData *formData = [FormData setData:UIImageJPEGRepresentation(image, 0.8) name:[NSString stringWithFormat:@"%d", i] mimeType:@"image/jpg" fileName:[NSString stringWithFormat:@"image%zd.jpg", i]];
        [formDataArray addObject:formData];
    }
    
    WeakSelf(weakSelf)
    [HttpTool postWithURL:url params:params progress:nil formDataArray:formDataArray success:^(id json) {
        weakSelf.employeeCardImages = [NSString jsonStrFromatWithArray:json[Data]];
        [weakSelf postReExaminationEmployeeRequest];
    } failure:^(NSError *error) {
    }];
}

#pragma mark - 数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
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
            ItemAddPhotoCell *cell = [ItemAddPhotoCell cellFromXibWithTableView:tableView];
            cell.title = @"上传工作证";
            cell.delegate = self;
            cell.photoCount = 2;
            return cell;
        }
            break;
        case 3:
        {
            ItemArrowCell *cell = [ItemArrowCell cellFromXibWithTableView:tableView];
            cell.text = (self.employeeCardDate) ? self.employeeCardDate : @"请选择员工证到期时间";
            cell.textColor = (self.employeeCardDate) ? SetupColor(51, 51, 51) : SetupColor(153, 153, 153);
            return cell;
        }
            break;
        default:
            break;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 3) {
        [self setupDatePickerWithReloadIndex:3];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return NoneSpace;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return SpaceHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark - ItemAddPhotoCellDelegate
- (void)itemAddPhotoCell:(ItemAddPhotoCell *)itemAddPhotoCell selectedPhotos:(NSArray<UIImage *> *)photos {
    self.seletedImages = photos;
}

#pragma mark - addViewAction
- (void)addViewAction {
    if (self.seletedImages.count == 0) {
        [MBProgressHUD showError:@"请上传工作照"];
        return;
    } else if (self.employeeCardDate.length == 0) {
        [MBProgressHUD showError:@"请选择工作照到期时间"];
        return;
    }
    [self uploadImages];
}

@end
