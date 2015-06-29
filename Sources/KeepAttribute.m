//
//  KeepAttribute.m
//  Keep Layout
//
//  Created by Martin Kiss on 28.1.13.
//  Copyright (c) 2013 Triceratops. All rights reserved.
//

#import "KeepAttribute.h"
#import "KeepView.h"
#import "KeepLayoutConstraint.h"





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





#pragma mark Values


- (void)keepAt:(KeepValue)equal min:(KeepValue)min {
    self.equal = KeepValueSetDefaultPriority(equal, KeepPriorityHigh);
    self.min = min;
}


- (void)keepAt:(KeepValue)equal max:(KeepValue)max {
    self.equal = KeepValueSetDefaultPriority(equal, KeepPriorityHigh);
    self.max = max;
}


- (void)keepAt:(KeepValue)equal min:(KeepValue)min max:(KeepValue)max {
    self.equal = KeepValueSetDefaultPriority(equal, KeepPriorityHigh);
    self.min = min;
    self.max = max;
}


- (void)keepMin:(KeepValue)min max:(KeepValue)max {
    self.min = min;
    self.max = max;
}


- (CGFloat)required {
    KeepValue equal = self.equal;
    return (KeepValueGetPriority(equal) == KeepPriorityRequired? equal : NAN);
}


- (void)setRequired:(CGFloat)value {
    self.equal = KeepRequired(value);
}





#pragma mark Activation


- (BOOL)isActive {
    NSAssert(NO, @"-[%@ %@] is abstract", KeepAttribute.class, NSStringFromSelector(_cmd));
    return NO;
}


- (void)deactivate {
    NSAssert(NO, @"-[%@ %@] is abstract", KeepAttribute.class, NSStringFromSelector(_cmd));
}


- (void)remove {
    [self deactivate];
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


+ (KeepRemovableGroup *)removableChanges:(void(^)(void))block {
    return (KeepRemovableGroup *)[KeepAtomic layout:block];
}





#pragma mark Naming & Debugging


- (instancetype)name:(NSString *)format, ... {
#ifdef DEBUG
    va_list arguments;
    va_start(arguments, format);
    
    self.name = [[NSString alloc] initWithFormat:format arguments:arguments];
    
    va_end(arguments);
#endif
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

@property (nonatomic, readwrite, weak) KPView *view;
@property (nonatomic, readwrite, assign) NSLayoutAttribute layoutAttribute;
@property (nonatomic, readwrite, weak) KPView *relatedView;
@property (nonatomic, readwrite, assign) NSLayoutAttribute relatedLayoutAttribute;

@property (nonatomic, readwrite, assign) CGFloat coefficient;

@property (nonatomic, readwrite, strong) KeepLayoutConstraint *equalConstraint;
@property (nonatomic, readwrite, strong) KeepLayoutConstraint *maxConstraint;
@property (nonatomic, readwrite, strong) KeepLayoutConstraint *minConstraint;

- (instancetype)initWithView:(KPView *)view
             layoutAttribute:(NSLayoutAttribute)layoutAttribute
                 relatedView:(KPView *)relatedView
      relatedLayoutAttribute:(NSLayoutAttribute)superviewLayoutAttribute
                 coefficient:(CGFloat)coefficient;
- (KeepLayoutConstraint *)createConstraintWithRelation:(NSLayoutRelation)relation value:(KeepValue)value;
- (KeepLayoutConstraint *)applyValue:(KeepValue)value forConstraint:(KeepLayoutConstraint *)constraint relation:(NSLayoutRelation)relation;
- (void)setNameForConstraint:(KeepLayoutConstraint *)constraint relation:(NSLayoutRelation)relation value:(KeepValue)value;
- (void)activateConstraint:(KeepLayoutConstraint *)constraint active:(BOOL)active;

@end



@interface KeepAtomic ()

+ (instancetype)current;
- (void)addAttribute:(KeepAttribute *)attribute forRelation:(NSLayoutRelation)relation;
- (void)addConstraint:(KeepLayoutConstraint *)constraint active:(BOOL)active;

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


- (instancetype)initWithView:(KPView *)view
             layoutAttribute:(NSLayoutAttribute)layoutAttribute
                 relatedView:(KPView *)relatedView
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
        self.coefficient = coefficient;
    }
    return self;
}





#pragma mark Constraints


- (KeepLayoutConstraint *)createConstraintWithRelation:(NSLayoutRelation)relation value:(KeepValue)value {
    NSAssert(NO, @"-[%@ %@] is abstract", KeepSimpleAttribute.class, NSStringFromSelector(_cmd));
    return nil;
}


- (KeepLayoutConstraint *)applyValue:(KeepValue)value forConstraint:(KeepLayoutConstraint *)constraint relation:(NSLayoutRelation)relation {
    NSAssert(NO, @"-[%@ %@] is abstract", KeepSimpleAttribute.class, NSStringFromSelector(_cmd));
    return nil;
}


- (BOOL)isActive {
    return (self.equalConstraint.keepActive || self.maxConstraint.keepActive || self.minConstraint.keepActive);
}


- (void)activateConstraint:(KeepLayoutConstraint *)constraint active:(BOOL)active {
    if (constraint.keepActive != active) {
        KeepAtomic *atomic = [KeepAtomic current];
        if (atomic) {
            [atomic addConstraint:constraint active:active];
        }
        else {
            constraint.keepActive = active;
        }
    }
}


- (void)deactivate {
    self.equal = KeepNone;
    self.max = KeepNone;
    self.min = KeepNone;
}


- (void)remove {
    [self deactivate];
}





#pragma mark Values


- (KeepLayoutConstraint *)adjustConstraint:(KeepLayoutConstraint *)constraint forRelation:(NSLayoutRelation)relation value:(KeepValue)value {
    BOOL isNone = KeepValueIsNone(value);
    if (isNone) {
        [self activateConstraint:constraint active:NO];
        constraint = nil;
    }
    else {
        value = KeepValueSetDefaultPriority(value, KeepPriorityRequired);
        if ( ! constraint) {
            constraint = [self createConstraintWithRelation:relation value:value];
            [self activateConstraint:constraint active:YES];
        }
        else {
            constraint = [self applyValue:value forConstraint:constraint relation:relation];
        }
        [self setNameForConstraint:constraint relation:relation value:value];
        [[KeepAtomic current] addAttribute:self forRelation:relation];
    }
    return constraint;
}


- (void)setEqual:(KeepValue)equal {
    KeepValue adjustedEqual = KeepValueSetDefaultPriority(equal, KeepPriorityRequired);
    [super setEqual:adjustedEqual];
    self.equalConstraint = [self adjustConstraint:self.equalConstraint forRelation:NSLayoutRelationEqual value:equal];
}


- (void)setMax:(KeepValue)max {
    KeepValue adjustedMax = KeepValueSetDefaultPriority(max, KeepPriorityRequired);
    [super setMax:adjustedMax];
    self.maxConstraint = [self adjustConstraint:self.maxConstraint forRelation:NSLayoutRelationLessThanOrEqual value:max];
}


- (void)setMin:(KeepValue)min {
    KeepValue adjustedMin = KeepValueSetDefaultPriority(min, KeepPriorityRequired);
    [super setMin:adjustedMin];
    self.minConstraint = [self adjustConstraint:self.minConstraint forRelation:NSLayoutRelationGreaterThanOrEqual value:min];
}



- (void)setNameForConstraint:(KeepLayoutConstraint *)constraint relation:(NSLayoutRelation)relation value:(KeepValue)value {
#ifdef DEBUG
    NSDictionary *relationNames = @{
                                    @(NSLayoutRelationEqual) : @"equal to",
                                    @(NSLayoutRelationGreaterThanOrEqual) : @"at least",
                                    @(NSLayoutRelationLessThanOrEqual) : @"at most",
                                    };
    [constraint name:@"%@ %@ %@ with %@ priority", self.name, [relationNames objectForKey:@(relation)], @((double)value), KeepPriorityDescription(KeepValueGetPriority(value))];
#endif
}





@end










#pragma mark -


@implementation KeepConstantAttribute





#pragma mark Constraint Overrides


- (KeepLayoutConstraint *)createConstraintWithRelation:(NSLayoutRelation)relation value:(KeepValue)value {
    if (self.coefficient < 0) {
        if (relation == NSLayoutRelationGreaterThanOrEqual) relation = NSLayoutRelationLessThanOrEqual;
        else if (relation == NSLayoutRelationLessThanOrEqual) relation = NSLayoutRelationGreaterThanOrEqual;
    }
    KeepLayoutConstraint *constraint = [KeepLayoutConstraint constraintWithItem:self.view attribute:self.layoutAttribute
                                                                    relatedBy:relation
                                                                       toItem:self.relatedView attribute:self.relatedLayoutAttribute
                                                                   multiplier:1 constant:value * self.coefficient];
    constraint.priority = KeepValueGetPriority(value);
    return constraint;
}


- (KeepLayoutConstraint *)applyValue:(KeepValue)value forConstraint:(KeepLayoutConstraint *)constraint relation:(NSLayoutRelation)relation {
    BOOL wasRequired = (constraint.priority == KeepPriorityRequired);
    BOOL isRequired = (KeepValueGetPriority(value) == KeepPriorityRequired);
    if (isRequired != wasRequired) {
        /// “Priorities may not change from non-required to required or visa versa.”
        [self activateConstraint:constraint active:NO];
        constraint = [self createConstraintWithRelation:relation value:value];
        [self activateConstraint:constraint active:YES];
        
    }
    else if ( ! isRequired) {
        constraint.priority = KeepValueGetPriority(value);
    }
    constraint.constant = value * self.coefficient;
    
    return constraint;
}





@end










#pragma mark -



@implementation KeepMultiplierAttribute





#pragma mark Constraint Overrides


- (KeepLayoutConstraint *)createConstraintWithRelation:(NSLayoutRelation)relation value:(KeepValue)value {
    KeepLayoutConstraint *constraint = [KeepLayoutConstraint constraintWithItem:self.view attribute:self.layoutAttribute
                                                                    relatedBy:relation
                                                                       toItem:self.relatedView attribute:self.relatedLayoutAttribute
                                                                   multiplier:value * self.coefficient constant:0];
    constraint.priority = KeepValueGetPriority(value);
    return constraint;
}


- (KeepLayoutConstraint *)applyValue:(KeepValue)value forConstraint:(KeepLayoutConstraint *)constraint relation:(NSLayoutRelation)relation {
    [self activateConstraint:constraint active:NO];
    constraint = [self createConstraintWithRelation:relation value:value];
    [self activateConstraint:constraint active:YES];
    return constraint;
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





#pragma mark Activation


- (BOOL)isActive {
    for (KeepAttribute *attribute in self.attributes) {
        if (attribute.isActive) {
            return YES;
        }
    }
    return NO;
}


- (void)deactivate {
    for (KeepAttribute *attribute in self.attributes) {
        [attribute deactivate];
    }
}





@end









#pragma mark -


@interface KeepAtomic ()

@property (nonatomic, readonly, strong) NSMutableSet *equalAttributes;
@property (nonatomic, readonly, strong) NSMutableSet *minAttributes;
@property (nonatomic, readonly, strong) NSMutableSet *maxAttributes;

@property (nonatomic, readonly, strong) NSMutableArray *activeConstraints;
@property (nonatomic, readonly, strong) NSMutableArray *inactiveConstraints;

@end





@implementation KeepAtomic





#pragma mark Initialization


- (instancetype)init {
    self = [super init];
    if (self) {
        self->_equalAttributes = [[NSMutableSet alloc] init];
        self->_minAttributes = [[NSMutableSet alloc] init];
        self->_maxAttributes = [[NSMutableSet alloc] init];
        
        self->_activeConstraints = [NSMutableArray new];
        self->_inactiveConstraints = [NSMutableArray new];
        
    }
    return self;
}


+ (KeepAtomic *)layout:(void (^)(void))block {
    KeepAtomic *atomic = [KeepAtomic new];
    [KeepAtomic setCurrent:atomic];
    block();
    [KeepAtomic setCurrent:nil];
    [NSLayoutConstraint keepConstraints:atomic.inactiveConstraints active:NO];
    [NSLayoutConstraint keepConstraints:atomic.activeConstraints active:YES];
    [atomic.activeConstraints removeAllObjects];
    [atomic.inactiveConstraints removeAllObjects];
    return atomic;
}





#pragma mark Building


static NSMutableArray *KeepAtomicStack = nil;


+ (KeepAtomic *)current {
    return KeepAtomicStack.lastObject;
}


+ (void)setCurrent:(KeepAtomic *)current {
    if ( ! KeepAtomicStack) {
        KeepAtomicStack = [NSMutableArray array];
    }
    if (current) {
        [KeepAtomicStack addObject:current];
    }
    else {
        [KeepAtomicStack removeLastObject];
    }
}


- (void)addAttribute:(KeepAttribute *)attribute forRelation:(NSLayoutRelation)relation {
    switch (relation) {
        case NSLayoutRelationEqual: [self.equalAttributes addObject:attribute]; break;
        case NSLayoutRelationLessThanOrEqual: [self.maxAttributes addObject:attribute]; break;
        case NSLayoutRelationGreaterThanOrEqual: [self.minAttributes addObject:attribute]; break;
    }
}


- (void)addConstraint:(KeepLayoutConstraint *)constraint active:(BOOL)active {
    if (active) {
        [self.activeConstraints addObject:constraint];
    }
    else {
        [self.inactiveConstraints addObject:constraint];
    }
}





#pragma mark Activation


- (void)deactivate {
    [KeepAtomic layout:^{
        for (KeepAttribute *attribute in self.equalAttributes) attribute.equal = KeepNone;
        for (KeepAttribute *attribute in self.minAttributes) attribute.min = KeepNone;
        for (KeepAttribute *attribute in self.maxAttributes) attribute.max = KeepNone;
    }];
    [self.equalAttributes removeAllObjects];
    [self.minAttributes removeAllObjects];
    [self.maxAttributes removeAllObjects];
}


- (void)remove {
    [self deactivate];
}





@end




