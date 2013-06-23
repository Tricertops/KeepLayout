//
//  KPLExampleViewController.m
//  Keep Layout
//
//  Created by Martin Kiss on 23.6.13.
//  Copyright (c) 2013 Triceratops. All rights reserved.
//

#import "KPLExampleViewController.h"

#import "KeepLayout.h"





@interface KPLExampleViewController ()

@property (nonatomic, readwrite, strong) KPLExample *example;

@end





@implementation KPLExampleViewController





- (id)initWithExample:(KPLExample *)example {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.example = example;
        self.title = self.example.name;
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.clipsToBounds = YES;
    
    [self.view keepSize:self.view.bounds.size];
    
    [self.view keepAnimatedWithDuration:1 delay:1 layout:^{
        self.example.setupBlock(self.view);
    }];
}


- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self.view keepSize:self.view.bounds.size];
    [self.view layoutIfNeeded];
}





@end
