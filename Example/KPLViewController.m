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
    
    [self example3];
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
    
    NSArray *views = @[ red, green, blue ];
    
    red.keepWidth.equal = KeepHigh(500);
    red.keepHeight.equal = KeepRequired(100);
    green.keepWidth.equal = KeepHigh(100);
    green.keepHeight.equal = KeepHigh(100);
    blue.keepWidth.equal = KeepRequired(100);
    blue.keepHeight.equal = KeepHigh(500);

    // Never get closer to bounds than 10 pts
    views.keepInsets.min = KeepRequired(10);
    
    // Keep the views close to top-left corner, but with low priority.
    views.keepTopInset.equal = KeepLow(10);
    views.keepLeftInset.equal = KeepLow(10);
    
    KeepAttribute *offsets = [KeepAttribute group:
                              green.keepLeftOffset(red),
                              blue.keepTopOffset(red),
                              blue.keepRightOffset(green),
                              nil];
    offsets.equal = KeepRequired(10); // Never get closer to each other than 10 pts.
}

- (void)example3 {
    UIView *red = [[UIView alloc] init];
    red.backgroundColor = [UIColor redColor];
    [self.view addSubview:red];
    
    UIView *green = [[UIView alloc] init];
    green.backgroundColor = [UIColor greenColor];
    [self.view addSubview:green];
    
//    UIView *blue = [[UIView alloc] init];
//    blue.backgroundColor = [UIColor blueColor];
//    [self.view addSubview:blue];
//    
//    UIView *cyan = [[UIView alloc] init];
//    cyan.backgroundColor = [UIColor cyanColor];
//    [self.view addSubview:cyan];
//    
//    UIView *magenta = [[UIView alloc] init];
//    magenta.backgroundColor = [UIColor magentaColor];
//    [self.view addSubview:magenta];
//    
//    UIView *yellow = [[UIView alloc] init];
//    yellow.backgroundColor = [UIColor yellowColor];
//    [self.view addSubview:yellow];
    
    red.keepWidth.equal = KeepRequired(100);
    red.keepHeight.equal = KeepRequired(150);
    red.keepCenter.equal = KeepRequired(0.5);
    
    green.keepWidth.equal = KeepRequired(50);
    green.keepHeight.equal = KeepRequired(50);
    
    green.keepTopOffset(red).equal = KeepRequired(10);
    green.keepRightAlign(red).equal = KeepRequired(10);
    
    [self.view keepAnimatedWithDuration:3 delay:1 layout:^{
        red.keepVerticalCenter.equal = KeepRequired(0.25);
        red.keepWidth.equal = KeepRequired(300);
    }];
    
}



@end
