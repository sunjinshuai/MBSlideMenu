//
//  AppDelegate.m
//  JSItemsViewController
//
//  Created by Michael on 15/11/19.
//  Copyright © 2015年 com.51fanxing. All rights reserved.
//

#import "AppDelegate.h"
#import "TestViewController.h"
#import "MYSegmentViewController.h"
#import "UIColor+Extension.h"
#import "MYSlideViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // 创建窗口
    self.window = [[UIWindow alloc] init];
    self.window.frame = [UIScreen mainScreen].bounds;
    self.window.backgroundColor = [UIColor blackColor];

    //初始化creditController的自控制器
    TestViewController *viewController1 = [[TestViewController alloc] init];
    viewController1.title = @"测试1";
    viewController1.view.backgroundColor = [UIColor redColor];
    TestViewController *viewController2 = [[TestViewController alloc] init];
    viewController2.title = @"测试2测试2";
    viewController2.view.backgroundColor = [UIColor yellowColor];
    TestViewController *viewController3 = [[TestViewController alloc] init];
    viewController3.title = @"测试3";
    viewController3.view.backgroundColor = [UIColor orangeColor];
    TestViewController *viewController4 = [[TestViewController alloc] init];
    viewController4.title = @"测试4测试4测试4";
    viewController4.view.backgroundColor = [UIColor redColor];
    TestViewController *viewController5 = [[TestViewController alloc] init];
    viewController5.title = @"测试5";
    viewController5.view.backgroundColor = [UIColor yellowColor];
    TestViewController *viewController6 = [[TestViewController alloc] init];
    viewController6.title = @"测试6";
    viewController6.view.backgroundColor = [UIColor orangeColor];
    TestViewController *viewController7 = [[TestViewController alloc] init];
    viewController7.title = @"测试7";
    viewController7.view.backgroundColor = [UIColor orangeColor];
    
    MYSlideViewController *segment = [[MYSlideViewController alloc] initWithViewControllers:@[viewController1,viewController2,viewController3,viewController4,viewController5,viewController6,viewController7]];
    segment.segmentBarHeight = 44;
    segment.indicatorInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    segment.segmentBarY = 64;
    segment.segmentBarType = MYSegmentBarTypeDynamicWidth;
    segment.indicator.backgroundColor = [UIColor colorWithHexString:@"#fa4b9b"];
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:segment];
    self.window.rootViewController = navigation;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
