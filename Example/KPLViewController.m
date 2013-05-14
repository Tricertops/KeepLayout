//
//  KPLViewController.m
//  Keep Layout
//
//  Created by Martin Kiss on 27.1.13.
//  Copyright (c) 2013 Triceratops. All rights reserved.
//

#import "KPLViewController.h"
#import "KeepLayout.h"



@interface KPLViewController (){
    UIView *subview;
    NSLayoutConstraint* portraitConstraint;
    NSLayoutConstraint* landscapeConstraint;
}
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
    subview = view;
    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
    
    // Keep at least 10pt gap between the view and superview edges.
    NSArray *rules = @[ [KeepMin must:10], [KeepEqual may:10] ];
	[view keep:[KeepTopInset rules:rules]];
    [view keep:[KeepBottomInset rules:rules]];
    [view keep:[KeepRightInset rules:rules]];
    [view keep:[KeepLeftInset rules:rules]];
    
    [[KeepAspectRatio rules:@[[KeepMin must:32/9.]]] applyInView:view withBlock:^(UIView *commonVIew, NSLayoutConstraint *constraint) {
        landscapeConstraint = constraint;
    }];
    
    [[KeepAspectRatio rules:@[[KeepMin must:1.]]] applyInView:view withBlock:^(UIView *commonVIew, NSLayoutConstraint *constraint) {
        portraitConstraint = constraint;
    }];

    [self updateConstraintsForOrientation:self.interfaceOrientation];
    
    [view keep:[KeepHorizontally rules:@[[KeepEqual must:1/2.]]]]; // Keep it horizontally in center.
            
    [view keep:[KeepVertically rules:@[[KeepMax must:1/2.], [KeepMin must:1/3.], [KeepEqual may:1/3.]]]]; // Keep it vertically between 1/3 and 1/2 of height with preffered position at 1/3.
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
    
    // Keep at least 30pt gap between the views and superview edges.
    NSArray *insetRules = @[ [KeepMin must:30], [KeepMax may:30] ];
    for (UIView *view in @[ red, green, blue ]) {
        [view keep:[KeepTopInset rules:insetRules]];
        [view keep:[KeepBottomInset rules:insetRules]];
        [view keep:[KeepLeftInset rules:insetRules]];
        [view keep:[KeepRightInset rules:insetRules]];
    }
    
    NSArray *offsetRules = @[ [KeepMin must:10], [KeepMax shall:10] ];
    [red keep:[KeepBottomOffset to:green rules:offsetRules]]; // Keep 10pt bottom gap between red and green.
    [red keep:[KeepBottomOffset to:blue rules:offsetRules]]; // Keep 10pt bottom gap between red and blue.
    [green keep:[KeepRightOffset to:blue rules:offsetRules]]; // Keep 10pt gap between green and blue.
    
    [green keep:[KeepHeight rules:@[ [KeepEqual must:1 to:red] ]]]; // Keep height of green equal to red.
    [blue keep:[KeepHeight rules:@[ [KeepEqual must:1 to:red] ]]]; // Keep height of blue equal to red.
    [blue keep:[KeepWidth rules:@[ [KeepEqual must:1 to:green] ]]]; // Keep width of blue equal to green.
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
    
    // Random sizes
    for (UIView *view in @[ red, green, blue, cyan, magenta, yellow ]) {
        #define RANDOM(X) (arc4random()%(X))
        [view keep:[KeepWidth rules:@[ [KeepEqual must:50 + RANDOM(50)] ]]];
        [view keep:[KeepHeight rules:@[ [KeepEqual must:50 + RANDOM(150)] ]]];
    }
    // Keep 'magenta' centered
    [magenta keep:[KeepHorizontally rules:@[ [KeepEqual must:0.5] ]]];
    [magenta keep:[KeepVertically rules:@[ [KeepEqual must:0.5] ]]];
    
    NSArray *padding = @[ [KeepMin shall:10], [KeepMax may:10] ];
    
    // Keep gaps between views
    [red keep:[KeepRightOffset to:green rules:padding]];
    [cyan keep:[KeepRightOffset to:magenta rules:padding]];
    [green keep:[KeepRightOffset to:blue rules:padding]];
    [magenta keep:[KeepRightOffset to:yellow rules:padding]];
    [green keep:[KeepBottomOffset to:magenta rules:padding]];
    
    NSArray *alignRules = @[ [KeepEqual must:0] ]; // Keep aligned with zero tolerance.
    
    // Horizontal alignment
    [red keep:[KeepAlignBottom to:green rules:alignRules]];
    [blue keep:[KeepAlignBottom to:green rules:alignRules]];
    [cyan keep:[KeepAlignTop to:magenta rules:alignRules]];
    [yellow keep:[KeepAlignTop to:magenta rules:alignRules]];
    
    // Vertical alignment
    [red keep:[KeepAlignRight to:cyan rules:alignRules]];
    [green keep:[KeepAlignCenterX to:magenta rules:alignRules]];
    [blue keep:[KeepAlignLeft to:yellow rules:alignRules]];
}

- (void)updateConstraintsForOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if(UIDeviceOrientationIsPortrait(toInterfaceOrientation)){
        [subview removeConstraint:landscapeConstraint];
        [subview addConstraint:portraitConstraint];
    }
    else{
        [subview addConstraint:landscapeConstraint];
        [subview removeConstraint:portraitConstraint];
    }
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self updateConstraintsForOrientation:toInterfaceOrientation];
}

@end
