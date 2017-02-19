//
//  MYSegmentViewController.m
//  JSItemsViewController
//
//  Created by Michael on 2017/2/9.
//  Copyright © 2017年 com.51fanxing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+Extension.h"

extern NSString *const segmentBarItemID;

typedef NS_ENUM(NSInteger, MYSegmentBarType) {
    MYSegmentBarTypeStaticWidth,
    MYSegmentBarTypeDynamicWidth,
};

@class MYSlideViewController;

@protocol MYSlideViewControllerDelegate <NSObject>
@optional
- (void)slideViewController:(MYSlideViewController *)slideViewController didSelectViewIndex:(NSInteger)selectViewIndex;

- (BOOL)slideViewController:(MYSlideViewController *)slideViewController shouldSelectViewIndex:(NSInteger)selectViewIndex;

@end

@interface MYSlideViewController : UIViewController

@property (nonatomic, copy) NSArray *viewControllers;

@property (nonatomic, strong, readonly) UICollectionView *segmentBar;

@property (nonatomic, strong, readonly) UIScrollView *slideView;

@property (nonatomic, strong, readonly) UIView *indicator;

@property (nonatomic, assign) UIEdgeInsets indicatorInsets;

@property (nonatomic, weak, readonly) UIViewController *selectedViewController;

@property (nonatomic, assign, readonly) NSInteger presentViewIndex;

@property (nonatomic, assign) id <MYSlideViewControllerDelegate> delegate;

@property (nonatomic, assign) MYSegmentBarType segmentBarType;

@property (nonatomic, assign) CGFloat segmentBarHeight;
@property (nonatomic, assign) CGFloat segmentBarWidth;
@property (nonatomic, assign) CGFloat segmentBarY;

@property (nonatomic, assign) BOOL hideSegmentBar;

- (void)scrollToViewIndex:(NSInteger)index animated:(BOOL)animated;

- (instancetype)initWithViewControllers:(NSArray *)viewControllers;

@end
