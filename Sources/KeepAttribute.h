//
//  KeepAttribute.h
//  Keep Layout
//
//  Created by Martin Kiss on 28.1.13.
//  Copyright (c) 2013 Triceratops. All rights reserved.
//

#import "KeepTypes.h"



@class KeepAtomic;
@class KeepRemovableGroup;





/// Each instance if KeepAttribute manages up to 3 NSLayoutConstraints: one for each relation.
/// Class cluster.
@interface KeepAttribute : NSObject



#pragma mark Values
/// Value with priority to be applied to underlaying constraints.
@property (nonatomic, readwrite, assign) KeepValue equal; /// Constraint with relation Equal
@property (nonatomic, readwrite, assign) KeepValue max; /// Constraint with relation GreaterThanOrEqual
@property (nonatomic, readwrite, assign) KeepValue min; /// Constraint with relation LessThanOrEqual

@property (nonatomic, readwrite, assign) CGFloat required __deprecated_msg("Assign number directly to .equal = x; Magic!"); /// Proxy for Equal relation with Required priority.

- (void)keepAt:(KeepValue)equal min:(KeepValue)min;
- (void)keepAt:(KeepValue)equal max:(KeepValue)max;
- (void)keepAt:(KeepValue)equal min:(KeepValue)min max:(KeepValue)max;
- (void)keepMin:(KeepValue)min max:(KeepValue)max;


#pragma mark Activation
/// Whether at least one constraint is active.
@property (nonatomic, readonly) BOOL isActive;
/// Disables all managed constraints.
- (void)deactivate;
- (void)remove __deprecated_msg("Use -deactivate");


#pragma mark Grouping
/// Allows you to create groups of attributes. Grouped attribute forwards all methods to its children.
+ (KeepAttribute *)group:(KeepAttribute *)first, ... NS_REQUIRES_NIL_TERMINATION;

+ (KeepRemovableGroup *)removableChanges:(void(^)(void))block __deprecated_msg("Use +[KeepAtomic layout:]");


#pragma mark Debugging
/// Debugging helper. Name of attribute is a part of its `-description`
@property (nonatomic, readwrite, copy) NSString *name;
- (instancetype)name:(NSString *)format, ... NS_FORMAT_FUNCTION(1, 2);



@end



@interface KeepAtomic : NSObject

/// Executes block and returns group of all changed attributes.
+ (KeepAtomic *)layout:(void(^)(void))block;
/// Disables all managed constraints.
- (void)deactivate;

@end





__deprecated_msg("Use KeepAtomic")
@interface KeepRemovableGroup : KeepAtomic

@end





/// Private class.
/// Used by Keep Layout implementation to create attributes.
@interface KeepSimpleAttribute : KeepAttribute

/// Properties that don't change in time.
- (instancetype)initWithView:(KPView *)view
             layoutAttribute:(NSLayoutAttribute)layoutAttribute
                 relatedView:(KPView *)relatedView
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



