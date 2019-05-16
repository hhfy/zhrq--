//
//  UITableViewCell+Extension.h
//
//  Created by Mr Lai on 2017/5/17.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (Extension)
+ (instancetype)cellFromXibWithTableView:(UITableView *)tableView;
+ (void)creatAnimationWithCell:(UITableViewCell *)cell;
@end
