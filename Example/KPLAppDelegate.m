//
//  KPLAppDelegate.m
//  Keep Layout
//
//  Created by Martin Kiss on 27.1.13.
//  Copyright (c) 2013 Triceratops. All rights reserved.
//

#import "KPLAppDelegate.h"
#import "KPLExampleListViewController.h"





@implementation KPLAppDelegate





- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor blackColor];
    
    KPLExampleListViewController *exampleListViewController = [[KPLExampleListViewController alloc] init];
    UINavigationController *masterNavigationController = [[UINavigationController alloc] initWithRootViewController:exampleListViewController];
    
    if (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        UISplitViewController *splitViewController = [[UISplitViewController alloc] init];
        
        UIViewController *placeholderViewController = [[UIViewController alloc] init];
        placeholderViewController.view.backgroundColor = [UIColor whiteColor];
        UINavigationController *detailNavigationController = [[UINavigationController alloc] initWithRootViewController:placeholderViewController];
        
        splitViewController.viewControllers = @[ masterNavigationController, detailNavigationController ];
        splitViewController.delegate = self;
        self.window.rootViewController = splitViewController;
    }
    else {
        self.window.rootViewController = masterNavigationController;
    }
    
    [self.window makeKeyAndVisible];
    return YES;
}





#pragma mark Split View Controller


- (BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation {
    return NO;
}





@end
