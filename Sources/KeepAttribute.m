//
//  KeepAttribute.m
//  Keep Layout
//
//  Created by Martin Kiss on 28.1.13.
//  Copyright (c) 2013 Triceratops. All rights reserved.
//

#import "KeepAttribute.h"

#define PRIVATE



@interface KeepAttribute (PRIVATE)

@property (nonatomic, readwrite, assign) KeepAttributeType type;

@end




@implementation KeepAttribute



#pragma mark Initialization

- (id)initWithType:(KeepAttributeType)type {
	self = [super init];
	if (self) {
		self.type = type;
	}
	return self;
}


#pragma mark Quick Construction

+ (instancetype)width		{ return [[self alloc] initWithType:KeepAttributeTypeWidth      ]; }
+ (instancetype)height		{ return [[self alloc] initWithType:KeepAttributeTypeHeight     ]; }
+ (instancetype)aspectRatio { return [[self alloc] initWithType:KeepAttributeTypeAspectRatio]; }
+ (instancetype)leftInset	{ return [[self alloc] initWithType:KeepAttributeTypeLeftInset  ]; }
+ (instancetype)rightInset	{ return [[self alloc] initWithType:KeepAttributeTypeRightInset ]; }
+ (instancetype)topInset	{ return [[self alloc] initWithType:KeepAttributeTypeTopInset   ]; }
+ (instancetype)bottomInset { return [[self alloc] initWithType:KeepAttributeTypeBottomInset]; }



@end
