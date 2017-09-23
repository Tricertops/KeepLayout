//
//  KPLExampleViewController.h
//  Keep Layout
//
//  Created by Martin Kiss on 23.6.13.
//  Copyright (c) 2013 Triceratops. All rights reserved.
//

#import "KPLExample.h"





@interface KPLExampleViewController : UIViewController


- (instancetype)initWithExample:(KPLExample *)example;
@property (nonatomic, readonly, strong) KPLExample *example;

@property (nonatomic, readonly, strong) UIView *containerView;


@end
