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
@property (nonatomic, readwrite, strong) KPLExampleStateBlock exampleStateBlock;
@property (nonatomic, readwrite, assign) NSUInteger state;

@end





@implementation KPLExampleViewController





- (id)initWithExample:(KPLExample *)example {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.example = example;
        self.title = self.example.title;
        
        UIBarButtonItem *actionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(actionButtonTapped)];
        self.navigationItem.rightBarButtonItem = actionButton;
    }
    return self;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.view.clipsToBounds = YES;
    
    self.exampleStateBlock = self.example.setupBlock(self);
    if (self.exampleStateBlock) self.exampleStateBlock(self.state);
    
    self.navigationItem.rightBarButtonItem.enabled = (self.exampleStateBlock != nil);
}


- (void)actionButtonTapped {
    if ( ! self.exampleStateBlock) return;
    
    self.state++;
    
    [self.view keepAnimatedWithDuration:0.75
                                  delay:0
                 usingSpringWithDamping:0.4
                  initialSpringVelocity:0.8
                                options:kNilOptions
                                 layout:^{
                                     self.exampleStateBlock(self.state);
                                 }
                             completion:nil];
}




@end
