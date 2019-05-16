
//
//  DataBottomView.m
//  ZHRQ_CBZ
//
//  Created by Mr Lai on 2017/7/6.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import "DataBottomView.h"
#import "DataView.h"

@interface DataBottomView ()
@property (weak, nonatomic) IBOutlet UILabel *sumCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *bottomSumCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeSortLabel;
@property (weak, nonatomic) IBOutlet UILabel *employeeSortLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeSortLabel;
@end

@implementation DataBottomView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    self.width = MainScreenSize.width;
    self.sumCountLabel.hidden = NO;
    self.bottomSumCountLabel.hidden = YES;
    self.timeSortLabel.hidden = self.employeeSortLabel.hidden = self.typeSortLabel.hidden = YES;
}

- (void)setDataRecord:(DataRecord *)dataRecord {
    _dataRecord = dataRecord;
    self.sumCountLabel.text = [NSString stringWithFormat:@"激活%@次, 充装%@次", dataRecord.activation, dataRecord.filling];
    self.bottomSumCountLabel.text = [NSString stringWithFormat:@"激活%@次, 充装%@次", dataRecord.activation, dataRecord.filling];
}

- (void)setTimeSort:(NSString *)timeSort {
    _timeSort = [timeSort copy];
    self.timeSortLabel.text = timeSort;
    if (timeSort) {
        self.timeSortLabel.hidden = NO;
        self.sumCountLabel.hidden = YES;
        self.bottomSumCountLabel.hidden = NO;
    } else {
        self.timeSortLabel.hidden = YES;
        self.sumCountLabel.hidden = NO;
        self.bottomSumCountLabel.hidden = YES;
    }
}

- (void)setEmployeeSort:(NSString *)employeeSort {
    _employeeSort = [employeeSort copy];
    self.employeeSortLabel.text = employeeSort;
    if (employeeSort) {
        self.employeeSortLabel.hidden = NO;
        self.sumCountLabel.hidden = YES;
        self.bottomSumCountLabel.hidden = NO;
    } else {
        self.employeeSortLabel.hidden = YES;
        self.sumCountLabel.hidden = NO;
        self.bottomSumCountLabel.hidden = YES;
    }
}

- (void)setTypeSort:(NSString *)typeSort {
    _typeSort = [typeSort copy];
    self.typeSortLabel.text = typeSort;
    if (typeSort) {
        self.typeSortLabel.hidden = NO;
        self.sumCountLabel.hidden = YES;
        self.bottomSumCountLabel.hidden = NO;
    } else {
        self.typeSortLabel.hidden = YES;
        self.sumCountLabel.hidden = NO;
        self.bottomSumCountLabel.hidden = YES;
    }
}

@end
