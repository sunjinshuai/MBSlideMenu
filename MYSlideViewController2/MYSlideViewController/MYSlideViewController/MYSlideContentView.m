//
//  MYSlideContentView.m
//  MYSlideViewController
//
//  Created by Michael on 2017/6/26.
//  Copyright © 2017年 Michael. All rights reserved.
//

#import "MYSlideContentView.h"
#import "MYSlideBarView.h"
#import "Constant.h"

@interface MYSlideContentView ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource,UIScrollViewDelegate,MYSlideBarViewDelegate>

@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) MYSlideBarView *slideBar;

@end

@implementation MYSlideContentView

- (instancetype)initWithFrame:(CGRect)frame Titles:(NSArray<NSString *>*)titles viewControllers:(NSArray<UIViewController *>*)viewControllers{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        self.titles = titles;
        self.viewControllers = viewControllers;
    }
    return self;
}

- (void)setupUI {
    
    _slideBar = [[MYSlideBarView alloc] init];
    _slideBar.delegate = self;
    [self addSubview:_slideBar];
    
    // 添加分页滚动视图控制器
    _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    _pageViewController.delegate = self;
    _pageViewController.dataSource = self;
    [self addSubview:_pageViewController.view];
    
    for (UIScrollView *scrollView in _pageViewController.view.subviews) {
        if ([scrollView isKindOfClass:[UIScrollView class]]) {
            scrollView.delegate = self;
        }
    }
}

#pragma mark -
#pragma mark UIPageViewControllerDelegate&DataSource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    UIViewController *vc;
    if (_selectedIndex + 1 < _viewControllers.count) {
        vc = _viewControllers[_selectedIndex + 1];
        vc.view.bounds = pageViewController.view.bounds;
    }
    return vc;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    UIViewController *vc;
    if (_selectedIndex - 1 >= 0) {
        vc = _viewControllers[_selectedIndex - 1];
        vc.view.bounds = pageViewController.view.bounds;
    }
    return vc;
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    _selectedIndex = [_viewControllers indexOfObject:pageViewController.viewControllers.firstObject];
    _slideBar.selectedIndex = _selectedIndex;
    [self performSwitchDelegateMethod];
}

#pragma mark -
#pragma mark ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.x == scrollView.bounds.size.width) {
        return;
    }
    CGFloat progress = scrollView.contentOffset.x/scrollView.bounds.size.width;
    _slideBar.progress = progress;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    _slideBar.ignoreAnimation = false;
}

- (void)showInViewController:(UIViewController *)viewController {
    [viewController addChildViewController:_pageViewController];
    [viewController.view addSubview:self];
}

- (void)showInNavigationController:(UINavigationController *)navigationController {
    [navigationController.topViewController.view addSubview:self];
    [navigationController.topViewController addChildViewController:_pageViewController];
    navigationController.topViewController.navigationItem.titleView = _slideBar;
    _pageViewController.view.frame = self.bounds;
    _slideBar.backgroundColor = [UIColor clearColor];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    [self switchToIndex:_selectedIndex];
}

#pragma mark -
#pragma mark Setter&Getter
- (void)setViewControllers:(NSArray *)viewControllers {
    _viewControllers = viewControllers;
}

- (void)setTitles:(NSArray *)titles {
    _titles = titles;
    _slideBar.titles = titles;
}

- (void)setItemSelectedColor:(UIColor *)itemSelectedColor {
    _slideBar.itemSelectedColor = itemSelectedColor;
}

- (void)setItemNormalColor:(UIColor *)itemNormalColor {
    _slideBar.itemNormalColor = itemNormalColor;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    _slideBar.selectedIndex = _selectedIndex;
    [self switchToIndex:_selectedIndex];
}

- (void)setHideShadow:(BOOL)hideShadow {
    _hideShadow = hideShadow;
    _slideBar.hideShadow = _hideShadow;
}

- (void)setItemMargin:(CGFloat)itemMargin {
    _itemMargin = itemMargin;
    _slideBar.itemMargin = itemMargin;
}

- (void)setSlideBarFrame:(CGRect)slideBarFrame {
    _slideBarFrame = slideBarFrame;
    _slideBar.frame = slideBarFrame;
    _pageViewController.view.frame = CGRectMake(0, CGRectGetMaxY(slideBarFrame), FXScreenWidth, FXScreenHeight - 40);
    _slideBar.slideBarFrame = slideBarFrame;
}

#pragma mark -
#pragma mark SlideSegmentDelegate
- (void)slideBarSelectedAtIndex:(NSInteger)index {
    if (index == _selectedIndex) {
        return;
    }
    [self switchToIndex:index];
}

#pragma mark -
#pragma mark 其他方法
- (void)switchToIndex:(NSInteger)index {
    WS(weakSelf)
    [_pageViewController setViewControllers:@[_viewControllers[index]] direction:index<_selectedIndex animated:YES completion:^(BOOL finished) {
        _selectedIndex = index;
        [weakSelf performSwitchDelegateMethod];
    }];
}

- (void)performSwitchDelegateMethod {
    if ([_delegate respondsToSelector:@selector(slideContentViewSelectAtIndex:)]) {
        [_delegate slideContentViewSelectAtIndex:_selectedIndex];
    }
}

@end
