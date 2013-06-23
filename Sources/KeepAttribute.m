//
//  KeepAttribute.m
//  Keep Layout
//
//  Created by Martin Kiss on 28.1.13.
//  Copyright (c) 2013 Triceratops. All rights reserved.
//

#import "KeepAttribute.h"
#import "UIView+KeepLayout.h"





@implementation KeepAttribute


- (instancetype)init {
    self = [super init];
    if (self) {
        NSAssert(self.class != KeepAttribute.class, @"%@ is abstract class", self.class);
        if (self.class == KeepAttribute.class) {
            return nil;
        }
    }
    return self;
}


#pragma mark Remove


- (void)remove {
    NSAssert(NO, @"-[%@ %@] is abstract", KeepAttribute.class, NSStringFromSelector(_cmd));
}





#pragma mark Grouping


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





#pragma mark Naming & Debugging


- (instancetype)name:(NSString *)format, ... {
    va_list arguments;
    va_start(arguments, format);
    
    self.name = [[NSString alloc] initWithFormat:format arguments:arguments];
    
    va_end(arguments);
    return self;
}


- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ %p; %@ [%@ < %@ < %@]>",
            self.class,
            self,
            self.name ?: @"(no name)",
            KeepValueDescription(self.min),
            KeepValueDescription(self.equal),
            KeepValueDescription(self.max)];
}





@end










#pragma mark -


@interface KeepSimpleAttribute ()

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





@implementation KeepSimpleAttribute





#pragma mark Initialization


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
            NSParameterAssert(view);
            NSParameterAssert(layoutAttribute != NSLayoutAttributeNotAnAttribute);
            NSParameterAssert(coefficient);
        
        NSAssert(self.class != KeepSimpleAttribute.class, @"%@ is abstract class", self.class);
        if (self.class == KeepSimpleAttribute.class) {
            return nil;
        }
        
        self.view = view;
        self.layoutAttribute = layoutAttribute;
        self.relatedView = relatedView;
        self.relatedLayoutAttribute = relatedLayoutAttribute;
        self.constraintView = (relatedView? [view commonSuperview:relatedView] : view);
        self.coefficient = coefficient;
    }
    return self;
}





#pragma mark Constraints


- (NSLayoutConstraint *)createConstraintWithRelation:(NSLayoutRelation)relation value:(KeepValue)value {
    NSAssert(NO, @"-[%@ %@] is abstract", KeepSimpleAttribute.class, NSStringFromSelector(_cmd));
    return nil;
}


- (void)addConstraint:(NSLayoutConstraint *)constraint {
    [self.constraintView addConstraint:constraint];
    
    self.view.translatesAutoresizingMaskIntoConstraints = NO;
    self.relatedView.translatesAutoresizingMaskIntoConstraints = NO;
    self.constraintView.translatesAutoresizingMaskIntoConstraints = NO;
}


- (void)applyValue:(KeepValue)value forConstraint:(NSLayoutConstraint *)constraint {
    NSAssert(NO, @"-[%@ %@] is abstract", KeepSimpleAttribute.class, NSStringFromSelector(_cmd));
}


- (void)removeConstraint:(NSLayoutConstraint *)constraint {
    [self.constraintView removeConstraint:constraint];
}


- (void)remove {
    [self removeConstraint:self.equalConstraint];
    [self removeConstraint:self.maxConstraint];
    [self removeConstraint:self.minConstraint];
}





#pragma mark Values


- (void)setEqual:(KeepValue)equal {
    [super setEqual:equal];
    
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
    [super setMax:max];
    
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
    [super setMin:min];
    
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


@implementation KeepConstantAttribute





#pragma mark Constraint Overrides


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



@implementation KeepMultiplierAttribute





#pragma mark Constraint Overrides


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


@interface KeepGroupAttribute ()


@property (nonatomic, readwrite, strong) id<NSFastEnumeration> attributes;


@end





@implementation KeepGroupAttribute





#pragma mark Initialization


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





#pragma mark Debugging


- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ %p; %@ %@>", self.class, self, self.name ?: @"(no name)", [self valueForKeyPath:@"attributes.description"]];
}





#pragma mark Accessing Values

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





#pragma mark Setting Values


- (void)setEqual:(KeepValue)equal {
    for (KeepAttribute *attribute in self.attributes) attribute.equal = equal;
}


- (void)setMax:(KeepValue)max {
    for (KeepAttribute *attribute in self.attributes) attribute.max = max;
}


- (void)setMin:(KeepValue)min {
    for (KeepAttribute *attribute in self.attributes) attribute.min = min;
}





#pragma mark Remove


- (void)remove {
    for (KeepAttribute *attribute in self.attributes) [attribute remove];
}





@end


