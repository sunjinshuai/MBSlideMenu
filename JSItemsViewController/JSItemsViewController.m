//
//  JSItemsViewController.m
//  JSItemsViewController
//
//  Created by Michael on 15/11/19.
//  Copyright © 2015年 com.51fanxing. All rights reserved.
//

#import "JSItemsViewController.h"
#import "UIView+Size.h"
#import "NSString+Extension.h"

// 设备类型
#define Device_iPhone4 (FXScreenHeight <= 480.0)   //包括iPhone4 , iPhone4s
#define Device_iPhone5 ((FXScreenHeight > 480.0) && (FXScreenHeight <= 568.0))   //包括iPhone5,iPhone5s
#define Device_iPhone6 ((FXScreenHeight > 568.0) && (FXScreenHeight <= 667.0))   //iPhone6
#define Device_iPhone6Plus ((FXScreenHeight > 667.0) && (FXScreenHeight <= 736.0))   //iPhone6Plus
#define FXRGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
// 尺寸
#define FXScreenWidth [UIScreen mainScreen].bounds.size.width
#define FXScreenHeight [UIScreen mainScreen].bounds.size.height
#define TitleButtonH 44
#define TitleButtonW 60
#define SliderViewH 3

@interface JSItemsViewController ()<UIScrollViewDelegate>

// 标题栏
@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UIView *sliderContentView;
// 滑块条
@property (nonatomic, strong) UIView *sliderView;
// 当前选中
@property (nonatomic, assign) NSInteger currentSelectedIndex;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *selectedButton;

@end

@implementation JSItemsViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.titleView = self.titleView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    
    int after = offsetX / FXScreenWidth + 1;
    
    int before = offsetX / FXScreenWidth;
    
    if (before < 0) {
        return ;
    }
    
    if (after > (scrollView.subviews.count - 1)) {
        after = 2;
    }
    self.sliderView.centerX = (offsetX + FXScreenWidth * 0.5) / scrollView.contentSize.width * self.titleView.width;
    
    UIButton *afterButton = (UIButton *)self.sliderContentView.subviews[after];
    UIButton *beforeButton = (UIButton *)self.sliderContentView.subviews[before];
    
    CGFloat afterTitleW = [afterButton.titleLabel.text sizeWithMaxWidth:MAXFLOAT font:[UIFont systemFontOfSize:17.0]].width;
    CGFloat beforeTitleW = [beforeButton.titleLabel.text sizeWithMaxWidth:MAXFLOAT font:[UIFont systemFontOfSize:17.0]].width;
    
    self.sliderView.width = beforeTitleW + (afterTitleW - beforeTitleW) * ((offsetX - FXScreenWidth * before) / FXScreenWidth);
    
    UIButton *currentButton;
    if (self.sliderView.centerX > afterButton.x) {
        currentButton = afterButton;
    }else{
        currentButton = beforeButton;
    }
    
    if (currentButton != self.selectedButton) {
        
        currentButton.selected = YES;
        self.selectedButton.selected = NO;
      
        self.selectedButton = currentButton;
    }

}

// 响应标题点击，移动滑块位置，滑动控制器
- (void)titleButtonClick:(UIButton *)button
{
    self.currentSelectedIndex = [self.sliderContentView.subviews indexOfObject:button];
    self.scrollView.contentOffset = CGPointMake(self.currentSelectedIndex * FXScreenWidth, 0);
    [UIView animateWithDuration:0.2 animations:^{
        self.sliderView.width = button.titleLabel.width;
        self.sliderView.center = CGPointMake(button.center.x, self.sliderView.center.y);
    }];
    
}

#pragma mark - Private Method
- (void)addSubControllerWithTitle:(NSString *)title controller:(UIViewController *)controller
{
    // 添加自控制器
    [self addChildViewController:controller];
    
    // 添加标题按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont systemFontOfSize:18];
    
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button setTitleColor:FXRGBColor(7, 169, 153) forState:UIControlStateSelected];
    [button addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];

    [self.sliderContentView addSubview:button];
    
    [self.scrollView addSubview:controller.view];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    if (Device_iPhone6Plus) {
        self.titleView.frame = CGRectMake(0, 0, (TitleButtonW + 15) * self.childViewControllers.count, TitleButtonH);
    }else if(Device_iPhone6){
        self.titleView.frame = CGRectMake(0, 0, (TitleButtonW + 10) * self.childViewControllers.count, TitleButtonH);
    }else{
        self.titleView.frame = CGRectMake(0, 0, (TitleButtonW + 5) * self.childViewControllers.count, TitleButtonH);
    }
    
    self.sliderContentView.frame = CGRectMake(0, 0, self.titleView.width, self.titleView.height - self.sliderView.height);
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
    __block CGFloat buttonW = self.sliderContentView.frame.size.width / count;
    __block CGFloat buttonH = self.titleView.height - self.sliderView.height;
    
    __block int i = 0;
    
    [self.sliderContentView.subviews enumerateObjectsUsingBlock:^(__kindof UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UIButton class]]) {
            
            UIButton *button = obj;
            buttonX = buttonW * i++;
            button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        }
    }];
    
    UIButton *button = self.sliderContentView.subviews[self.currentSelectedIndex];
    button.selected = YES;
    self.selectedButton = button;
    
    CGFloat sliderW = [button.titleLabel.text sizeWithMaxWidth:MAXFLOAT font:[UIFont systemFontOfSize:17.0]].width;
    CGFloat sliderCenterX = button.center.x;
    CGFloat sliderCenterY =  TitleButtonH - SliderViewH * 0.5;
    
    self.sliderView.size = CGSizeMake(sliderW, SliderViewH);
    self.sliderView.center = CGPointMake(sliderCenterX, sliderCenterY);
    
    // 初始化view
    self.scrollView.contentSize = CGSizeMake(count * FXScreenWidth, 0);
    
    [self.childViewControllers enumerateObjectsUsingBlock:^(UIViewController *controller, NSUInteger idx, BOOL *stop) {
        
        CGFloat controllerX = FXScreenWidth * idx;
        CGFloat controllerY = 64;
        CGFloat controllerW = FXScreenWidth;
        CGFloat controllerH = FXScreenHeight - 64;
        
        controller.view.frame = CGRectMake(controllerX, controllerY, controllerW, controllerH);
        
        
    }];
    
}


#pragma mark - setter and getter
- (UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, FXScreenWidth, FXScreenHeight)];
        _scrollView.pagingEnabled = YES;
        _scrollView.scrollsToTop = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}

- (UIView *)titleView
{
    if (_titleView == nil) {
        _titleView = [[UIView alloc] init];
        _titleView.backgroundColor = [UIColor whiteColor];
    }
    return _titleView;
}

- (UIView *)sliderView
{
    if (_sliderView == nil) {
        _sliderView = [[UIView alloc] init];
        _sliderView.backgroundColor = FXRGBColor(79, 210, 190);
        [self.titleView addSubview:_sliderView];
    }
    return _sliderView;
}

- (UIView *)sliderContentView
{
    if (!_sliderContentView) {
        _sliderContentView = [[UIView alloc] init];
        _sliderContentView.backgroundColor = [UIColor whiteColor];
        [self.titleView addSubview:_sliderContentView];
    }
    return _sliderContentView;
}


@end
