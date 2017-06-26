//
//  MYSlideBarView.h
//  MYSlideViewController
//
//  Created by Michael on 2017/6/26.
//  Copyright © 2017年 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MYSlideBarViewDelegate <NSObject>

- (void)slideBarSelectedAtIndex:(NSInteger)index;

@end

@interface MYSlideBarView : UIView

@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, strong) UIColor *itemNormalColor;

@property (nonatomic, strong) UIColor *itemSelectedColor;

@property (nonatomic, assign) BOOL showTitlesInNavBar;

@property (nonatomic, assign) BOOL hideShadow;

@property (nonatomic, weak) id<MYSlideBarViewDelegate> delegate;

@property (nonatomic, assign) CGFloat progress;

//忽略动画
@property (nonatomic, assign) BOOL ignoreAnimation;

@end
