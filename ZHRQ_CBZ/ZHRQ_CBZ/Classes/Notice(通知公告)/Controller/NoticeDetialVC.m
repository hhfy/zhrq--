
//
//  NoticeDetialVC.m
//  ZHRQ_CBZ
//
//  Created by Mr Lai on 2017/7/6.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import "NoticeDetialVC.h"

@interface NoticeDetialVC ()

@end

@implementation NoticeDetialVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"公告详情";
}

- (WebDataType)webDataType {
    return WebDataTypeHtml;
}

- (NSString *)setupUrl {
    return [MainURL stringByAppendingPathComponent:@"store/detail"];
}

- (void)setupParams:(NSMutableDictionary *)params {
    params[@"sess_id"] = [SaveTool objectForKey:SessID];
    params[@"id"] = self.noticeId;
}

@end
