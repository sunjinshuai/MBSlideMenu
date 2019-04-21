//
//  ViewController.m
//  MBSlideMenu
//
//  Created by sunjinshuai on 2019/4/21.
//  Copyright © 2019 sunjinshuai. All rights reserved.
//

#import "ViewController.h"
#import "MBSlideMenuViewController.h"
#import <MYKit/MYUIKit.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"摩拜单车";
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem barButtonItemWithTarget:self
                                                                              action:@selector(leftBarButtonClick)
                                                                               image:@"navigationbar_list_normal"];
}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
//}
//
//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
//}

- (void)leftBarButtonClick {
    MBSlideMenuViewController *slideMenuVC = [[MBSlideMenuViewController alloc] init];
    slideMenuVC.view.backgroundColor = [UIColor clearColor];
    [slideMenuVC showAnimation];
    [self addChildViewController:slideMenuVC];
    [self.view addSubview:slideMenuVC.view];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
