//
//  KeepAttribute.m
//  Keep Layout
//
//  Created by Martin Kiss on 28.1.13.
//  Copyright (c) 2013 Triceratops. All rights reserved.
//

#import "KeepAttribute.h"



#pragma mark General Attribute

@interface KeepAttribute ()

@property (nonatomic, readwrite, strong) NSLayoutConstraint *equalConstraint;
@property (nonatomic, readwrite, strong) NSLayoutConstraint *maxConstraint;
@property (nonatomic, readwrite, strong) NSLayoutConstraint *minConstraint;

- (NSLayoutConstraint *)createConstraintWithRelation:(NSLayoutRelation)relation value:(KeepValue)value;
- (void)addConstraint:(NSLayoutConstraint *)constraint;
- (void)applyValue:(KeepValue)value forConstraint:(NSLayoutConstraint *)constraint;
- (void)removeConstraint:(NSLayoutConstraint *)constraint;

@end





@implementation KeepAttribute


- (id)init {
    self = [super init];
    if (self) {
        NSAssert(self != [KeepAttribute class], @"%@ is abstract class", self.class);
    }
    return self;
}

- (NSLayoutConstraint *)createConstraintWithRelation:(NSLayoutRelation)relation value:(KeepValue)value {
    NSAssert(NO, @"-[%@ %@] is abstract", KeepAttribute.class, NSStringFromSelector(_cmd));
    return nil;
}

- (void)addConstraint:(NSLayoutConstraint *)constraint {
    NSAssert(NO, @"-[%@ %@] is abstract", KeepAttribute.class, NSStringFromSelector(_cmd));
}

- (void)applyValue:(KeepValue)value forConstraint:(NSLayoutConstraint *)constraint {
    constraint.constant = value.value;
    if (constraint.priority != value.priority) {
        constraint.priority = value.priority;
    }
}

- (void)removeConstraint:(NSLayoutConstraint *)constraint {
    NSAssert(NO, @"-[%@ %@] is abstract", KeepAttribute.class, NSStringFromSelector(_cmd));
}

- (void)remove {
    [self removeConstraint:self.equalConstraint];
    [self removeConstraint:self.maxConstraint];
    [self removeConstraint:self.minConstraint];
}

- (void)setEqual:(KeepValue)equal {
    self->_equal = equal;
    
    if (KeepValueIsNone(equal)) {
        [self removeConstraint:self.equalConstraint];
        return;
    }
    
    if ( ! self.equalConstraint) {
        self.equalConstraint = [self createConstraintWithRelation:NSLayoutRelationEqual value:equal];
        [self addConstraint:self.equalConstraint];
    }
    [self applyValue:equal forConstraint:self.equalConstraint];
}

- (void)setMax:(KeepValue)max {
    self->_max = max;
    
    if (KeepValueIsNone(max)) {
        [self removeConstraint:self.maxConstraint];
        return;
    }
    
    if ( ! self.maxConstraint) {
        self.maxConstraint = [self createConstraintWithRelation:NSLayoutRelationLessThanOrEqual value:max];
        [self addConstraint:self.maxConstraint];
    }
    [self applyValue:max forConstraint:self.maxConstraint];
}

- (void)setMin:(KeepValue)min {
    self->_min = min;
    
    if (KeepValueIsNone(min)) {
        [self removeConstraint:self.minConstraint];
        return;
    }
    
    if ( ! self.minConstraint) {
        self.minConstraint = [self createConstraintWithRelation:NSLayoutRelationLessThanOrEqual value:min];
        [self addConstraint:self.minConstraint];
    }
    [self applyValue:min forConstraint:self.minConstraint];
}


@end





#pragma mark -
#pragma mark Self Attribute

@interface KeepSelfAttribute ()

@property (nonatomic, readwrite, weak) UIView *view;
@property (nonatomic, readwrite, assign) NSLayoutAttribute layoutAttribute;

@end



@implementation KeepSelfAttribute


- (instancetype)init {
    return [self initWithView:nil layoutAttribute:NSLayoutAttributeNotAnAttribute];
}

- (instancetype)initWithView:(UIView *)view layoutAttribute:(NSLayoutAttribute)layoutAttribute {
    self = [super init];
    if (self) {
        NSParameterAssert(view);
        NSParameterAssert(layoutAttribute != NSLayoutAttributeNotAnAttribute);
        
        self.view = view;
        self.layoutAttribute = layoutAttribute;
    }
    return self;
}


- (NSLayoutConstraint *)createConstraintWithRelation:(NSLayoutRelation)relation value:(KeepValue)value {
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.view attribute:self.layoutAttribute
                                                                  relatedBy:relation
                                                                     toItem:nil attribute:NSLayoutAttributeNotAnAttribute
                                                                 multiplier:1 constant:value.value];
    constraint.priority = value.priority;
    return constraint;
}

- (void)addConstraint:(NSLayoutConstraint *)constraint {
    [self.view addConstraint:constraint];
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)removeConstraint:(NSLayoutConstraint *)constraint {
    [self.view removeConstraint:constraint];
}


@end





#pragma mark -
#pragma mark Superview Attribute

@interface KeepSuperviewAttribute ()

@property (nonatomic, readwrite, weak) UIView *view;
@property (nonatomic, readwrite, assign) NSLayoutAttribute layoutAttribute;
@property (nonatomic, readwrite, assign) NSLayoutAttribute superviewLayoutAttribute;
@property (nonatomic, readwrite, assign) BOOL invertRelation;

@end



@implementation KeepSuperviewAttribute


- (instancetype)init {
    return [self initWithView:nil layoutAttribute:NSLayoutAttributeNotAnAttribute superviewLayoutAttribute:NSLayoutAttributeNotAnAttribute];
}

- (instancetype)initWithView:(UIView *)view layoutAttribute:(NSLayoutAttribute)layoutAttribute superviewLayoutAttribute:(NSLayoutAttribute)superviewLayoutAttribute {
    return [self initWithView:view layoutAttribute:layoutAttribute superviewLayoutAttribute:superviewLayoutAttribute invertRelation:NO];
}
- (instancetype)initWithView:(UIView *)view layoutAttribute:(NSLayoutAttribute)layoutAttribute superviewLayoutAttribute:(NSLayoutAttribute)superviewLayoutAttribute invertRelation:(BOOL)invertRelation {
    self = [super init];
    if (self) {
        NSParameterAssert(view);
        NSParameterAssert(layoutAttribute != NSLayoutAttributeNotAnAttribute);
        NSParameterAssert(view.superview);
        NSParameterAssert(superviewLayoutAttribute != NSLayoutAttributeNotAnAttribute);
        
        self.view = view;
        self.layoutAttribute = layoutAttribute;
        self.superviewLayoutAttribute = superviewLayoutAttribute;
        self.invertRelation = invertRelation;
    }
    return self;
}


- (NSLayoutConstraint *)createConstraintWithRelation:(NSLayoutRelation)relation value:(KeepValue)value {
    if (self.invertRelation) {
        if (relation == NSLayoutRelationGreaterThanOrEqual) relation = NSLayoutRelationLessThanOrEqual;
        else if (relation == NSLayoutRelationLessThanOrEqual) relation = NSLayoutRelationGreaterThanOrEqual;
        
        value.value *= -1;
    }
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.view attribute:self.layoutAttribute
                                                                  relatedBy:relation
                                                                     toItem:self.view.superview attribute:self.superviewLayoutAttribute
                                                                 multiplier:1 constant:value.value];
    constraint.priority = value.priority;
    return constraint;
}

- (void)applyValue:(KeepValue)value forConstraint:(NSLayoutConstraint *)constraint {
    if (self.invertRelation) {
        value.value *= -1;
    }
    [super applyValue:value forConstraint:constraint];
}

- (void)addConstraint:(NSLayoutConstraint *)constraint {
    [self.view.superview addConstraint:constraint];
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)removeConstraint:(NSLayoutConstraint *)constraint {
    [self.view.superview removeConstraint:constraint];
}


@end





#pragma mark -
#pragma mark Group Attribute

@interface KeepGroupAttribute ()

@property (nonatomic, readwrite, strong) id<NSFastEnumeration> attributes;

@end



@implementation KeepGroupAttribute

-(id)init {
    return [self initWithAttributes:nil];
}

- (instancetype)initWithAttributes:(id<NSFastEnumeration>)attributes {
    self = [super init];
    if (self) {
        NSParameterAssert(attributes);
        
        self.attributes = attributes;
    }
    return self;
}

+ (instancetype)group:(KeepAttribute *)first, ... NS_REQUIRES_NIL_TERMINATION {
    va_list list;
    va_start(list, first);
    
    NSMutableArray *attributes = [[NSMutableArray alloc] init];
    KeepAttribute *attribute;
    while ((attribute = va_arg(list, KeepAttribute *))) {
        [attributes addObject:attribute];
    }
    
    va_end(list);
    
    return [[self alloc] initWithAttributes:attributes];
}

- (KeepValue)equal {
    NSLog(@"Warning! Accessing property %@ for grouped attribute, returning KeepNone.", NSStringFromSelector(_cmd));
    return KeepNone;
}

- (KeepValue)min {
    NSLog(@"Warning! Accessing property %@ for grouped attribute, returning KeepNone.", NSStringFromSelector(_cmd));
    return KeepNone;
}

- (KeepValue)max {
    NSLog(@"Warning! Accessing property %@ for grouped attribute, returning KeepNone.", NSStringFromSelector(_cmd));
    return KeepNone;
}

- (void)setEqual:(KeepValue)equal {
    for (KeepAttribute *attribute in self.attributes) attribute.equal = equal;
}

- (void)setMax:(KeepValue)max {
    for (KeepAttribute *attribute in self.attributes) attribute.max = max;
}

- (void)setMin:(KeepValue)min {
    for (KeepAttribute *attribute in self.attributes) attribute.min = min;
}

- (void)remove {
    for (KeepAttribute *attribute in self.attributes) [attribute remove];
}



@end
