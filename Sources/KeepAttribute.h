//
//  KeepAttribute.h
//  Keep Layout
//
//  Created by Martin Kiss on 28.1.13.
//  Copyright (c) 2013 Triceratops. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

#import "KeepTypes.h"



@class KeepRemovableGroup;





/// Each instance if KeepAttribute manages up to 3 NSLayoutConstraints: one for each relation.
/// Class cluster.
@interface KeepAttribute : NSObject



#pragma mark Values
/// Value with priority to be applied to underlaying constraints.
@property (nonatomic, readwrite, assign) KeepValue equal; /// Constraint with relation Equal
@property (nonatomic, readwrite, assign) KeepValue max; /// Constraint with relation GreaterThanOrEqual
@property (nonatomic, readwrite, assign) KeepValue min; /// Constraint with relation LessThanOrEqual

- (void)keepAt:(CGFloat)equalHigh min:(CGFloat)minRequired;
- (void)keepAt:(CGFloat)equalHigh max:(CGFloat)maxRequired;
- (void)keepAt:(CGFloat)equalHigh min:(CGFloat)minRequired max:(CGFloat)maxRequired;
- (void)keepMin:(CGFloat)minRequired max:(CGFloat)maxRequired;


#pragma mark Remove
/// Removes all constraints managed by this attribute from view hierarchy.
- (void)remove;


#pragma mark Grouping
/// Allows you to create groups of attributes. Grouped attribute forwards all methods to its children.
+ (KeepAttribute *)group:(KeepAttribute *)first, ... NS_REQUIRES_NIL_TERMINATION;
/// Executes block and return group of all changed attributes. Call -remove on returned object to discard all changed attribute values.
+ (KeepRemovableGroup *)removableChanges:(void(^)(void))block;


#pragma mar Debugging
/// Debugging helper. Name of attribute is a part of its `-description`
@property (nonatomic, readwrite, copy) NSString *name;
- (instancetype)name:(NSString *)format, ... NS_FORMAT_FUNCTION(1, 2);



@end





/// Private class.
/// Used by Keep Layout implementation to create attributes.
@interface KeepSimpleAttribute : KeepAttribute

/// Properties that don't change in time.
- (instancetype)initWithView:(UIView *)view
             layoutAttribute:(NSLayoutAttribute)layoutAttribute
                 relatedView:(UIView *)relatedView
      relatedLayoutAttribute:(NSLayoutAttribute)relatedLayoutAttribute
                 coefficient:(CGFloat)coefficient;
/// Multiplier of values: equal, min and max
@property (nonatomic, readonly, assign) CGFloat coefficient;

@end



/// Private class.
/// Used for attributes where the values are expressed as constants.
@interface KeepConstantAttribute : KeepSimpleAttribute
@end



/// Private class.
/// Used for attributes where the values are expressed as multipliers.
@interface KeepMultiplierAttribute : KeepSimpleAttribute
@end



/// Private class.
/// The `+group:` method returns instance of this class. Forwards methods from base class cluster interface to its children.
@interface KeepGroupAttribute : KeepAttribute

- (instancetype)initWithAttributes:(id<NSFastEnumeration>)attributes;
@property (nonatomic, readonly, strong) id<NSFastEnumeration> attributes;

@end



/// Private class.
/// The `+removableChanges:` method returns instance of this class.
@interface KeepRemovableGroup : NSObject

+ (KeepRemovableGroup *)current;
+ (void)setCurrent:(KeepRemovableGroup *)current;
- (void)addAttribute:(KeepAttribute *)attribute forRelation:(NSLayoutRelation)relation;

- (void)remove;

@end


