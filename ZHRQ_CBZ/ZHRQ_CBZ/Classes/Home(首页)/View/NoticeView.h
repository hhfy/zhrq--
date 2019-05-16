//
//  NoticeView.h
//  ZHRQ_CBZ
//
//  Created by Mr Lai on 2017/7/1.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NoticeView;
@protocol NoticeViewDelegate <NSObject>
@optional
- (void)didTapWithNoticeView:(NoticeView *)noticeView;
@end
@interface NoticeView : UIView
@property (nonatomic, weak) id<NoticeViewDelegate> delegate;
@property (nonatomic, strong) NSArray<NSString *> *texts;
- (void)shutDownTimer;
@end
