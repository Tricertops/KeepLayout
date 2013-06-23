//
//  KPLExample.h
//  Keep Layout
//
//  Created by Martin Kiss on 23.6.13.
//  Copyright (c) 2013 Triceratops. All rights reserved.
//



@interface KPLExample : NSObject


- (instancetype)initWithName:(NSString *)name lines:(NSUInteger)lines setupBlock:(void(^)(UIView *container))setupBlock;

@property (nonatomic, readonly, copy) NSString *name;
@property (nonatomic, readonly, assign) NSUInteger lines;
@property (nonatomic, readonly, copy) void(^setupBlock)(UIView *container);


@end
