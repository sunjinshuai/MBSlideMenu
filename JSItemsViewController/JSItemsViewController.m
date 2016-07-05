//
//  JSItemsViewController.m
//  JSItemsViewController
//
//  Created by Michael on 15/11/19.
//  Copyright © 2015年 com.51fanxing. All rights reserved.
//

#import "JSItemsViewController.h"
#import "UIView+Size.h"

// 尺寸
#define JSScreenWidth [UIScreen mainScreen].bounds.size.width
#define JSScreenHeight [UIScreen mainScreen].bounds.size.height
#define TitleButtonWH 44
#define Margin 20
#define TitleViewW JSScreenWidth - (TitleButtonWH + Margin) * 2
#define SliderViewH 3

@interface JSItemsViewController ()<UIScrollViewDelegate>

// 标题栏
@property (nonatomic, strong) UIView *titleView;
// 滑块条
@property (nonatomic, strong) UIView *sliderView;
// 当前选中
@property (nonatomic, assign) NSInteger currentSelectedIndex;
@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation JSItemsViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.titleView = self.titleView;

}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGFloat scale = scrollView.contentOffset.x / scrollView.width;
    
    self.sliderView.centerX = self.titleView.width / self.childViewControllers.count * scale + self.titleView.width / self.childViewControllers.count * 0.5;
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int selectedIndex = scrollView.contentOffset.x / JSScreenWidth;
    UIButton *button = self.titleView.subviews[selectedIndex];
    
    [self titleButtonClick:button];
}

#pragma mark - Private Method
- (void)addSubControllerWithTitle:(NSString *)title controller:(UIViewController *)controller
{
    // 添加自控制器
    [self addChildViewController:controller];
    
    // 添加标题按钮
    UIButton *button = [[UIButton alloc] init];
    button.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
    
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor brownColor] forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [button addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.titleView addSubview:button];

    [self.titleView addSubview:self.sliderView];
    
    [self.scrollView addSubview:controller.view];

}

// 响应标题点击，移动滑块位置，滑动控制器
- (void)titleButtonClick:(UIButton *)button
{
    UIButton *beforeSelected = self.titleView.subviews[self.currentSelectedIndex];
    beforeSelected.selected = !beforeSelected.selected;
    button.selected = !button.selected;
    self.currentSelectedIndex = [self.titleView.subviews indexOfObject:button];
    self.sliderView.center = CGPointMake(button.center.x, self.sliderView.center.y);
    self.scrollView.contentOffset = CGPointMake(self.currentSelectedIndex * JSScreenWidth, 0);
}


- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    [self setupLayoutSubViews];
}

- (void)setupLayoutSubViews
{
    
    NSInteger count = self.childViewControllers.count;
    
    __block CGFloat buttonX;
    __block CGFloat buttonY = 0;
    __block CGFloat buttonW = self.titleView.frame.size.width / count;
    __block CGFloat buttonH = TitleButtonWH;
    
    __block int i = 0;
    
    [self.titleView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIButton class]]) {
            
            UIButton *button = (UIButton *)obj;
            buttonX = buttonW * i++;
            button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
            
        }
    }];

    UIButton *firstButton = self.titleView.subviews.firstObject;
    firstButton.selected = YES;
    
    CGFloat sliderW = firstButton.titleLabel.width;
    CGFloat sliderCenterX = firstButton.center.x;
    CGFloat sliderCenterY =  TitleButtonWH - SliderViewH * 0.5;
    
    self.sliderView.size = CGSizeMake(sliderW, SliderViewH);
    self.sliderView.center = CGPointMake(sliderCenterX, sliderCenterY);

    // 初始化view
    self.scrollView.contentSize = CGSizeMake(count * JSScreenWidth, 0);
    
    [self.childViewControllers enumerateObjectsUsingBlock:^(UIViewController *controller, NSUInteger idx, BOOL *stop) {
        
        CGFloat controllerX = JSScreenWidth * idx;
        CGFloat controllerY = 0;
        CGFloat controllerW = JSScreenWidth;
        CGFloat controllerH = JSScreenHeight;
        
        controller.view.frame = CGRectMake(controllerX, controllerY, controllerW, controllerH);
        
        
    }];
    
}

#pragma mark - 懒加载
- (UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
        _scrollView.frame = self.view.bounds;
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}

- (UIView *)titleView
{
    if (_titleView == nil) {
        _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, TitleViewW, 44)];
    }
    return _titleView;
}

- (UIView *)sliderView
{
    if (_sliderView == nil) {
        _sliderView = [[UIView alloc] init];
        _sliderView.backgroundColor = [UIColor blueColor];
    }
    return _sliderView;
}

@end
