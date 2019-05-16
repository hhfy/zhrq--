//
//  PlacehoderTextView.h
//  41-新浪微博
//
//  Created by Mr Lai on 2017/1/4.
//  Copyright © 2017年 赖同学. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextView : UITextView
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, strong) UIColor *placeholderColor;
@end
