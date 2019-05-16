//
//  UITableViewCell+Extension.m
//
//  Created by Mr Lai on 2017/5/17.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import "UITableViewCell+Extension.h"

@implementation UITableViewCell (Extension)
+ (instancetype)cellFromXibWithTableView:(UITableView *)tableView {
    NSString *ID = NSStringFromClass(self);
    id cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
    }
    return cell;
}

+ (void)creatAnimationWithCell:(UITableViewCell *)cell {
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DRotate(transform, 0, 0, 0, 1);//渐变
    //    transform = CATransform3DTranslate(transform, -200, 0, 0);//左边水平移动
    transform = CATransform3DScale(transform, 0, 0, 0);//由小变大
    cell.layer.transform = transform;
    cell.layer.opacity = 0.0;
    [UIView animateWithDuration:KeyboradDuration animations:^{
        cell.layer.transform = CATransform3DIdentity;
        cell.layer.opacity = 1;
    }];
}

@end
