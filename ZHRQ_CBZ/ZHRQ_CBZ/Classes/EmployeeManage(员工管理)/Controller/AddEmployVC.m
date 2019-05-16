

//
//  AddEmployVC.m
//  ZHRQ_CBZ
//
//  Created by Mr Lai on 2017/7/1.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import "AddEmployVC.h"
#import "IDPhotoInstructionView.h"

@interface AddEmployVC () <UITableViewDelegate, UITableViewDataSource, ItemAddPhotoCellDelegate, ItemTextFiledCellDelegate>
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong) NSArray<UIImage *> *IDphotos;
@property (nonatomic, strong) NSArray<UIImage *> *employeeCardphotos;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *phone;
@property (nonatomic, copy) NSString *pwd;
@property (nonatomic, copy) NSString *IDCardImages;
@property (nonatomic, copy) NSString *employeeCardImages;
@property (nonatomic, copy) NSString *employeeCardDate;
@end

@implementation AddEmployVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupValue];
    [self setupTableView];
    [self setupAddView];
}

- (void)setupValue {
    self.title = @"添加员工";
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
    addView.title = @"确定添加";
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
- (void)postAddEmployeeRequest {
    NSString *url = [MainURL stringByAppendingPathComponent:@"store/staff_add"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[SessID] = self.sess_id;
    params[@"name"] = self.name;
    params[Account] = self.phone;
    params[Password] = self.pwd;
    params[@"images"] = self.employeeCardImages;
    params[@"card_pic"] = self.IDCardImages;
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

- (void)postJudgeMoblieReqest {
    NSString *url = [MainURL stringByAppendingPathComponent:@"store/account_check"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[SessID] = self.sess_id;
    params[@"account"] = self.phone;
    
    WeakSelf(weakSelf)
    [HttpTool postWithURL:url params:params success:^(id json) {
        [weakSelf uploadIDCardImages];
    } failure:^(NSError *error) {
    }];
}

- (void)uploadIDCardImages {
    NSString *url = [MainURL stringByAppendingPathComponent:@"store/upload_image"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[SessID] = self.sess_id;
    
    NSMutableArray *formDataArray = [NSMutableArray array];
    for (int i = 0 ; i < self.IDphotos.count; i++) {
        UIImage *image = self.IDphotos[i];
        FormData *formData = [FormData setData:UIImageJPEGRepresentation(image, 0.8) name:[NSString stringWithFormat:@"%d", i] mimeType:@"image/jpg" fileName:[NSString stringWithFormat:@"image%zd.jpg", i]];
        [formDataArray addObject:formData];
    }
    
    WeakSelf(weakSelf)
    [HttpTool postWithURL:url params:params progress:nil formDataArray:formDataArray success:^(id json) {
        weakSelf.IDCardImages = [NSString jsonStrFromatWithArray:json[Data]];
        [weakSelf uploadEmployeeCardImages];
    } failure:^(NSError *error) {
    }];
}

- (void)uploadEmployeeCardImages {
    NSString *url = [MainURL stringByAppendingPathComponent:@"store/upload_image"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[SessID] = self.sess_id;
    
    NSMutableArray *formDataArray = [NSMutableArray array];
    for (int i = 0 ; i < self.employeeCardphotos.count; i++) {
        UIImage *image = self.employeeCardphotos[i];
        FormData *formData = [FormData setData:UIImageJPEGRepresentation(image, 0.8) name:[NSString stringWithFormat:@"%d", i] mimeType:@"image/jpg" fileName:[NSString stringWithFormat:@"image%zd.jpg", i]];
        [formDataArray addObject:formData];
    }
    
    WeakSelf(weakSelf)
    [HttpTool postWithURL:url params:params progress:nil formDataArray:formDataArray success:^(id json) {
        weakSelf.employeeCardImages = [NSString jsonStrFromatWithArray:json[Data]];
        [weakSelf postAddEmployeeRequest];
    } failure:^(NSError *error) {
    }];
}

#pragma mark - 数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ItemTextFiledCell *cell = [ItemTextFiledCell cellFromXibWithTableView:tableView];
    cell.tag = indexPath.row;
    switch (indexPath.row) {
        case 0:
        {
            cell.placeholderText = @"请输入员工姓名";
            cell.textType = InputTextTypeName;
        }
            break;
        case 1:
        {
            cell.placeholderText = @"请输入员工账号(手机)";
            cell.textType = InputTextTypeTelphone;
            cell.keyboardType = UIKeyboardTypeNumberPad;
        }
            break;
        case 2:
        {
            cell.placeholderText = @"请输入员工密码";
            cell.textType = InputTextTypePwd;
            cell.keyboardType = UIKeyboardTypeASCIICapable;
        }
            break;
        case 3:
        {
            ItemAddPhotoCell *cell = [ItemAddPhotoCell cellFromXibWithTableView:tableView];
            cell.tag = 0;
            cell.title = @"上传员身份证";
            cell.delegate = self;
            cell.photoCount = 2;
            cell.hiddenHelpBtn = NO;
            return cell;
        }
            break;
        case 4:
        {
            ItemAddPhotoCell *cell = [ItemAddPhotoCell cellFromXibWithTableView:tableView];
            cell.tag = 1;
            cell.title = @"上传工作证";
            cell.delegate = self;
            cell.photoCount = 2;
            return cell;
        }
            break;
        case 5:
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
    cell.delegate = self;
    return cell;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
    if (indexPath.row == 5) [self setupDatePickerWithReloadIndex:5];
}

#pragma mark - ItemTextFiledCellDelegate
- (void)itemTextFiledCell:(ItemTextFiledCell *)cell itemTextFieldInputTextField:(UITextField *)textField {
    switch (textField.tag) {
        case 0:
            self.name = textField.text;
            break;
        case 1:
            self.phone = textField.text;
            break;
        case 2:
            self.pwd = textField.text;
            break;
        default:
            break;
    }
}

#pragma mark - ItemAddPhotoCellDelegate
- (void)itemAddPhotoCell:(ItemAddPhotoCell *)itemAddPhotoCell selectedPhotos:(NSArray<UIImage *> *)photos {
    switch (itemAddPhotoCell.tag) {
        case 0:
            self.IDphotos = photos;
            break;
        case 1:
            self.employeeCardphotos = photos;
            break;
        default:
            break;
    }
}

- (void)photosViewDidClick:(ItemAddPhotoCell *)itemAddPhotoCell {
    [self.view endEditing:YES];
}

- (void)didReloadTableView:(ItemAddPhotoCell *)itemAddPhotoCell {
    [self.tableView reloadData];
}

- (void)itemAddPhotoCell:(ItemAddPhotoCell *)itemAddPhotoCell helpBtnDidClick:(UIButton *)button {
    [self.view endEditing:YES];
    IDPhotoInstructionView *instructionView = [IDPhotoInstructionView viewFromXib];
    [instructionView show];
}

#pragma mark - addViewAction
- (void)addViewAction {
    [self.view endEditing:YES];
    if (self.name.length == 0) {
        [MBProgressHUD showError:@"请输入员工姓名"];
        return;
    } else if (self.phone.length == 0) {
        [MBProgressHUD showError:@"请创建员工账号(手机)"];
        return;
    } else if (self.pwd.length == 0) {
        [MBProgressHUD showError:@"请设置密码"];
        return;
    } else if (![VerificationTool validatePwd:self.pwd]) {
        [MBProgressHUD showError:@"密码为6-15数字字母"];
        return;
    } else if (self.IDphotos.count == 0) {
        [MBProgressHUD showError:@"请上传身份证照片"];
        return;
    } else if (self.employeeCardphotos.count == 0) {
        [MBProgressHUD showError:@"请上传工作证照片"];
        return;
    } else if (self.employeeCardDate.length == 0) {
        [MBProgressHUD showError:@"请填写工作证到期时间"];
        return;
    }
    [self postJudgeMoblieReqest];
}

@end
