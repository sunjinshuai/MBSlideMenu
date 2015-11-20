//
//  AppDelegate.m
//  JSItemsViewController
//
//  Created by Michael on 15/11/19.
//  Copyright © 2015年 com.51fanxing. All rights reserved.
//

#import "AppDelegate.h"
#import "JSNavigationController.h"
#import "JSItemsViewController.h"
#import "TestViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // 创建窗口
    self.window = [[UIWindow alloc] init];
    self.window.frame = [UIScreen mainScreen].bounds;
    self.window.backgroundColor = [UIColor blackColor];
    
    JSItemsViewController *itemsController = [[JSItemsViewController alloc] init];
    //初始化creditController的自控制器
    TestViewController *viewController1 = [[TestViewController alloc] init];
    viewController1.view.backgroundColor = [UIColor redColor];
    TestViewController *viewController2 = [[TestViewController alloc] init];
    viewController2.view.backgroundColor = [UIColor yellowColor];
    TestViewController *viewController3 = [[TestViewController alloc] init];
    viewController3.view.backgroundColor = [UIColor orangeColor];
    [itemsController addSubControllerWithTitle:@"测试1" controller:viewController1];
    [itemsController addSubControllerWithTitle:@"测试2" controller:viewController2];
    [itemsController addSubControllerWithTitle:@"测试3" controller:viewController3];
    
    JSNavigationController *navigationController = [[JSNavigationController alloc] initWithRootViewController:itemsController];
    self.window.rootViewController = navigationController;
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
