
//
//  DataViewCell.m
//  ZHRQ_CBZ
//
//  Created by Mr Lai on 2017/7/6.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import "DataViewCell.h"
#import "DataView.h"

@interface DataViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *cylinderNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *employeeLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@end

@implementation DataViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setDataView:(DataView *)dataView {
    _dataView = dataView;
    self.cylinderNoLabel.text = [NSString stringWithFormat:@"钢瓶编号：%@", dataView.no];
    self.employeeLabel.text = [NSString stringWithFormat:@"员工：%@", dataView.name];
    self.timeLabel.text = [NSString stringFromTimestampFromat:dataView.add_time formatter:FmtYMDHM];
    switch (dataView.status) {
        case 0:
            self.statusLabel.text = @"激活";
            break;
        case 1:
            self.statusLabel.text = @"充装";
            break;
        case 2:
            self.statusLabel.text = @"送瓶";
            break;
        case 3:
            self.statusLabel.text = @"使用中";
            break;
        case 4:
            self.statusLabel.text = @"收瓶";
            break;
        default:
            break;
    }
}


@end
