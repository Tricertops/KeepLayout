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
    KPLExampleListViewController *exampleListViewController = [[KPLExampleListViewController alloc] init];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:exampleListViewController];
    self.window.backgroundColor = [UIColor blackColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
