//
//  MYSegmentViewController.m
//  JSItemsViewController
//
//  Created by Michael on 2017/2/9.
//  Copyright © 2017年 com.51fanxing. All rights reserved.
//

#import "MYSlideViewController.h"
#import "MYSlideSegmentBarItem.h"
#import "NSString+Extension.h"

#define INDICATOR_HEIGHT 1.5

static NSString * const slideSegmentBarItemID = @"MYSegmentBarItem";

@interface MYSlideViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>

@property (nonatomic, strong, readwrite) UICollectionView *segmentBar;
@property (nonatomic, strong, readwrite) UIScrollView *slideView;
@property (nonatomic, strong, readwrite) UIView *indicator;
@property (nonatomic, strong) UIView *indicatorBgView;

@property (nonatomic, strong) UICollectionViewFlowLayout *segmentBarLayout;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, assign) CGFloat postion;

@property (nonatomic, assign, readwrite) NSInteger presentViewIndex;

@property (nonatomic, assign, getter=isAnimated) BOOL animated;

@property (nonatomic, strong) UIView *scrollViewFirstPage;
@property (nonatomic, strong) UIView *scrollViewMiddlePage;
@property (nonatomic, strong) UIView *scrollViewLastPage;

@property (nonatomic, assign, getter=isDragging) BOOL dragging;
@property (nonatomic, assign, getter=isAdjusting) BOOL adjusting;

@property (nonatomic, strong) UIView *presentView;
@property (nonatomic, strong) UIView *previousView;
@property (nonatomic, strong) UIView *nextView;

@property (nonatomic, assign) CGPoint beginScrollPoint;

@property (nonatomic, assign) CGFloat beginPositionX;

@property (nonatomic, strong) NSMutableArray *indicatorBgFrames;

@end

@implementation MYSlideViewController

@synthesize viewControllers = _viewControllers;

- (instancetype)initWithViewControllers:(NSArray *)viewControllers
{
    self = [super init];
    if (self) {
        _viewControllers = [viewControllers copy];
        _segmentBarType = MYSegmentBarTypeDynamicWidth;
        _segmentBarHeight = 45.0f;
        _segmentBarWidth = [UIScreen mainScreen].bounds.size.width;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupSubviews];
    [self reset];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

#pragma mark - Setup
- (void)setupSubviews
{
    if (self.segmentBarType != MYSegmentBarTypeDynamicWidth) {
        self.indicatorInsets = UIEdgeInsetsZero;
    }

    [self.view addSubview:self.slideView];
    
    if (!self.hideSegmentBar) {
        [self.view addSubview:self.segmentBar];
        [self.view addSubview:self.lineView];
    }
    
}

#pragma mark - UICollectionViewDataSource and UICollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.viewControllers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MYSlideSegmentBarItem *segmentBarItem = [collectionView dequeueReusableCellWithReuseIdentifier:slideSegmentBarItemID forIndexPath:indexPath];
    UIViewController *vc = [self.viewControllers objectAtIndex:indexPath.row];
    segmentBarItem.titleLabel.text = vc.title;
    return segmentBarItem;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < 0 || indexPath.row >= self.viewControllers.count) {
        return;
    }
    
    [self scrollToViewIndex:indexPath.row animated:YES];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < 0 || indexPath.row >= self.viewControllers.count) {
        return NO;
    }
    
    BOOL flag = YES;
    if ([_delegate respondsToSelector:@selector(slideViewController:shouldSelectViewIndex:)]) {
        flag = [_delegate slideViewController:self shouldSelectViewIndex:indexPath.row];
    }
    
    if (self.isAnimated) {
        flag = NO;
    }
    return flag;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = collectionView.frame.size.height;
    CGFloat width = 0;
    CGRect bgFrame = CGRectFromString(self.indicatorBgFrames[indexPath.row]);
    width = bgFrame.size.width;
    return CGSizeMake(width, height);
}

#pragma mark - new private methods
- (void)reset
{
    [self.scrollViewFirstPage removeFromSuperview];
    [self.scrollViewMiddlePage removeFromSuperview];
    [self.scrollViewLastPage removeFromSuperview];
    self.scrollViewFirstPage = nil;
    self.scrollViewMiddlePage = nil;
    self.scrollViewLastPage = nil;
    self.indicatorBgFrames = nil;
    
    if (self.indicatorBgFrames.count > 0) {
        self.indicatorBgView.frame = CGRectFromString(self.indicatorBgFrames[0]);
        self.indicator.frame = CGRectMake(self.indicatorInsets.left, 0, self.indicatorBgView.bounds.size.width - self.indicatorInsets.left - self.indicatorInsets.right, INDICATOR_HEIGHT);
    }
    
    if (self.viewControllers.count >= 3) {
        CGSize conentSize = CGSizeMake(self.view.frame.size.width * 3, 0);
        [_slideView setContentSize:conentSize];
        _slideView.scrollEnabled = YES;
        [_slideView addSubview:self.scrollViewFirstPage];
        [_slideView addSubview:self.scrollViewMiddlePage];
        [_slideView addSubview:self.scrollViewLastPage];
    } else if (self.viewControllers.count == 1) {
        CGSize conentSize = CGSizeMake(self.view.frame.size.width, 0);
        [_slideView setContentSize:conentSize];
        _slideView.scrollEnabled = NO;
        [_slideView addSubview:self.scrollViewFirstPage];
    } else if (self.viewControllers.count == 2) {
        CGSize conentSize = CGSizeMake(self.view.frame.size.width * 2, 0);
        [_slideView setContentSize:conentSize];
        _slideView.scrollEnabled = YES;
        [_slideView addSubview:self.scrollViewFirstPage];
        [_slideView addSubview:self.scrollViewMiddlePage];
    } else {
        CGSize contentSize = CGSizeMake(self.view.frame.size.width, 0);
        [_slideView setContentSize:contentSize];
    }
    
    self.presentViewIndex = -1;
    [self.segmentBar reloadData];
    [self scrollToViewIndex:0 animated:NO];
}

- (void)scrollToViewIndex:(NSInteger)index animated:(BOOL)animated
{
    if (index == self.presentViewIndex || self.isAnimated || self.viewControllers.count == 0) {
        return;
    }
    
    CGFloat duration = animated ? 0.3f : 0;
    UIViewController *destinationViewController = self.viewControllers[index];
    
    if (self.viewControllers.count == 2) {
        CGPoint offset = CGPointMake(index * self.slideView.bounds.size.width, 0);
        [UIView animateWithDuration:duration animations:^{
            [self.slideView setContentOffset:offset];
            self.animated = YES;
        } completion:^(BOOL finished) {
            if (!destinationViewController.parentViewController) {
                [self addChildViewController:destinationViewController];
            }
            
            self.presentViewIndex = index;

            [self adjustScrollView];
            
            [self.segmentBar selectItemAtIndexPath:[NSIndexPath indexPathForRow:self.presentViewIndex inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
            
            
            self.adjusting = NO;
            self.animated = NO;
        }];
    } else {
        NSInteger placeIndex = index > self.presentViewIndex ? 1 : -1;
        
        CGRect rect = self.slideView.bounds;
        rect.origin.x = 0;
        destinationViewController.view.frame = rect;
        
        if (destinationViewController.parentViewController) {
            if (self.presentViewIndex == 0 || self.presentViewIndex == self.viewControllers.count - 1) {
                [self.scrollViewMiddlePage addSubview:destinationViewController.view];
            } else if (placeIndex > 0) {
                [self.scrollViewLastPage addSubview:destinationViewController.view];
            } else {
                [self.scrollViewFirstPage addSubview:destinationViewController.view];
            }
        }
        
        self.adjusting = YES;
        [UIView animateWithDuration:duration animations:^{
            if (self.presentViewIndex >= 0) {
                [self.slideView setContentOffset:CGPointMake(self.slideView.contentOffset.x + placeIndex * self.slideView.bounds.size.width, 0)];
            }
            self.animated = YES;
            
            self.indicatorBgView.frame = CGRectFromString(self.indicatorBgFrames[index]);
            
            CGRect indicatorFrame = self.indicator.frame;
            indicatorFrame.size.width = self.indicatorBgView.frame.size.width - self.indicatorInsets.left - self.indicatorInsets.right;
            indicatorFrame.origin.x = self.indicatorInsets.left;
            self.indicator.frame = indicatorFrame;
            
        } completion:^(BOOL finished) {
            if (!destinationViewController.parentViewController) {
                [self addChildViewController:destinationViewController];
            }
            
            self.presentViewIndex = index;
            
            [self adjustScrollView];
            
            [self.segmentBar selectItemAtIndexPath:[NSIndexPath indexPathForRow:self.presentViewIndex inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
            
            self.adjusting = NO;
            self.animated = NO;
        }];
    }
    
    if ([_delegate respondsToSelector:@selector(slideViewController:didSelectViewIndex:)]) {
        [_delegate slideViewController:self didSelectViewIndex:index];
    }
    
}

- (void)adjustScrollView
{
    if (self.viewControllers.count >= 3) {
        CGPoint offset = CGPointZero;
        if (self.presentViewIndex == 0) {
            offset.x = 0;
        } else if (self.presentViewIndex == self.viewControllers.count - 1) {
            offset.x = self.slideView.bounds.size.width * (self.viewControllers.count >= 3 ? 2 : 1);
        } else {
            offset.x = self.slideView.bounds.size.width;
        }
        
        self.adjusting = YES;
        
        [self.slideView setContentOffset:offset];
        
        self.beginScrollPoint = self.slideView.contentOffset;
        
        self.adjusting = NO;
    }
}

- (void)loadViewOnSlideView
{
    [self setPresentViewIndex:self.presentViewIndex];
    [self adjustScrollView];
    [self reloadScrollView];
}

- (void)reloadScrollView
{
    if (self.viewControllers.count >= 3) {
        if (self.presentViewIndex == 0) {
            [self.scrollViewFirstPage.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [self.scrollViewFirstPage addSubview:self.presentView];
            [self.scrollViewMiddlePage.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [self.scrollViewMiddlePage addSubview:self.nextView];
        } else if (self.presentViewIndex == self.viewControllers.count - 1) {
            [self.scrollViewLastPage.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [self.scrollViewLastPage addSubview:self.presentView];
            
            [self.scrollViewMiddlePage.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [self.scrollViewMiddlePage addSubview:self.previousView];
        } else {
            [self.scrollViewFirstPage.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [self.scrollViewFirstPage addSubview:self.previousView];
            
            [self.scrollViewLastPage.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [self.scrollViewLastPage addSubview:self.nextView];
            
            [self.scrollViewMiddlePage.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [self.scrollViewMiddlePage addSubview:self.presentView];
        }
    } else if (self.viewControllers.count == 1) {
        [self.scrollViewFirstPage.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [self.scrollViewFirstPage addSubview:self.presentView];
    } else if (self.viewControllers.count == 2) {
        if (self.presentViewIndex == 0) {
            [self.scrollViewFirstPage.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [self.scrollViewFirstPage addSubview:self.presentView];
            [self.scrollViewMiddlePage.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [self.scrollViewMiddlePage addSubview:self.nextView];
        } else if (self.presentViewIndex == 1) {
            [self.scrollViewMiddlePage.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [self.scrollViewMiddlePage addSubview:self.presentView];
            
            [self.scrollViewFirstPage.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [self.scrollViewFirstPage addSubview:self.previousView];
        }
    }
    
}

- (void)adjustIndicatorBgViewWithDestinationIndex:(NSInteger)destinationIndex percent:(CGFloat)percent
{
    if (destinationIndex < 0 || destinationIndex >= self.viewControllers.count) {
        return;
    }
    
    NSInteger presentIndex = self.presentViewIndex < 0 ? 0 : self.presentViewIndex;
    
    CGRect presentFrame = CGRectFromString([self.indicatorBgFrames objectAtIndex:presentIndex]);
    CGRect destinationFrame = CGRectFromString([self.indicatorBgFrames objectAtIndex:destinationIndex]);
    
    CGFloat distance = destinationFrame.origin.x - presentFrame.origin.x;
    
    CGFloat offsetX = distance * percent;
    
    CGRect bgFrame = self.indicatorBgView.frame;
    bgFrame.origin.x = presentFrame.origin.x + offsetX;
    
    CGFloat widthDistance = destinationFrame.size.width - presentFrame.size.width;
    bgFrame.size.width = presentFrame.size.width + widthDistance * percent;
    
    self.indicatorBgView.frame = bgFrame;
    
    CGRect indicatorFrame = self.indicator.frame;
    indicatorFrame.size.width = self.indicatorBgView.frame.size.width - self.indicatorInsets.left - self.indicatorInsets.right;
    indicatorFrame.origin.x = self.indicatorInsets.left;
    self.indicator.frame = indicatorFrame;
    
    
    UIColor *destinationColor = [UIColor colorWithRed:(26.0f + (250.0f - 26.0f) * percent) / 255.0f
                                                green:(26.0f + (75.0f - 26.0f) * percent) / 255.0
                                                blue:(26.0f + (155.0f - 26.0f) * percent) / 255.0f
                                                alpha:1.0f];
    UIColor *presentColor = [UIColor colorWithRed:(250.0f - (250.0f - 26.0f) * percent) / 255.0f
                                                green:(75.0f - (75.0f - 26.0f) * percent) / 255.0
                                                 blue:(155.0f - (155.0f - 26.0f) * percent) / 255.0f
                                                alpha:1.0f];

    MYSlideSegmentBarItem *destinationItemCell = (MYSlideSegmentBarItem *)[self.segmentBar cellForItemAtIndexPath:[NSIndexPath indexPathForRow:destinationIndex inSection:0]];
    destinationItemCell.titleLabel.textColor = destinationColor;

    MYSlideSegmentBarItem *presentItemCell = (MYSlideSegmentBarItem *)[self.segmentBar cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.presentViewIndex inSection:0]];
    presentItemCell.titleLabel.textColor = presentColor;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.dragging = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == self.slideView) {
        [self.segmentBar selectItemAtIndexPath:[NSIndexPath indexPathForRow:self.presentViewIndex inSection:0] animated:YES scrollPosition:UICollectionViewScrollPositionCenteredHorizontally];
        if (self.presentViewIndex >= 0 && self.presentViewIndex < self.viewControllers.count) {
            UIViewController *destinationViewController = self.viewControllers[self.presentViewIndex];
            
            if (!destinationViewController.parentViewController) {
                [self addChildViewController:destinationViewController];
            }
            
            [self loadViewOnSlideView];
        }
        if ([_delegate respondsToSelector:@selector(slideViewController:didSelectViewIndex:)]) {
            [_delegate slideViewController:self didSelectViewIndex:self.presentViewIndex];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == self.slideView) {
        if (self.adjusting) {
            return;
        }
        CGFloat percent = fabs(self.beginScrollPoint.x - scrollView.contentOffset.x) / scrollView.bounds.size.width;
        if (percent > 1.0f) {
            self.beginScrollPoint = CGPointMake(scrollView.bounds.size.width, 0);
            percent = fabs(self.beginScrollPoint.x - scrollView.contentOffset.x) / scrollView.bounds.size.width;
            if (scrollView.contentOffset.x != self.beginScrollPoint.x) {
                if (self.presentViewIndex == 0) {
                    self.presentViewIndex++;
                } else if (self.presentViewIndex == self.viewControllers.count - 1) {
                    self.presentViewIndex--;
                }
            }
        }
        
        BOOL dragToRight = scrollView.contentOffset.x > self.beginScrollPoint.x ? YES : NO;
        
        NSInteger destinationIndex = dragToRight ? self.presentViewIndex + 1 : self.presentViewIndex - 1;
        
        if (destinationIndex >= 0 && destinationIndex < self.viewControllers.count) {
            
            [self adjustIndicatorBgViewWithDestinationIndex:destinationIndex percent:percent];
        }
        
        if (scrollView.contentOffset.x == 0) {
            if (scrollView.contentOffset.x < self.beginScrollPoint.x) {
                self.presentViewIndex-- ;
                [self adjustScrollView];
            }
            
            self.beginScrollPoint = scrollView.contentOffset;
        } else if (scrollView.contentOffset.x == scrollView.bounds.size.width) {
            if (scrollView.contentOffset.x != self.beginScrollPoint.x) {
                if (self.presentViewIndex == 0) {
                    self.presentViewIndex++;
                } else if (self.presentViewIndex == self.viewControllers.count - 1) {
                    self.presentViewIndex--;
                }
            }
            self.beginScrollPoint = scrollView.contentOffset;
        } else if (scrollView.contentOffset.x == scrollView.bounds.size.width * 2) {
            if (scrollView.contentOffset.x > self.beginScrollPoint.x) {
                self.presentViewIndex++ ;
                [self adjustScrollView];
            }
            
            self.beginScrollPoint = scrollView.contentOffset;
        }
    }
}

#pragma mark - getter and setter

- (UIView *)scrollViewFirstPage
{
    if (_scrollViewFirstPage == nil) {
        CGRect rect = self.slideView.bounds;
        rect.origin.x = 0;
        _scrollViewFirstPage = [[UIView alloc] initWithFrame:rect];

    }
    return _scrollViewFirstPage;
}

- (UIView *)scrollViewMiddlePage
{
    if (_scrollViewMiddlePage == nil) {
        CGRect rect = self.slideView.bounds;
        rect.origin.x = self.slideView.bounds.size.width;
        _scrollViewMiddlePage = [[UIView alloc] initWithFrame:rect];
    }
    return _scrollViewMiddlePage;
}

- (UIView *)scrollViewLastPage
{
    if (_scrollViewLastPage == nil) {
        CGRect rect = self.slideView.bounds;
        rect.origin.x = self.slideView.bounds.size.width * 2;
        _scrollViewLastPage = [[UIView alloc] initWithFrame:rect];
    }
    return _scrollViewLastPage;
}

- (void)setPresentViewIndex:(NSInteger)presentViewIndex
{
    _presentViewIndex = presentViewIndex;
    
    if (presentViewIndex < 0 && presentViewIndex >= self.viewControllers.count) {
        return;
    }
    
    UIView *presentView = nil;
    if (self.presentViewIndex >= 0 && self.presentViewIndex < self.viewControllers.count) {
        UIViewController *presentViewController = self.viewControllers[self.presentViewIndex];
        presentView = presentViewController.parentViewController ? presentViewController.view : nil;
    }
    _presentView = presentView;
    
    CGRect presentViewRect = self.slideView.bounds;
    presentViewRect.origin.x = 0;
    _presentView.frame = presentViewRect;
    
    
    NSInteger previousViewIndex = self.presentViewIndex - 1;
    UIView *previousView = nil;
    if (previousViewIndex >= 0 && previousViewIndex < self.viewControllers.count) {
        UIViewController *previousViewController = self.viewControllers[previousViewIndex];
        previousView = previousViewController.parentViewController ? previousViewController.view : nil;
    }
    _previousView = previousView;
    
    CGRect previousViewRect = self.slideView.bounds;
    previousViewRect.origin.x = 0;
    _previousView.frame = previousViewRect;
    
    
    NSInteger nextViewIndex = self.presentViewIndex + 1;
    UIView *nextView = nil;
    if (nextViewIndex >= 0 && nextViewIndex < self.viewControllers.count) {
        UIViewController *nextViewController = self.viewControllers[nextViewIndex];
        nextView = nextViewController.parentViewController ? nextViewController.view : nil;
    }
    _nextView = nextView;
    
    CGRect nextViewRect = self.slideView.bounds;
    nextViewRect.origin.x = 0;
    _nextView.frame = nextViewRect;
    
    [self reloadScrollView];
    
}

- (UIScrollView *)slideView
{
    if (!_slideView) {
        CGFloat height = 0;
        CGFloat y = 0;
        if (!self.hideSegmentBar) {
            height = self.view.bounds.size.height - self.segmentBarHeight;
            y = CGRectGetMaxY(self.segmentBar.frame);
        }
        CGRect frame = CGRectMake(0, y, self.view.bounds.size.width, height);
        _slideView = [[UIScrollView alloc] initWithFrame:frame];
        [_slideView setAutoresizingMask:(UIViewAutoresizingFlexibleWidth
                                         | UIViewAutoresizingFlexibleHeight)];
        [_slideView setShowsHorizontalScrollIndicator:NO];
        [_slideView setShowsVerticalScrollIndicator:NO];
        [_slideView setPagingEnabled:YES];
        [_slideView setBounces:NO];
        [_slideView setDelegate:self];
        [_slideView setBackgroundColor:[UIColor clearColor]];
        
        
    }
    return _slideView;
}

- (UICollectionView *)segmentBar
{
    if (!_segmentBar) {
        CGRect frame = CGRectMake(0, self.segmentBarY, self.segmentBarWidth, self.segmentBarHeight);
        _segmentBar = [[UICollectionView alloc] initWithFrame:frame collectionViewLayout:self.segmentBarLayout];
        if (self.hideSegmentBar) {
            _segmentBar.backgroundColor = [UIColor clearColor];
        } else {
            _segmentBar.backgroundColor = [UIColor whiteColor];
        }
        
        _segmentBar.delegate = self;
        _segmentBar.dataSource = self;
        _segmentBar.showsVerticalScrollIndicator = NO;
        _segmentBar.showsHorizontalScrollIndicator = NO;
        [_segmentBar registerClass:[MYSlideSegmentBarItem class] forCellWithReuseIdentifier:slideSegmentBarItemID];
        _segmentBar.clipsToBounds = YES;
        [_segmentBar addSubview:self.indicatorBgView];
    }
    return _segmentBar;
}

- (UIView *)indicatorBgView
{
    if (!_indicatorBgView) {
        CGRect frame = CGRectZero;
        _indicatorBgView = [[UIView alloc] initWithFrame:frame];
        _indicatorBgView.backgroundColor = [UIColor clearColor];
        [_indicatorBgView addSubview:self.indicator];
    }
    return _indicatorBgView;
}

- (UIView *)indicator
{
    if (!_indicator) {
        CGRect frame = CGRectZero;
        _indicator = [[UIView alloc] initWithFrame:frame];
        _indicator.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _indicator.backgroundColor = [UIColor colorWithHexString:@"#fa4b9b"];
    }
    return _indicator;
}

- (NSMutableArray *)indicatorBgFrames
{
    if (_indicatorBgFrames == nil) {
        _indicatorBgFrames = [NSMutableArray array];
        
        CGFloat height = INDICATOR_HEIGHT;
        CGFloat width = self.segmentBarWidth / self.viewControllers.count;
        CGFloat x = 0;
        CGFloat y = self.segmentBarHeight - (self.segmentBarHeight - [[UIFont systemFontOfSize:14] lineHeight]) / 2.0f + 5.0f;
        for (NSInteger i = 0; i < self.viewControllers.count; i++) {
            NSString *title = [self.viewControllers[i] title];
            if (self.segmentBarType == MYSegmentBarTypeDynamicWidth) {
                width = [title mySizeWithFont:[UIFont systemFontOfSize:16] maxSize:CGSizeMake(MAXFLOAT, [[UIFont systemFontOfSize:14] lineHeight]) lineBreakMode:NSLineBreakByWordWrapping].width + self.indicatorInsets.left + self.indicatorInsets.right;
            }
            x = CGRectGetMaxX(CGRectFromString(_indicatorBgFrames.lastObject));
            [_indicatorBgFrames addObject:NSStringFromCGRect(CGRectMake(x, y, width, height))];
        }
        
    }
    return _indicatorBgFrames;
}

- (UICollectionViewFlowLayout *)segmentBarLayout
{
    if (!_segmentBarLayout) {
        _segmentBarLayout = [[UICollectionViewFlowLayout alloc] init];
        _segmentBarLayout.sectionInset = UIEdgeInsetsZero;
        _segmentBarLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _segmentBarLayout.minimumLineSpacing = 0;
        _segmentBarLayout.minimumInteritemSpacing = 0;
    }
    return _segmentBarLayout;
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
    return self.viewControllers[self.presentViewIndex];
}

- (UIView *)lineView
{
    if (_lineView == nil) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [UIColor colorWithHexString:@"dcdcdf"];
        _lineView.frame = CGRectMake(0, self.segmentBarHeight - 0.5f, self.segmentBarWidth, 0.5f);
    }
    return _lineView;
}

@end
