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





- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary<NSString *, id> *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor blackColor];
    self.window.tintColor = [UIColor colorWithRed:1/5. green:2/3. blue:0.9 alpha:1];
    
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





@end
