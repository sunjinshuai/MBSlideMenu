//
//  MYSegmentViewController.h
//  JSItemsViewController
//
//  Created by Michael on 2017/2/9.
//  Copyright © 2017年 com.51fanxing. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MYSegmentViewController;

@protocol MYSegmentViewDataSource <NSObject>

@required

- (NSInteger)segmentView:(UICollectionView *)segmentView numberOfItemsInSection:(NSInteger)section;

- (UICollectionViewCell *)segmentView:(UICollectionView *)segmentView cellForItemAtIndexPath:(NSIndexPath *)indexPath;

@optional

- (NSInteger)numberOfSectionsInSegmentView:(UICollectionView *)segmentView;

@end

@protocol MYSegmentViewDelegate <NSObject>

@optional

- (void)segmentView:(UICollectionView *)segmentView didSelectedViewController:(UIViewController *)viewController;

- (BOOL)segmentView:(UICollectionView *)segmentView shouldSelectViewController:(UIViewController *)viewController;

- (void)scrollerToIndexViewController:(NSInteger)index;

- (void)slideViewDidScroll:(UIScrollView *)scrollView;

@end

@interface MYSegmentViewController : UIViewController

@property (nonatomic, copy) NSArray *viewControllers;
@property (nonatomic, strong, readonly) UICollectionView *segmentBar;
@property (nonatomic, strong) UIView *freedomSegmentBar;
@property (nonatomic, assign) CGFloat segmentBarHeight;
@property (nonatomic, strong) UIColor *segmentBarTitleColor;
@property (nonatomic, strong) UIColor *segmentBarSelectedTitleColor;
@property (nonatomic, strong) UIColor *segmentBarBackgroundColor;
@property (nonatomic, strong) UIImage *segmentBarBackgroundColorImage;
@property (nonatomic, strong) UIColor *indicatorColor;
@property (nonatomic, strong, readonly) UIScrollView *slideView;
@property (nonatomic, strong, readonly) UIView *indicator;
@property (nonatomic, assign) UIEdgeInsets indicatorInsets;
@property (nonatomic, weak, readonly) UIViewController *selectedViewController;
@property (nonatomic, assign, readonly) NSInteger selectedIndex;
@property (nonatomic, assign) id <MYSegmentViewDataSource> dataSource;
@property (nonatomic, assign) id <MYSegmentViewDelegate> delegate;

- (instancetype)initWithViewControllers:(NSArray *)viewControllers;

- (void)scrollToViewWithIndex:(NSInteger)index animated:(BOOL)animated;

@end
