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
    
    view.keepWidth.equal = KeepHigh(400);
    view.keepHeight.equal = KeepHigh(400);
    view.keepInsets.min = KeepRequired(10);
    view.keepCenter.equal = KeepRequired(0.5);
    
    NSLog(@"constraints: %@", self.view.constraints);
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
    
    red.keepWidth.equal = KeepHigh(500);
    red.keepHeight.equal = KeepRequired(100);
    green.keepWidth.equal = KeepHigh(100);
    green.keepHeight.equal = KeepHigh(100);
    blue.keepWidth.equal = KeepRequired(100);
    blue.keepHeight.equal = KeepHigh(500);

    KeepAttribute *allInsets = [KeepAttribute group:
                                red.keepInsets,
                                green.keepInsets,
                                blue.keepInsets,
                                nil];
    allInsets.min = KeepRequired(10); // Never get closer to bounds than 10pts
    
    KeepAttribute *topAndLeftInsets = [KeepAttribute group:
                                       red.keepTopInset,
                                       red.keepLeftInset,
                                       green.keepTopInset,
                                       green.keepLeftInset,
                                       blue.keepTopInset,
                                       blue.keepLeftInset,
                                       nil];
    topAndLeftInsets.equal = KeepLow(10); // Keep the views close to top-left corner, but with low priority.
    
    [green keepLeftOffsetTo:red].equal = KeepRequired(10);
    [blue keepTopOffsetTo:red].equal = KeepRequired(10);
    [blue keepRightOffsetTo:green].equal = KeepRequired(10);
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
