//
//  DataTopView.m
//  ZHRQ_CBZ
//
//  Created by Mr Lai on 2017/7/5.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import "DataTopView.h"
#import "DateSelectView.h"

@interface DataTopView () <DataSelectViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *timeSortBtn;
@property (weak, nonatomic) IBOutlet UIButton *employeeSortBtn;
@property (weak, nonatomic) IBOutlet UIButton *typeSortBtn;
@property (nonatomic, copy) NSString *time;
@property (nonatomic, copy) NSString *employee;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, strong) DateSelectView *dateSelectView;
@property (weak, nonatomic) IBOutlet UILabel *leftTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightTimeLabel;
@end

@implementation DataTopView

#define LineW 0.5
#define LineH 15
- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [SetupColor(227, 227, 227) setFill];
    UIRectFill(CGRectMake(rect.size.width / 3, (rect.size.height - LineH) * 0.5, LineW, LineH));
    UIRectFill(CGRectMake(rect.size.width / 3 * 2, (rect.size.height - LineH) * 0.5, LineW, LineH));
}

- (DateSelectView *)dateSelectView
{
    if (_dateSelectView == nil)
    {
        _dateSelectView = [DateSelectView viewFromXib];
        _dateSelectView.delegate = self;
        [_dateSelectView leftBtnAddTarget:self action:@selector(leftBtnAction)];
        [_dateSelectView rightBtnAddTarget:self action:@selector(rightBtnAction)];
    }
    return _dateSelectView;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupValue];
    [self setupUI];
    [self addNotification];
}

- (void)setupValue {
    self.time = @"按时间";
    self.employee = @"按员工";
    self.type = @"按类型";
}

- (void)setupUI {
    self.width = MainScreenSize.width;
    self.timeSortBtn.titleLabel.font = self.employeeSortBtn.titleLabel.font = self.typeSortBtn.titleLabel.font = IconFont(14);
    [self.timeSortBtn setTitle:[NSString stringWithFormat:@"%@ %@", self.time, DownArrowIconUnicode] forState:UIControlStateNormal];
    [self.timeSortBtn setTitle:[NSString stringWithFormat:@"%@ %@", self.time, UpArrowIconUnicode] forState:UIControlStateSelected];
    [self.employeeSortBtn setTitle:[NSString stringWithFormat:@"%@ %@", self.employee, DownArrowIconUnicode] forState:UIControlStateNormal];
    [self.employeeSortBtn setTitle:[NSString stringWithFormat:@"%@ %@", self.employee, UpArrowIconUnicode] forState:UIControlStateSelected];
    [self.typeSortBtn setTitle:[NSString stringWithFormat:@"%@ %@", self.type, DownArrowIconUnicode] forState:UIControlStateNormal];
    [self.typeSortBtn setTitle:[NSString stringWithFormat:@"%@ %@", self.type, UpArrowIconUnicode] forState:UIControlStateSelected];
}

- (IBAction)timeSortBtnClick:(UIButton *)button {
    button.selected = !button.isSelected;
    if (self.timeSortBtn.isSelected) {
        [self.dateSelectView showFrom:self];
    } else {
        [self.dateSelectView dismiss];
    }
}

- (IBAction)employeeSortBtnClick:(UIButton *)button {
    button.selected = !button.isSelected;
    [self dismissTimeSortBtnStatus];
    if (button.isSelected) {
        if ([self.delegate respondsToSelector:@selector(didSelectedEmployee:)]) {
            [self.delegate didSelectedEmployee:self];
        }
    }
}

- (IBAction)typeSortBtnClick:(UIButton *)button {
    button.selected = !button.isSelected;
    [self dismissTimeSortBtnStatus];
    if (button.isSelected) {
        if ([self.delegate respondsToSelector:@selector(didSelectedType:)]) {
            [self.delegate didSelectedType:self];
        }
    }
}

#pragma mark - 重置按钮
- (void)resetBtnWithBtn:(UIButton *)button title:(NSString *)title {
    [button setTitle:[NSString stringWithFormat:@"%@ %@", title, DownArrowIconUnicode] forState:UIControlStateNormal];
    [button setTitle:[NSString stringWithFormat:@"%@ %@", title, UpArrowIconUnicode] forState:UIControlStateSelected];
}

- (void)dismissTimeSortBtnStatus {
    if (self.timeSortBtn.isSelected) {
        [self.dateSelectView dismiss];
        self.timeSortBtn.selected = NO;
    }
}

#pragma mark - 重置数据
- (void)resetAllSortData {
    [self resetTypeSortData];
    [self resetEmployeeSortDat];
    [self resetTimeSortData];
}

- (void)resetTimeSortData {
    self.dateSelectView.leftDate = self.dateSelectView.rightDate = nil;
    self.leftTimeLabel.text = self.rightTimeLabel.text = nil;
    [self resetBtnWithBtn:self.timeSortBtn title:self.time];
    [self.dateSelectView dismiss];
    if (self.timeSortBtn.isSelected) {
        [self timeSortBtnClick:self.timeSortBtn];
    }
    if ([self.delegate respondsToSelector:@selector(reSetDate:)]) {
        [self.delegate reSetDate:self];
    }
}

- (void)resetEmployeeSortDat {
    if (!self.employeeSortBtn.isSelected) {
        [self resetBtnWithBtn:self.employeeSortBtn title:self.employee];
    }
}

- (void)resetTypeSortData {
    if (!self.typeSortBtn.isSelected) {
        [self resetBtnWithBtn:self.typeSortBtn title:self.type];
    }
}

#pragma mark - DataSelectViewDelegate
- (void)dropdownMenuDidShow:(DateSelectView *)menu {
    self.timeSortBtn.selected = YES;
}

- (void)dropdownMenuDidDismiss:(DateSelectView *)menu {
    self.timeSortBtn.selected = NO;
}

- (void)leftBtnAction {
    if ([self.delegate respondsToSelector:@selector(didClickLeftBtn:)]) {
        [self.delegate didClickLeftBtn:self];
    }
}

- (void)rightBtnAction {
    if ([self.delegate respondsToSelector:@selector(didClickRightBtn:)]) {
        [self.delegate didClickRightBtn:self];
    }
}

- (void)didSelectedDate:(DateSelectView *)menu {
    [self resetBtnWithBtn:self.timeSortBtn title:@"               "];
    self.leftTimeLabel.text = self.leftDate;
    self.rightTimeLabel.text = self.rightDate;
}

- (void)didDismiss:(DateSelectView *)dateSelectView {
    if ([self.delegate respondsToSelector:@selector(didSelectedDate:)]) {
        [self.delegate didSelectedDate:self];
    }
}

- (void)setLeftDate:(NSString *)leftDate {
    _leftDate = [leftDate copy];
    self.dateSelectView.leftDate = leftDate;
}

- (void)setRightDate:(NSString *)rightDate {
    _rightDate = [rightDate copy];
    self.dateSelectView.rightDate = rightDate;
}

- (void)setIsDismiss:(BOOL)isDismiss {
    _isDismiss = isDismiss;
    [self.dateSelectView dismiss];
}

- (void)setSelectedType:(NSString *)selectedType {
    _selectedType = [selectedType copy];
    [self resetBtnWithBtn:self.typeSortBtn title:selectedType];
    self.typeSortBtn.selected = NO;
}

- (void)setSelectedEmployee:(NSString *)selectedEmployee {
    _selectedEmployee = selectedEmployee;
    [self resetBtnWithBtn:self.employeeSortBtn title:selectedEmployee];
    self.employeeSortBtn.selected = NO;
}

#pragma mark - addNotification 
- (void)addNotification {
    WeakSelf(weakSelf)
    [[NSNotificationCenter defaultCenter] addObserverForName:CustomPickerDismissNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        weakSelf.typeSortBtn.selected = NO;
        weakSelf.employeeSortBtn.selected = NO;
    }];
}

@end
