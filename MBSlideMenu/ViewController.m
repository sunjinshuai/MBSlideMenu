//
//  ViewController.m
//  MBSlideMenu
//
//  Created by sunjinshuai on 2019/4/21.
//  Copyright © 2019 sunjinshuai. All rights reserved.
//

#import "ViewController.h"
#import "MBSlideMenuViewController.h"
#import "MBNavigationBar.h"
#import <MYKit/MYKit.h>
#import <Masonry.h>

// 状态栏高度
#define ITG_STATUS_HEIGHT                       UIApplication.sharedApplication.statusBarFrame.size.height
// 导航栏高度
#define ITG_NAVIGATIONBAR_HEIGHT                (ITG_DEVICE_IPHONE ? 44 : 64)
// tabbar 高度
#define ITG_TABBAR_HEGIGHT                      49
// 状态栏高度和导航栏高度
#define ITG_STATUS_AND_NAVIGATIONBAR_HEIGHT     ((ITGSafeAreaInsets().top ? ITGSafeAreaInsets().top : 20) + ITG_NAVIGATIONBAR_HEIGHT)

@interface ViewController ()

@property (nonatomic, strong) MBNavigationBar *navigationBar;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"摩拜单车";
    
    [self addCutomNavigationBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)addCutomNavigationBar {
    [self.view addSubview:self.navigationBar];
    [self.navigationBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.left.equalTo(self.view);
        make.height.mas_equalTo(ITG_STATUS_AND_NAVIGATIONBAR_HEIGHT);
    }];
    [self.navigationBar setTitle:@"摩拜单车"];
    [self.navigationBar setTintColor:[UIColor whiteColor]];
    [self.navigationBar setLeftButtonWithImage:[UIImage imageNamed:@"navigationbar_list_normal"]];
    self.navigationBar.onClickLeftButton = ^{
        [self leftBarButtonClick];
    };
}

- (void)leftBarButtonClick {
    MBSlideMenuViewController *slideMenuVC = [[MBSlideMenuViewController alloc] init];
    slideMenuVC.view.backgroundColor = [UIColor clearColor];
    [slideMenuVC showAnimation];
    [self addChildViewController:slideMenuVC];
    [self.view addSubview:slideMenuVC.view];
}

#pragma mark - setter & getter
- (MBNavigationBar *)navigationBar {
    if (!_navigationBar) {
        _navigationBar = [MBNavigationBar new];
        _navigationBar.backgroundColor = [UIColor colorWithRed:38 / 255.0 green:41 / 255.0 blue:48 / 255.0 alpha:1.0];
    }
    return _navigationBar;
}

@end
