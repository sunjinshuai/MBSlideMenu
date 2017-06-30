//
//  InNavigationViewController.m
//  MYSlideViewController
//
//  Created by michael on 2017/6/27.
//  Copyright © 2017年 Michael. All rights reserved.
//

#import "InNavigationViewController.h"
#import "MYSlideContentView.h"
#import "TestViewController.h"
#import "Constant.h"

@interface InNavigationViewController ()<MYSlideContentViewDelegate>

@property (nonatomic, strong) MYSlideContentView *contentView;
@property (nonatomic, strong) NSMutableArray *viewControllers;
// 当前选中
@property (nonatomic, assign) NSInteger currentSelectedIndex;

@end

@implementation InNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"在导航栏上";
    
    [self addViewControllerToSlideViewController];
}

#pragma mark - MYSlideContentViewDelegate
- (void)slideContentViewSelectAtIndex:(NSInteger)index
{
    self.currentSelectedIndex = index;
}

- (void)addViewControllerToSlideViewController
{
    [self.viewControllers removeAllObjects];
    
    TestViewController *test1 = [[TestViewController alloc] init];
    TestViewController *test2 = [[TestViewController alloc] init];
    TestViewController *test3 = [[TestViewController alloc] init];
    TestViewController *test4 = [[TestViewController alloc] init];
    TestViewController *test5 = [[TestViewController alloc] init];
    TestViewController *test6 = [[TestViewController alloc] init];
    
    [self.viewControllers addObject:test1];
    [self.viewControllers addObject:test2];
    [self.viewControllers addObject:test3];
    [self.viewControllers addObject:test4];
    [self.viewControllers addObject:test5];
    [self.viewControllers addObject:test6];
    
    NSArray *titles = @[@"商品",@"特卖",@"萌星说",@"商品",@"特卖",@"萌星说"];
    
    _contentView = [[MYSlideContentView alloc] initWithFrame:CGRectMake(0, 0, FXScreenWidth, FXScreenHeight) Titles:titles viewControllers:self.viewControllers];
    _contentView.slideBarFrame = CGRectMake(64, 64, FXScreenWidth - 128, 40);
    _contentView.itemMargin = 20;
    _contentView.delegate = self;
    _contentView.itemSelectedColor = FXRGBColor(7, 170, 153);
    _contentView.itemNormalColor = [UIColor blackColor];
    [_contentView showInNavigationController:self.navigationController];
}
#pragma mark - setter & getter
- (NSMutableArray *)viewControllers
{
    if (!_viewControllers) {
        _viewControllers = [NSMutableArray array];
    }
    return _viewControllers;
}

@end
