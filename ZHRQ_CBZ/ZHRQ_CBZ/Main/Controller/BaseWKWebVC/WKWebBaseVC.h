//
//  WKWebBaseVC.h
//
//  Created by Mr Lai on 2017/6/2.
//  Copyright © 2017年 XMB. All rights reserved.
//

#import "BaseViewController.h"

typedef enum : NSUInteger {
    WebDataTypeUrl = 0,
    WebDataTypeHtml
} WebDataType;

@class WKWebView;
@interface WKWebBaseVC : BaseViewController
@property (nonatomic, copy) NSString *url;
@property (nonatomic, assign, readonly) WebDataType webDataType;
- (void)setupParams:(NSMutableDictionary *)params;
- (void)reloadWebView;
- (NSString *)setupUrl;
@end
