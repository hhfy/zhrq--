//
//  NoticeView.m
//  ZHRQ_CBZ
//
//  Created by Mr Lai on 2017/7/1.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import "NoticeView.h"

@interface NoticeView () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *iconLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *contentScrollView;
@property (weak, nonatomic) IBOutlet UILabel *arrowLabel;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation NoticeView

- (NSTimer *)timer
{
    if (_timer == nil)
    {
        _timer = [NSTimer timerWithTimeInterval:4 target:self selector:@selector(updateTimer) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    }
    return _timer;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    [self setupUI];
    [self setupTap];
}

- (void)setupUI {
    self.width = MainScreenSize.width;
    self.iconLabel.font = IconFont(20); 
    self.iconLabel.text = NoticeIconUnicode;
    self.arrowLabel.font = IconFont(15);
    self.arrowLabel.text = RightArrowIconUnicode;
}

- (void)setupContentScorllView {
    self.contentScrollView.contentSize = CGSizeMake(self.contentScrollView.width, self.texts.count * self.contentScrollView.height);
    
    for (int i = 0; i < self.texts.count; i++) {
        UILabel *text = [[UILabel alloc] init];
        text.y = self.contentScrollView.height * i;
        text.text = self.texts[i];
        text.textColor = SetupColor(157, 157, 157);
        text.font = TextSystemFont(13);
        text.width = self.contentScrollView.width;
        text.height = self.contentScrollView.height;
        [self.contentScrollView addSubview:text];
    }
}

- (void)setupTap {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self addGestureRecognizer:tap];
}

- (void)tap:(UITapGestureRecognizer *)tap {
    POPSpringAnimation *sprintAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
    sprintAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1.0, 1.0)];
    sprintAnimation.velocity = [NSValue valueWithCGPoint:CGPointMake(20, 20)];
    sprintAnimation.springSpeed = 20;
    sprintAnimation.springBounciness = 10.f;
    sprintAnimation.beginTime = CACurrentMediaTime() + 0.01;
    [self.iconLabel pop_addAnimation:sprintAnimation forKey:@"springAnimation"];
    
    WeakSelf(weakSelf)
    sprintAnimation.animationDidReachToValueBlock = ^(POPAnimation *anim) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((KeyboradDuration * 0.9) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([weakSelf.delegate respondsToSelector:@selector(didTapWithNoticeView:)]) {
                [weakSelf.delegate didTapWithNoticeView:weakSelf];
            }
        });
    };
}

- (void)setTexts:(NSArray *)texts {
    _texts = texts;
    [self setupContentScorllView];
    [self startTimer];
}

- (void)startTimer {
    [self timer];
}

- (void)shutDownTimer {
    [self.timer timeInterval];
    for (UIView *childView in self.contentScrollView.subviews) {
        if ([childView isKindOfClass:[UILabel class]]) {
            [childView removeFromSuperview];
        }
    }
}

- (void)updateTimer {
    NSInteger currentIndex = ((int)(self.contentScrollView.contentOffset.y / self.contentScrollView.height + 0.5)  + 1) % self.texts.count;
    CGFloat y = currentIndex * self.contentScrollView.height;
    [self.contentScrollView setContentOffset:CGPointMake(0, y) animated:YES];
    [LaiMethod animationWithView:self.iconLabel];
}


@end
