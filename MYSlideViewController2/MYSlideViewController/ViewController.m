//
//  ViewController.m
//  MYSlideViewController
//
//  Created by Michael on 2017/6/26.
//  Copyright © 2017年 Michael. All rights reserved.
//

#import "ViewController.h"
#import "InNavigationViewController.h"
#import "AboveNavigationViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"MYSlideViewControllerExample";
}

- (IBAction)inNavigation:(UIButton *)sender {
    
    InNavigationViewController *inNavigation = [[InNavigationViewController alloc] init];
    [self.navigationController pushViewController:inNavigation animated:YES];
}

- (IBAction)aboveNavigation:(UIButton *)sender {
    
    AboveNavigationViewController *aboveNavigation = [[AboveNavigationViewController alloc] init];
    [self.navigationController pushViewController:aboveNavigation animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
