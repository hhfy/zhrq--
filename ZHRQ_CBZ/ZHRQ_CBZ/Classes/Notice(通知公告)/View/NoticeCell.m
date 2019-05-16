//
//  NoticeCell.m
//  ZHRQ_CBZ
//
//  Created by Mr Lai on 2017/7/1.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import "NoticeCell.h"
#import "Notice.h"

@interface NoticeCell ()
@property (weak, nonatomic) IBOutlet UILabel *arrowLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation NoticeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
}

- (void)setupUI {
    self.arrowLabel.font = IconFont(15);
    self.arrowLabel.text = RightArrowIconUnicode;
}

- (void)setNotice:(Notice *)notice {
    _notice = notice;
    self.timeLabel.text = [NSString stringFromTimestampFromat:notice.add_time formatter:FmtYMDHM];
    self.titleTextLabel.text = notice.title;
}

@end
