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
    
    [self example1];
}

- (void)example1 {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
    
    KeepValue inset = KeepRequired(10);
    view.keepAllInsets.equal = inset;
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
}

- (void)example3 {
    UIView *red = [[UIView alloc] init];
    red.backgroundColor = [UIColor redColor];
    [self.view addSubview:red];
    
    UIView *green = [[UIView alloc] init];
    green.backgroundColor = [UIColor greenColor];
    [self.view addSubview:green];
    
    UIView *blue = [[UIView alloc] init];
    blue.backgroundColor = [UIColor blueColor];
    [self.view addSubview:blue];
    
    UIView *cyan = [[UIView alloc] init];
    cyan.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:cyan];
    
    UIView *magenta = [[UIView alloc] init];
    magenta.backgroundColor = [UIColor magentaColor];
    [self.view addSubview:magenta];
    
    UIView *yellow = [[UIView alloc] init];
    yellow.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:yellow];
}



@end
