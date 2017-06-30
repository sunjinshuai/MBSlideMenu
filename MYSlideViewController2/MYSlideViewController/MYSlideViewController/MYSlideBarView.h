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

/**
 * 当前选中的index
 */
@property (nonatomic, assign) NSInteger selectedIndex;
/**
 * 标题数组
 */
@property (nonatomic, strong) NSArray *titles;
/**
 * 按钮正常时的颜色
 */
@property (nonatomic, strong) UIColor *itemNormalColor;
/**
 * 按钮选中时的颜色
 */
@property (nonatomic, strong) UIColor *itemSelectedColor;
/**
 * 隐藏下划线
 */
@property (nonatomic, assign) BOOL hideShadow;
/**
 * item间距
 */
@property (nonatomic, assign) CGFloat itemMargin;
@property (nonatomic, assign) CGRect slideBarFrame;
@property (nonatomic, weak) id<MYSlideBarViewDelegate>delegate;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) BOOL ignoreAnimation;

@end
