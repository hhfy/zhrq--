//
//  TransferRecordCell.m
//  ZHRQ_CBZ
//
//  Created by Mr Lai on 2017/7/5.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import "TransferRecordCell.h"
#import "TransferRecord.h"

@interface TransferRecordCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *importCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *exportCountLabel;
@end


@implementation TransferRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setTransferRecord:(TransferRecord *)transferRecord {
    _transferRecord = transferRecord;
    self.nameLabel.text = transferRecord.company;
    self.importCountLabel.text = transferRecord.incount;
    self.exportCountLabel.text = transferRecord.outcount;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    if (self.highlighted) {
        POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewScaleXY];
        scaleAnimation.duration = 0.1;
        scaleAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)];
        scaleAnimation.beginTime = CACurrentMediaTime() + 0.01;
        [self.nameLabel pop_addAnimation:scaleAnimation forKey:@"scalingUp"];
    } else {
        POPSpringAnimation *sprintAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
        sprintAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)];
        sprintAnimation.velocity = [NSValue valueWithCGPoint:CGPointMake(15, 15)];
        sprintAnimation.springBounciness = 20.f;
        sprintAnimation.springSpeed = 30.f;
        sprintAnimation.beginTime = CACurrentMediaTime() + 0.01;
        [self.nameLabel pop_addAnimation:sprintAnimation forKey:@"springAnimation"];
    }
}

@end
