//
//  KeepAttribute.m
//  Keep Layout
//
//  Created by Martin Kiss on 28.1.13.
//  Copyright (c) 2013 Triceratops. All rights reserved.
//

#import "KeepAttribute.h"



@interface KeepAttribute ()

@property (nonatomic, readwrite, assign) KeepAttributeType type;

+ (KeepAttributeType)classType;

@end




@implementation KeepAttribute



#pragma mark Initialization

- (id)initWithType:(KeepAttributeType)type rules:(NSArray *)rules {
	self = [super init];
	if (self) {
		self.type = type;
	}
	return self;
}

+ (KeepAttributeType)classType {
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Class KeepAttribute does not have implitit attribute type, use one of the subclasses" userInfo:nil];
}

+ (instancetype)rules:(KeepRule *)rules, ... {
    NSArray *rulesArray = nil;
    return [[self alloc] initWithType:[self classType] rules:rulesArray];
}



@end





@implementation KeepWidth       : KeepAttribute @end
@implementation KeepHeight      : KeepAttribute @end
@implementation KeepAspectRatio : KeepAttribute @end
@implementation KeepTopInset    : KeepAttribute @end
@implementation KeepBottomInset : KeepAttribute @end
@implementation KeepLeftInset   : KeepAttribute @end
@implementation KeepRightInset  : KeepAttribute @end
