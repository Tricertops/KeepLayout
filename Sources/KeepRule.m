//
//  KeepRule.m
//  Keep Layout
//
//  Created by Martin Kiss on 28.1.13.
//  Copyright (c) 2013 Triceratops. All rights reserved.
//

#import "KeepRule.h"



@interface KeepRule ()

@property (nonatomic, readwrite, assign) KeepRuleType type;
@property (nonatomic, readwrite, assign) CGFloat value;
@property (nonatomic, readwrite, weak) UIView *relatedView;
@property (nonatomic, readwrite, assign) KeepPriority priority;

+ (KeepRuleType)classType;

@end





@implementation KeepRule

- (id)initWithType:(KeepRuleType)type value:(CGFloat)value relatedToView:(UIView *)view priority:(KeepPriority)priority {
    self = [super init];
    if (self) {
        self.type = type;
        self.value = value;
        self.relatedView = view;
        self.priority = priority;
    }
    return self;
}

+ (KeepRuleType)classType {
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Class KeepRule does not have implitit rule type, use one of the subclasses" userInfo:nil];
}

+ (instancetype)must :(CGFloat)value { return [self must: value to:nil]; }
+ (instancetype)shall:(CGFloat)value { return [self shall:value to:nil]; }
+ (instancetype)may  :(CGFloat)value { return [self may:  value to:nil]; }
+ (instancetype)fit  :(CGFloat)value { return [self fit:  value to:nil]; }

+ (instancetype)must :(CGFloat)value to:(UIView *)view { return [[self alloc] initWithType:[self classType] value:value relatedToView:view priority:KeepPriorityMust] ; }
+ (instancetype)shall:(CGFloat)value to:(UIView *)view { return [[self alloc] initWithType:[self classType] value:value relatedToView:view priority:KeepPriorityShall]; }
+ (instancetype)may  :(CGFloat)value to:(UIView *)view { return [[self alloc] initWithType:[self classType] value:value relatedToView:view priority:KeepPriorityMay]  ; }
+ (instancetype)fit  :(CGFloat)value to:(UIView *)view { return [[self alloc] initWithType:[self classType] value:value relatedToView:view priority:KeepPriorityFit]  ; }

@end



@implementation KeepEqual     + (KeepRuleType)classType { return KeepRuleTypeEqual; }     @end
@implementation KeepMax       + (KeepRuleType)classType { return KeepRuleTypeMax;   }     @end
@implementation KeepMin       + (KeepRuleType)classType { return KeepRuleTypeMin;   }     @end
