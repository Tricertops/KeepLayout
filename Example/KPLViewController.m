//
//  KPLViewController.m
//  Keep Layout
//
//  Created by Martin Kiss on 27.1.13.
//  Copyright (c) 2013 Triceratops. All rights reserved.
//

#import "KPLViewController.h"
#import "KeepLayout.h"



@interface KPLViewController ()

@end





@implementation KPLViewController



- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.view.backgroundColor = [UIColor whiteColor];
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self example2];
}

- (void)example1 {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
    
    NSArray *rules = @[ [KeepMin must:10], [KeepEqual may:10] ];
	[view keep:[KeepTopInset rules:rules]];
    [view keep:[KeepBottomInset rules:rules]];
    [view keep:[KeepRightInset rules:rules]];
    [view keep:[KeepLeftInset rules:rules]];
    
    [view keep:[KeepAspectRatio rules:@[[KeepMin must:16/9.]]]];
    [view keep:[KeepHorizontally rules:@[[KeepEqual must:1/2.]]]];
    [view keep:[KeepVertically rules:@[[KeepMax must:1/2.], [KeepMin must:1/3.], [KeepEqual may:1/3.]]]];
}

- (void)example2 {
    UIView *red = [[UIView alloc] init];
    red.backgroundColor = [UIColor redColor];
    [self.view addSubview:red];
    
    UIView *green = [[UIView alloc] init];
    green.backgroundColor = [UIColor greenColor];
    [self.view addSubview:green];
    
    UIView *blue = [[UIView alloc] init];
    blue.backgroundColor = [UIColor blueColor];
    [self.view addSubview:blue];
    
    NSArray *insetRules = @[ [KeepMin must:20], [KeepMax may:20] ];
    for (UIView *view in @[ red, green, blue ]) {
        [view keep:[KeepTopInset rules:insetRules]];
        [view keep:[KeepBottomInset rules:insetRules]];
        [view keep:[KeepLeftInset rules:insetRules]];
        [view keep:[KeepRightInset rules:insetRules]];
    }
    
    NSArray *offsetRules = @[ [KeepMin must:10], [KeepMax shall:10] ];
    [red keep:[KeepBottomOffset to:green rules:offsetRules]];
    [red keep:[KeepBottomOffset to:blue rules:offsetRules]];
    [green keep:[KeepRightOffset to:blue rules:offsetRules]];
    
    [green keep:[KeepHeight rules:@[ [KeepEqual mustTo:red] ]]];
    [blue keep:[KeepHeight rules:@[ [KeepEqual mustTo:red] ]]];
    [blue keep:[KeepWidth rules:@[ [KeepEqual mustTo:green] ]]];
    [green keep:[KeepHeight rules:@[ [KeepEqual must:1 to:red] ]]]; // Keep height of green equal to red.
    [blue keep:[KeepHeight rules:@[ [KeepEqual must:1 to:red] ]]]; // Keep height of blue equal to red.
    [blue keep:[KeepWidth rules:@[ [KeepEqual must:1 to:green] ]]]; // Keep width of blue equal to green.
    
}



@end
