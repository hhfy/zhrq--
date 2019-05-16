//
//  BasePageVC.m
//  ZHRQ_CBZ
//
//  Created by Mr Lai on 2017/7/5.
//  Copyright © 2017年 Mr LAI. All rights reserved.
//

#import "BasePageVC.h"

@interface BasePageVC () <UIScrollViewDelegate>
@property (nonatomic, weak) UIView *titlesView;
@property (nonatomic, weak) UIView *titleBottomView;
@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *titleButtons;
@property (nonatomic, weak) UIButton *selectedTitleButton;
@property (nonatomic, weak) TitleButton *previousClickedTitleButton;
@end

@implementation BasePageVC


#pragma mark - 懒加载
- (NSMutableArray *)titleButtons {
    if (!_titleButtons) {
        _titleButtons = [NSMutableArray array];
    }
    return _titleButtons;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addChildVC];
    [self setupScrollView];
    [self setupTitlesView];
}

#pragma mark - 设置主题view
- (void)setupTitlesView {
    // 标签栏整体
    UIView *titlesView = [[UIView alloc] init];
    titlesView.height = Height44;
    titlesView.width = self.view.width;
    titlesView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    [self.view addSubview:titlesView];
    _titlesView = titlesView;
    // 标签栏内部的标签按钮
    NSUInteger count = self.childViewControllers.count;
    CGFloat titleButtonH = titlesView.height;
    CGFloat titleButtonW = titlesView.width / count;
    for (int i = 0; i < count; i++) {
        // 创建
        TitleButton *titleButton = [TitleButton buttonWithType:UIButtonTypeCustom];
        [titleButton addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [titlesView addSubview:titleButton];
        [self.titleButtons addObject:titleButton];
        // 文字
        NSString *title = self.childViewControllers[i].title;
        [titleButton setTitle:title forState:UIControlStateNormal];
        titleButton.tag = i;
        // frame
        titleButton.frame = CGRectMake(i*titleButtonW, 0, titleButtonW, titleButtonH);
    }
    
    // 标签栏底部的指示器控件
    UIView *titleBottomView = [[UIView alloc] init];
    titleBottomView.backgroundColor = [self.titleButtons.lastObject titleColorForState:UIControlStateSelected];
    titleBottomView.height = 2;
    titleBottomView.y = titlesView.height - titleBottomView.height - 2;
    [titlesView addSubview:titleBottomView];
    self.titleBottomView = titleBottomView;
    
    // 默认点击最前面的按钮
    TitleButton *firstTitleButton = self.titleButtons.firstObject;
    [firstTitleButton.titleLabel sizeToFit];
    titleBottomView.width = firstTitleButton.titleLabel.width;
    titleBottomView.centerX = firstTitleButton.centerX;
    [self titleClick:firstTitleButton];
}

#pragma mark - 设置ScrollView
- (void)setupScrollView {
    self.automaticallyAdjustsScrollViewInsets = NO;
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = self.view.bounds;
    scrollView.backgroundColor = SetupColor(235, 235, 235);
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    scrollView.scrollEnabled = YES;
    scrollView.contentSize = CGSizeMake(self.childViewControllers.count * self.view.width, 0);
    [self.view addSubview:scrollView];
    _scrollView = scrollView;
    // 默认显示第0个控制器
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

- (void)addChildVC {}

#pragma mark - 监听
- (void)titleClick:(TitleButton *)titleButton {
    // 重复点击了标题按钮 (顺序不要反了)
    if (self.previousClickedTitleButton == titleButton) {
        [[NSNotificationCenter defaultCenter] postNotificationName:TitleButtonDidRepeatClickNotification object:nil];
    }
    
    // 控制按钮状态
    self.selectedTitleButton.selected = NO;
    self.previousClickedTitleButton.selected = NO;
    titleButton.selected = YES;
    self.selectedTitleButton = titleButton;
    self.previousClickedTitleButton = titleButton;
    
    // 底部控件的位置和尺寸
    [UIView animateWithDuration:0.25 animations:^{
        self.titleBottomView.width = titleButton.titleLabel.width * 1.1;
        self.titleBottomView.centerX = titleButton.centerX;
    }];
    
    // 让scrollView滚动到对应的位置
    CGPoint offset = self.scrollView.contentOffset;
    offset.x = self.view.width * [self.titleButtons indexOfObject:titleButton];
    [self.scrollView setContentOffset:offset animated:YES];
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    // 取出对应的子控制器
    int index = scrollView.contentOffset.x / scrollView.width;
    UIViewController *willShowChildVc = self.childViewControllers[index];
    // 如果控制器的view已经被创建过，就直接返回
    if (willShowChildVc.isViewLoaded) return;
    // 添加子控制器的view到scrollView身上
    willShowChildVc.view.frame = scrollView.bounds;
    [scrollView addSubview:willShowChildVc.view];
}

/**
 * 当减速完毕的时候调用（人为拖拽scrollView，手松开后scrollView慢慢减速完毕到静止）
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self scrollViewDidEndScrollingAnimation:scrollView];
    // 点击按钮
    int index = scrollView.contentOffset.x / scrollView.width;
    [self titleClick:self.titleButtons[index]];
}

@end

/* 自定义按钮 */
@implementation TitleButton
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.font = TextSystemFont(13);
        [self setTitleColor:SetupColor(51, 51, 51) forState:UIControlStateNormal];
        [self setTitleColor:SetupColor(70, 159, 250) forState:UIControlStateSelected];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted {}
@end



