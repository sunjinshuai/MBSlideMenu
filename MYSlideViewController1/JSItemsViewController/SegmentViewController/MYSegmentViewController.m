//
//  MYSegmentViewController.m
//  JSItemsViewController
//
//  Created by Michael on 2017/2/9.
//  Copyright © 2017年 com.51fanxing. All rights reserved.
//

#import "MYSegmentViewController.h"
#import "MYSegmentBarItem.h"
#import "UIColor+Extension.h"

#define INDICATOR_HEIGHT 2

@interface MYSegmentViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate>

@property (nonatomic, strong, readwrite) UICollectionView *segmentBar;
@property (nonatomic, strong, readwrite) UIScrollView *slideView;
@property (nonatomic, assign, readwrite) NSInteger selectedIndex;
@property (nonatomic, strong, readwrite) UIView *indicator;
@property (nonatomic, strong) UIView *indicatorBgView;
@property (nonatomic, strong) UICollectionViewFlowLayout *segmentBarLayout;

@end

@implementation MYSegmentViewController

@synthesize viewControllers = _viewControllers;

static NSString * const segmentBarItemID = @"MYSegmentBarItem";

- (instancetype)initWithViewControllers:(NSArray *)viewControllers
{
    self = [super init];
    if (self) {
        _viewControllers = [viewControllers copy];
        _selectedIndex = NSNotFound;
        self.segmentBarBackgroundColor = [UIColor whiteColor];
        self.segmentBarHeight = 45;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupSubviews];
    [self reset];
    CGSize conentSize = CGSizeMake(self.view.frame.size.width * self.viewControllers.count, 0);
    [self.slideView setContentSize:conentSize];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark - Setup
- (void)setupSubviews
{

    if (self.freedomSegmentBar) {
        self.freedomSegmentBar.frame = self.segmentBar.frame;
        [self.view addSubview:self.freedomSegmentBar];
        [self.view addSubview:self.slideView];
    } else {
        if (self.segmentBarBackgroundColorImage) {
            UIImageView *segmentBarBackgroundView = [[UIImageView alloc] initWithImage:self.segmentBarBackgroundColorImage];
            segmentBarBackgroundView.frame = self.segmentBar.frame;
            segmentBarBackgroundView.userInteractionEnabled = true;
            
            [self.view addSubview:segmentBarBackgroundView];
        }
        
        [self.view addSubview:self.segmentBar];
        [self.view addSubview:self.slideView];
        [self.segmentBar registerClass:[MYSegmentBarItem class] forCellWithReuseIdentifier:segmentBarItemID];
        [self.segmentBar addSubview:self.indicatorBgView];
    }
}

- (void)setSegmentBarBackgroundColorImage:(UIImage *)segmentBarBackgroundColorImage {
    _segmentBarBackgroundColorImage = segmentBarBackgroundColorImage;
    self.segmentBarBackgroundColor = [UIColor clearColor];
    _segmentBarBackgroundColorImage = [_segmentBarBackgroundColorImage stretchableImageWithLeftCapWidth:_segmentBarBackgroundColorImage.size.width / 2 topCapHeight:_segmentBarBackgroundColorImage.size.height / 2];
}

- (void)setIndicatorInsets:(UIEdgeInsets)indicatorInsets
{
    _indicatorInsets = indicatorInsets;
    CGRect frame = _indicator.frame;
    frame.origin.x = _indicatorInsets.left;
    CGFloat width = self.view.frame.size.width / self.viewControllers.count - _indicatorInsets.left - _indicatorInsets.right;
    frame.size.width = width;
    frame.size.height = INDICATOR_HEIGHT;
    _indicator.frame = frame;
}

- (void)setSelectedIndex:(NSInteger)selectedIndex
{
    if (_selectedIndex == selectedIndex) {
        return;
    }
    NSParameterAssert(selectedIndex >= 0 && selectedIndex < self.viewControllers.count);
    
    UIViewController *toSelectController = [self.viewControllers objectAtIndex:selectedIndex];
    
    // Add selected view controller as child view controller
    if (!toSelectController.parentViewController) {
        [self addChildViewController:toSelectController];
        CGRect rect = self.slideView.bounds;
        rect.origin.x = rect.size.width * selectedIndex;
        toSelectController.view.frame = rect;
        [self.slideView addSubview:toSelectController.view];
        [toSelectController didMoveToParentViewController:self];
    }
    _selectedIndex = selectedIndex;
}

- (void)setViewControllers:(NSArray *)viewControllers
{
    // Need remove previous viewControllers
    for (UIViewController *vc in _viewControllers) {
        [vc removeFromParentViewController];
    }
    _viewControllers = [viewControllers copy];
    [self reset];
}

- (NSArray *)viewControllers
{
    return [_viewControllers copy];
}

- (UIViewController *)selectedViewController
{
    return self.viewControllers[self.selectedIndex];
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if ([_dataSource respondsToSelector:@selector(numberOfSectionsInSegmentView:)]) {
        return [_dataSource numberOfSectionsInSegmentView:collectionView];
    }
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([_dataSource respondsToSelector:@selector(segmentView:numberOfItemsInSection:)]) {
        return [_dataSource segmentView:collectionView numberOfItemsInSection:section];
    }
    return self.viewControllers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([_dataSource respondsToSelector:@selector(segmentView:cellForItemAtIndexPath:)]) {
        return [_dataSource segmentView:collectionView cellForItemAtIndexPath:indexPath];
    }
    MYSegmentBarItem *segmentBarItem = [collectionView dequeueReusableCellWithReuseIdentifier:segmentBarItemID
                                                                                 forIndexPath:indexPath];
    segmentBarItem.tag = 250 + indexPath.row;
    UIViewController *vc = self.viewControllers[indexPath.row];
    segmentBarItem.titleLabel.text = vc.title;
    if (indexPath.row == 0) {
        segmentBarItem.titleLabel.textColor = self.segmentBarSelectedTitleColor;
    }
    return segmentBarItem;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < 0 || indexPath.row >= self.viewControllers.count) {
        return;
    }
    
    MYSegmentBarItem *item = (MYSegmentBarItem *)[collectionView cellForItemAtIndexPath:indexPath];
    item.titleLabel.textColor = self.segmentBarSelectedTitleColor;
    UIViewController *vc = self.viewControllers[indexPath.row];
    if ([_delegate respondsToSelector:@selector(segmentView:didSelectedViewController:)]) {
        [_delegate segmentView:collectionView didSelectedViewController:vc];
    }
    
    [self setSelectedIndex:indexPath.row];
    [self scrollToViewWithIndex:self.selectedIndex animated:NO];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < 0 || indexPath.row >= self.viewControllers.count) {
        return NO;
    }
    
    BOOL flag = YES;
    UIViewController *vc = self.viewControllers[indexPath.row];
    if ([_delegate respondsToSelector:@selector(segmentView:shouldSelectViewController:)]) {
        flag = [_delegate segmentView:collectionView shouldSelectViewController:vc];
    }
    return flag;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.slideView) {
        if ([self.delegate respondsToSelector:@selector(slideViewDidScroll:)]) {
            [self.delegate slideViewDidScroll:scrollView];
        }
        // set indicator frame
        CGRect frame = self.indicatorBgView.frame;
        CGFloat percent = scrollView.contentOffset.x / scrollView.contentSize.width;
        frame.origin.x = scrollView.frame.size.width * percent;
        [UIView animateWithDuration:0.2f animations:^{
            self.indicatorBgView.frame = frame;
        }];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView == self.slideView) {
        if (decelerate == NO) {
            [self handleScrollChangeVC:scrollView];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.slideView) {
        [self handleScrollChangeVC:scrollView];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(scrollerToIndexViewController:)]) {
        [_delegate scrollerToIndexViewController:self.selectedIndex];
    }
}

- (void)handleScrollChangeVC:(UIScrollView*)scrollView
{
    CGFloat percent = scrollView.contentOffset.x / scrollView.contentSize.width;
    NSInteger index = ceilf(percent * self.viewControllers.count);
    if (index >= 0 && index < self.viewControllers.count) {
        [self setSelectedIndex:index];
        for (int i = 0; i  < self.viewControllers.count; i ++) {
            MYSegmentBarItem *segmentBarItemThird = (MYSegmentBarItem *)[self.view viewWithTag:250 + i];
            segmentBarItemThird.titleLabel.textColor = self.segmentBarTitleColor;
            if (i == index) {
                segmentBarItemThird.titleLabel.textColor = self.segmentBarSelectedTitleColor;
            }
        }
    }
}

#pragma mark - Action
- (void)scrollToViewWithIndex:(NSInteger)index animated:(BOOL)animated
{
    CGRect rect = self.slideView.bounds;
    rect.origin.x = rect.size.width * index;
    for (int i = 0; i  < self.viewControllers.count; i ++) {
        MYSegmentBarItem *segmentBarItemThird = (MYSegmentBarItem *)[self.view viewWithTag:250 + i];
        segmentBarItemThird.titleLabel.textColor = self.segmentBarTitleColor;
        if (i == index) {
            segmentBarItemThird.titleLabel.textColor = self.segmentBarSelectedTitleColor;
        }
    }
    [self setSelectedIndex:index];
    [self.slideView setContentOffset:CGPointMake(rect.origin.x, rect.origin.y) animated:animated];
    if (_delegate && [_delegate respondsToSelector:@selector(scrollerToIndexViewController:)]) {
        [_delegate scrollerToIndexViewController:self.selectedIndex];
    }
}

- (void)reset
{
    _selectedIndex = NSNotFound;
    [self setSelectedIndex:0];
    [self scrollToViewWithIndex:0 animated:NO];
    [self.segmentBar reloadData];
}

#pragma mark - Property
- (UIScrollView *)slideView
{
    if (!_slideView) {
        CGRect frame = self.view.bounds;
        frame.size.height -= _segmentBar.frame.size.height;
        frame.origin.y = CGRectGetMaxY(_segmentBar.frame);
        _slideView = [[UIScrollView alloc] initWithFrame:frame];
        [_slideView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth
                                         | UIViewAutoresizingFlexibleHeight)];
        [_slideView setShowsHorizontalScrollIndicator:NO];
        [_slideView setShowsVerticalScrollIndicator:NO];
        [_slideView setPagingEnabled:YES];
        [_slideView setBounces:NO];
        [_slideView setDelegate:self];
        _slideView.scrollsToTop = NO;
    }
    return _slideView;
}

- (UICollectionView *)segmentBar
{
    if (!_segmentBar) {
        CGRect frame = self.view.bounds;
        frame.size.height = self.segmentBarHeight;
        _segmentBar = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:self.segmentBarLayout];
        _segmentBar.backgroundColor = self.segmentBarBackgroundColor;
        _segmentBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _segmentBar.delegate = self;
        _segmentBar.dataSource = self;
        CGFloat separatorHeight = 0.5;
        if ([[UIDevice currentDevice].systemVersion doubleValue] < 8.0f) {
            separatorHeight = 1;
        }
        
        UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height - separatorHeight, frame.size.width, separatorHeight)];
        [separator setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin];
        [separator setBackgroundColor:[UIColor colorWithHexString:@"#e6e6e6"]];
        [_segmentBar addSubview:separator];
    }
    return _segmentBar;
}

- (UIView *)indicatorBgView
{
    if (!_indicatorBgView) {
        CGRect frame = CGRectMake(0, self.segmentBar.frame.size.height - INDICATOR_HEIGHT - 0.5,
                                  self.view.frame.size.width / self.viewControllers.count, INDICATOR_HEIGHT);
        _indicatorBgView = [[UIView alloc] initWithFrame:frame];
        _indicatorBgView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        _indicatorBgView.backgroundColor = [UIColor clearColor];
        [_indicatorBgView addSubview:self.indicator];
    }
    return _indicatorBgView;
}

- (UIView *)indicator
{
    if (!_indicator) {
        CGFloat width = self.view.frame.size.width / self.viewControllers.count;
        CGRect frame = CGRectMake(self.indicatorInsets.left, 0, width, INDICATOR_HEIGHT);
        _indicator = [[UIView alloc] initWithFrame:frame];
        _indicator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        _indicator.backgroundColor = self.indicatorColor;
    }
    return _indicator;
}


- (UICollectionViewFlowLayout *)segmentBarLayout
{
    if (!_segmentBarLayout) {
        _segmentBarLayout = [[UICollectionViewFlowLayout alloc] init];
        _segmentBarLayout.itemSize = CGSizeMake(self.view.frame.size.width / self.viewControllers.count, self.segmentBarHeight);
        _segmentBarLayout.sectionInset = UIEdgeInsetsZero;
        _segmentBarLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _segmentBarLayout.minimumLineSpacing = 0;
        _segmentBarLayout.minimumInteritemSpacing = 0;
    }
    return _segmentBarLayout;
}


- (UIColor *)segmentBarTitleColor {
    if (!_segmentBarTitleColor) {
        _segmentBarTitleColor = [UIColor colorWithHexString:@"7f7f7f"];
    }
    return _segmentBarTitleColor;
}

- (UIColor *)segmentBarSelectedTitleColor {
    if (!_segmentBarSelectedTitleColor) {
        _segmentBarSelectedTitleColor = [UIColor colorWithHexString:@"262626"];
    }
    return _segmentBarSelectedTitleColor;
}

- (UIColor *)indicatorColor {
    if (!_indicatorColor) {
        _indicatorColor = [UIColor colorWithHexString:@"#fa4b9b"];
    }
    return _indicatorColor;
}

@end
