//
//  KPLExample.m
//  Keep Layout
//
//  Created by Martin Kiss on 23.6.13.
//  Copyright (c) 2013 Triceratops. All rights reserved.
//

#import "KPLExample.h"





@interface KPLExample ()


@property (nonatomic, readwrite, copy) NSString *title;
@property (nonatomic, readwrite, copy) NSString *subtitle;
@property (nonatomic, readwrite, copy) KPLExampleSetupBlock setupBlock;


@end





@implementation KPLExample





- (instancetype)initWithTitle:(NSString *)name subtitle:(NSString *)subtitle setupBlock:(KPLExampleSetupBlock)setupBlock {
    self = [super init];
    if (self) {
        self.title = name;
        self.subtitle = subtitle;
        self.setupBlock = setupBlock;
    }
    return self;
}





@end
