//
//  KPLExample.h
//  Keep Layout
//
//  Created by Martin Kiss on 23.6.13.
//  Copyright (c) 2013 Triceratops. All rights reserved.
//

@class KPLExampleViewController;

typedef void (^KPLExampleStateBlock)(NSUInteger state);
typedef KPLExampleStateBlock (^KPLExampleSetupBlock)(KPLExampleViewController *controller);


@interface KPLExample : NSObject


- (instancetype)initWithTitle:(NSString *)name subtitle:(NSString *)subtitle setupBlock:(KPLExampleSetupBlock)setupBlock;

@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *subtitle;
@property (nonatomic, readonly, copy) KPLExampleSetupBlock setupBlock;


@end
