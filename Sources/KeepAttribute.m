//
//  KeepAttribute.m
//  Keep Layout
//
//  Created by Martin Kiss on 28.1.13.
//  Copyright (c) 2013 Triceratops. All rights reserved.
//

#import "KeepAttribute.h"
#import "UIView+KeepLayout.h"



#pragma mark General Attribute

@interface KeepAttribute ()

@property (nonatomic, readwrite, weak) UIView *view;
@property (nonatomic, readwrite, assign) NSLayoutAttribute layoutAttribute;
@property (nonatomic, readwrite, weak) UIView *relatedView;
@property (nonatomic, readwrite, assign) NSLayoutAttribute relatedLayoutAttribute;
@property (nonatomic, readwrite, weak) UIView *constraintView;

@property (nonatomic, readwrite, assign) CGFloat coefficient;

@property (nonatomic, readwrite, strong) NSLayoutConstraint *equalConstraint;
@property (nonatomic, readwrite, strong) NSLayoutConstraint *maxConstraint;
@property (nonatomic, readwrite, strong) NSLayoutConstraint *minConstraint;

- (instancetype)initWithView:(UIView *)view
             layoutAttribute:(NSLayoutAttribute)layoutAttribute
                 relatedView:(UIView *)relatedView
      relatedLayoutAttribute:(NSLayoutAttribute)superviewLayoutAttribute
                 coefficient:(CGFloat)coefficient;
- (NSLayoutConstraint *)createConstraintWithRelation:(NSLayoutRelation)relation value:(KeepValue)value;
- (void)addConstraint:(NSLayoutConstraint *)constraint;
- (void)applyValue:(KeepValue)value forConstraint:(NSLayoutConstraint *)constraint;
- (void)removeConstraint:(NSLayoutConstraint *)constraint;

@end





@implementation KeepAttribute


- (instancetype)init {
    return [self initWithView:nil
              layoutAttribute:NSLayoutAttributeNotAnAttribute
                  relatedView:nil
       relatedLayoutAttribute:NSLayoutAttributeNotAnAttribute
            coefficient:0];
}

- (instancetype)initWithView:(UIView *)view
             layoutAttribute:(NSLayoutAttribute)layoutAttribute
                 relatedView:(UIView *)relatedView
      relatedLayoutAttribute:(NSLayoutAttribute)relatedLayoutAttribute
                 coefficient:(CGFloat)coefficient {
    self = [super init];
    if (self) {
        if (self.class != KeepGroupAttribute.class) {
            NSParameterAssert(view);
            NSParameterAssert(layoutAttribute != NSLayoutAttributeNotAnAttribute);
            NSParameterAssert(coefficient);
        }
        
        NSAssert(self != [KeepAttribute class], @"%@ is abstract class", self.class);
        
        self.view = view;
        self.layoutAttribute = layoutAttribute;
        self.relatedView = relatedView;
        self.relatedLayoutAttribute = relatedLayoutAttribute;
        self.constraintView = (relatedView? [view commonSuperview:relatedView] : view);
        self.coefficient = coefficient;
    }
    return self;
}

+ (KeepGroupAttribute *)group:(KeepAttribute *)first, ... NS_REQUIRES_NIL_TERMINATION {
    va_list list;
    va_start(list, first);
    
    NSMutableArray *attributes = [[NSMutableArray alloc] init];
    KeepAttribute *attribute = first;
    while (attribute) {
        [attributes addObject:attribute];
        attribute = va_arg(list, KeepAttribute *);
    }
    
    va_end(list);
    
    return [[KeepGroupAttribute alloc] initWithAttributes:attributes];
}


- (NSLayoutConstraint *)createConstraintWithRelation:(NSLayoutRelation)relation value:(KeepValue)value {
    NSAssert(NO, @"-[%@ %@] is abstract", KeepAttribute.class, NSStringFromSelector(_cmd));
    return nil;
}

- (void)addConstraint:(NSLayoutConstraint *)constraint {
    [self.constraintView addConstraint:constraint];
    
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    self.relatedView.translatesAutoresizingMaskIntoConstraints = NO;
    self.constraintView.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)applyValue:(KeepValue)value forConstraint:(NSLayoutConstraint *)constraint {
    NSAssert(NO, @"-[%@ %@] is abstract", KeepAttribute.class, NSStringFromSelector(_cmd));
}

- (void)removeConstraint:(NSLayoutConstraint *)constraint {
    [self.constraintView removeConstraint:constraint];
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
    else {
        [self applyValue:equal forConstraint:self.equalConstraint];
    }
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
    else {
        [self applyValue:max forConstraint:self.maxConstraint];
    }
}

- (void)setMin:(KeepValue)min {
    self->_min = min;
    
    if (KeepValueIsNone(min)) {
        [self removeConstraint:self.minConstraint];
        return;
    }
    
    if ( ! self.minConstraint) {
        self.minConstraint = [self createConstraintWithRelation:NSLayoutRelationGreaterThanOrEqual value:min];
        [self addConstraint:self.minConstraint];
    }
    else {
        [self applyValue:min forConstraint:self.minConstraint];
    }
}


@end





#pragma mark -
#pragma mark Constant Attribute


@implementation KeepConstantAttribute


- (NSLayoutConstraint *)createConstraintWithRelation:(NSLayoutRelation)relation value:(KeepValue)value {
    if (self.coefficient < 0) {
        if (relation == NSLayoutRelationGreaterThanOrEqual) relation = NSLayoutRelationLessThanOrEqual;
        else if (relation == NSLayoutRelationLessThanOrEqual) relation = NSLayoutRelationGreaterThanOrEqual;
    }
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.view attribute:self.layoutAttribute
                                                                  relatedBy:relation
                                                                     toItem:self.relatedView attribute:self.relatedLayoutAttribute
                                                                 multiplier:1 constant:value.value * self.coefficient];
    constraint.priority = value.priority;
    return constraint;
}

- (void)applyValue:(KeepValue)value forConstraint:(NSLayoutConstraint *)constraint {
    constraint.constant = value.value * self.coefficient;
    if (constraint.priority != value.priority) {
        constraint.priority = value.priority;
    }
}


@end





#pragma mark -
#pragma mark Multiplier Attribute



@implementation KeepMultiplierAttribute


- (NSLayoutConstraint *)createConstraintWithRelation:(NSLayoutRelation)relation value:(KeepValue)value {
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.view attribute:self.layoutAttribute
                                                                  relatedBy:relation
                                                                     toItem:self.relatedView attribute:self.relatedLayoutAttribute
                                                                 multiplier:value.value * self.coefficient constant:0];
    constraint.priority = value.priority;
    return constraint;
}

- (void)applyValue:(KeepValue)value forConstraint:(NSLayoutConstraint *)constraint {
    // Since multiplier is not read/write proeperty, we need to re-add the whole constraint again.
    [self removeConstraint:constraint];
    constraint = [self createConstraintWithRelation:constraint.relation value:value];
    [self addConstraint:constraint];
}


@end





#pragma mark -
#pragma mark Group Attribute

@interface KeepGroupAttribute ()

@property (nonatomic, readwrite, strong) id<NSFastEnumeration> attributes;

@end



@implementation KeepGroupAttribute

- (id)init {
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




