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
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
    
    NSArray *rules = @[ [KeepMax must:10], [KeepMin shall:10] ];
	[view keep:[KeepTopInset rules:rules]];
    [view keep:[KeepBottomInset rules:rules]];
    [view keep:[KeepRightInset rules:rules]];
    [view keep:[KeepLeftInset rules:rules]];
    
    [view keep:[KeepAspectRatio rules:@[[KeepMin must:16/9.]]]];
    [view keep:[KeepHorizontally rules:@[[KeepEqual must:1/2.]]]];
    [view keep:[KeepVertically rules:@[[KeepMax must:1/2.], [KeepMin must:1/3.], [KeepEqual may:1/3.]]]];
}



@end
