//
//  MYSlideContentView.h
//  MYSlideViewController
//
//  Created by Michael on 2017/6/26.
//  Copyright © 2017年 Michael. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MYSlideContentViewDelegate <NSObject>

@optional
/**
 * 切换位置后的代理方法
 */
- (void)slideSwitchDidselectAtIndex:(NSInteger)index;

@end

@interface MYSlideContentView : UIView

/**
 * 需要显示的视图
 */
@property (nonatomic, strong) NSArray *viewControllers;
/**
 * 标题
 */
@property (nonatomic, strong) NSArray *titles;
/**
 * 选中位置
 */
@property (nonatomic, assign) NSInteger selectedIndex;
/**
 * Segmented高亮颜色
 */
@property (nonatomic, strong) UIColor *tintColor;
/**
 代理方法
 */
@property (nonatomic, weak) id <MYSlideContentViewDelegate>delegate;
/**
 * 初始化方法
 */
- (instancetype)initWithFrame:(CGRect)frame Titles:(NSArray<NSString *>*)titles viewControllers:(NSArray<UIViewController *>*)viewControllers;
/**
 * 标题显示在ViewController中
 */
- (void)showInViewController:(UIViewController *)viewController;
/**
 * 标题显示在NavigationBar中
 */
- (void)showInNavigationController:(UINavigationController *)navigationController;

@end
