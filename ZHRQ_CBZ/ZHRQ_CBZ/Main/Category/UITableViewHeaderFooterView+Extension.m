//
//  UITableViewHeaderFooterView+Extension.m
//
//  Created by Mr Lai on 2017/7/5.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import "UITableViewHeaderFooterView+Extension.h"

@implementation UITableViewHeaderFooterView (Extension)
+ (instancetype)headerViewFromXibWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"header";
    id header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    if (header == nil) {
        header = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
    }
    return header;
}

@end
