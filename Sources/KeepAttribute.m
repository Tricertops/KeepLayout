//
//  KeepAttribute.m
//  Keep Layout
//
//  Created by Martin Kiss on 28.1.13.
//  Copyright (c) 2013 Triceratops. All rights reserved.
//

#import "KeepAttribute.h"
#import "KeepRule.h"
#import "UIView+KeepLayout.h"



@interface KeepAttribute ()

@property (nonatomic, readwrite, assign) KeepAttributeType type;
@property (nonatomic, readwrite, weak) UIView *relatedView;
@property (nonatomic, readwrite, copy) NSArray *rules;

+ (KeepAttributeType)classType;

@end




@implementation KeepAttribute



#pragma mark Initialization

- (id)initWithType:(KeepAttributeType)type relatedView:(UIView *)view rules:(NSArray *)rules {
    self = [super init];
	if (self) {
		self.type = type;
        self.relatedView = view;
        self.rules = rules;
	}
	return self;
}

- (id)initWithType:(KeepAttributeType)type rules:(NSArray *)rules {
	return [self initWithType:type relatedView:nil rules:rules];
}



#pragma mark Short Syntax

+ (instancetype)rules:(NSArray *)rules {
    return [self to:nil rules:rules];
}

+ (instancetype)to:(UIView *)view rules:(NSArray *)rules {
    return [[self alloc] initWithType:[self classType] relatedView:view rules:rules];
}



#pragma mark Class-Specific

+ (KeepAttributeType)classType {
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Class KeepAttribute does not have implitit attribute type, use one of the subclasses" userInfo:nil];
}



#pragma mark Applying

- (void)applyInView:(UIView *)mainView {
    NSDictionary *constraintsByRule = [self generateConstraintsForView:mainView];
    
    for (NSLayoutConstraint *constraint in constraintsByRule.allValues) {
        UIView *relatedLayoutView = constraint.secondItem;
        UIView *commonView = (relatedLayoutView? [mainView commonAncestor:relatedLayoutView] : mainView);
        [commonView addConstraint:constraint];
    }
}

- (NSDictionary *)generateConstraintsForView:(UIView *)mainView {
    NSMutableDictionary *constraintsBuilder = [[NSMutableDictionary alloc] init];
    
    NSLayoutAttribute mainLayoutAttribute = [self mainLayoutAttribute];
    mainView.translatesAutoresizingMaskIntoConstraints = NO;
    NSAssert(mainView.superview, @"Must have superview");
    
    for (KeepRule *rule in self.rules) {
        UIView *relatedLayoutView = [self relatedLayoutViewForMainView:mainView rule:rule];
        if (relatedLayoutView == rule.relatedView) {
            relatedLayoutView.translatesAutoresizingMaskIntoConstraints = NO;
        }
        NSLayoutAttribute relatedLayoutAttribute = [self relatedLayoutAttributeForRule:rule];
        
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:mainView
                                                                      attribute:mainLayoutAttribute
                                                                      relatedBy:[self layoutRelationForRule:rule]
                                                                         toItem:relatedLayoutView
                                                                      attribute:relatedLayoutAttribute
                                                                     multiplier:[self layoutMultiplierForRule:rule]
                                                                       constant:[self layoutConstantForRule:rule]
                                          ];
        constraint.priority = rule.priority;
        
        [constraintsBuilder setObject:constraint forKey:rule];
    }
    return [constraintsBuilder copy];
}



#pragma mark Constraint Attribute Mapping

- (NSLayoutAttribute)mainLayoutAttribute {
    switch (self.type) {
        case KeepAttributeTypeWidth:        return NSLayoutAttributeWidth   ;
        case KeepAttributeTypeHeight:       return NSLayoutAttributeHeight  ;
        case KeepAttributeTypeAspectRatio:  return NSLayoutAttributeWidth   ;
        case KeepAttributeTypeTopInset:     return NSLayoutAttributeTop     ;
        case KeepAttributeTypeBottomInset:  return NSLayoutAttributeBottom  ;
        case KeepAttributeTypeLeftInset:    return NSLayoutAttributeLeft    ;
        case KeepAttributeTypeRightInset:   return NSLayoutAttributeRight   ;
        case KeepAttributeTypeHorizontally: return NSLayoutAttributeCenterX ;
        case KeepAttributeTypeVertically:   return NSLayoutAttributeCenterY ;
        case KeepAttributeTypeTopOffset:    return NSLayoutAttributeTop     ;
        case KeepAttributeTypeBottomOffset: return NSLayoutAttributeBottom  ;
        case KeepAttributeTypeLeftOffset:   return NSLayoutAttributeLeft    ;
        case KeepAttributeTypeRightOffset:  return NSLayoutAttributeRight   ;
        case KeepAttributeTypeAlignTop:     return NSLayoutAttributeTop     ;
        case KeepAttributeTypeAlignCenterX: return NSLayoutAttributeCenterX ;
        case KeepAttributeTypeAlignBottom:  return NSLayoutAttributeBottom  ;
        case KeepAttributeTypeAlignLeft:    return NSLayoutAttributeLeft    ;
        case KeepAttributeTypeAlignCenterY: return NSLayoutAttributeCenterY ;
        case KeepAttributeTypeAlignRight:   return NSLayoutAttributeRight   ;
        case KeepAttributeTypeAlignBaseline:return NSLayoutAttributeBaseline;
    }
}

- (UIView *)relatedLayoutViewForMainView:(UIView *)mainView rule:(KeepRule *)rule {
    switch (self.type) {
        case KeepAttributeTypeWidth:        return rule.relatedView     ; // Width supports related rules.
        case KeepAttributeTypeHeight:       return rule.relatedView     ; // Height supports related rules.
        case KeepAttributeTypeAspectRatio:  return mainView             ;
        case KeepAttributeTypeTopInset:     return mainView.superview   ;
        case KeepAttributeTypeBottomInset:  return mainView.superview   ;
        case KeepAttributeTypeLeftInset:    return mainView.superview   ;
        case KeepAttributeTypeRightInset:   return mainView.superview   ;
        case KeepAttributeTypeHorizontally: return mainView.superview   ;
        case KeepAttributeTypeVertically:   return mainView.superview   ;
        case KeepAttributeTypeTopOffset:    return self.relatedView     ;
        case KeepAttributeTypeBottomOffset: return self.relatedView     ;
        case KeepAttributeTypeLeftOffset:   return self.relatedView     ;
        case KeepAttributeTypeRightOffset:  return self.relatedView     ;
        case KeepAttributeTypeAlignTop:     return self.relatedView     ;
        case KeepAttributeTypeAlignCenterX: return self.relatedView     ;
        case KeepAttributeTypeAlignBottom:  return self.relatedView     ;
        case KeepAttributeTypeAlignLeft:    return self.relatedView     ;
        case KeepAttributeTypeAlignCenterY: return self.relatedView     ;
        case KeepAttributeTypeAlignRight:   return self.relatedView     ;
        case KeepAttributeTypeAlignBaseline:return self.relatedView     ;
    }
}

- (NSLayoutAttribute)relatedLayoutAttributeForRule:(KeepRule *)rule {
    switch (self.type) {
        case KeepAttributeTypeWidth:        return (rule.relatedView? NSLayoutAttributeWidth  : NSLayoutAttributeNotAnAttribute);
        case KeepAttributeTypeHeight:       return (rule.relatedView? NSLayoutAttributeHeight : NSLayoutAttributeNotAnAttribute);
        case KeepAttributeTypeAspectRatio:  return NSLayoutAttributeHeight  ; // Width to height.
        case KeepAttributeTypeTopInset:     return NSLayoutAttributeTop     ;
        case KeepAttributeTypeBottomInset:  return NSLayoutAttributeBottom  ;
        case KeepAttributeTypeLeftInset:    return NSLayoutAttributeLeft    ;
        case KeepAttributeTypeRightInset:   return NSLayoutAttributeRight   ;
        case KeepAttributeTypeHorizontally: return NSLayoutAttributeCenterX ;
        case KeepAttributeTypeVertically:   return NSLayoutAttributeCenterY ;
        case KeepAttributeTypeTopOffset:    return NSLayoutAttributeBottom  ; // My top to his bottom.
        case KeepAttributeTypeBottomOffset: return NSLayoutAttributeTop     ; // My bottom to his top.
        case KeepAttributeTypeLeftOffset:   return NSLayoutAttributeRight   ; // My left to his right.
        case KeepAttributeTypeRightOffset:  return NSLayoutAttributeLeft    ; // My right to his left.
        case KeepAttributeTypeAlignTop:     return NSLayoutAttributeTop     ;
        case KeepAttributeTypeAlignCenterX: return NSLayoutAttributeCenterX ;
        case KeepAttributeTypeAlignBottom:  return NSLayoutAttributeBottom  ;
        case KeepAttributeTypeAlignLeft:    return NSLayoutAttributeLeft    ;
        case KeepAttributeTypeAlignCenterY: return NSLayoutAttributeCenterY ;
        case KeepAttributeTypeAlignRight:   return NSLayoutAttributeRight   ;
        case KeepAttributeTypeAlignBaseline:return NSLayoutAttributeBaseline;
    }
}

- (BOOL)swapMaxMinLayoutRelation {
    // Some of the types need to have inverted maximum and mimimum rules.
    // For example BottomInset is inverted on Y axis, so maximum value means view bottom edge is less or equal than superview's bottom + 10.
    switch (self.type) {
        case KeepAttributeTypeWidth:        return NO ;
        case KeepAttributeTypeHeight:       return NO ;
        case KeepAttributeTypeAspectRatio:  return NO ;
        case KeepAttributeTypeTopInset:     return NO ;
        case KeepAttributeTypeBottomInset:  return YES;
        case KeepAttributeTypeLeftInset:    return NO ;
        case KeepAttributeTypeRightInset:   return YES;
        case KeepAttributeTypeHorizontally: return NO ;
        case KeepAttributeTypeVertically:   return NO ;
        case KeepAttributeTypeTopOffset:    return NO ;
        case KeepAttributeTypeBottomOffset: return YES;
        case KeepAttributeTypeLeftOffset:   return NO ;
        case KeepAttributeTypeRightOffset:  return YES;
        case KeepAttributeTypeAlignTop:     return NO ;
        case KeepAttributeTypeAlignCenterX: return NO ;
        case KeepAttributeTypeAlignBottom:  return NO ;
        case KeepAttributeTypeAlignLeft:    return NO ;
        case KeepAttributeTypeAlignCenterY: return NO ;
        case KeepAttributeTypeAlignRight:   return NO ;
        case KeepAttributeTypeAlignBaseline:return NO ;
    }
}

- (NSLayoutRelation)layoutRelationForRule:(KeepRule *)rule {
    BOOL swapMaxMin = [self swapMaxMinLayoutRelation];
    switch (rule.type) {
        case KeepRuleTypeEqual: return NSLayoutRelationEqual;
        case KeepRuleTypeMax:   return (swapMaxMin ? NSLayoutRelationGreaterThanOrEqual : NSLayoutRelationLessThanOrEqual   );
        case KeepRuleTypeMin:   return (swapMaxMin ? NSLayoutRelationLessThanOrEqual    : NSLayoutRelationGreaterThanOrEqual);
    }
}

- (CGFloat)layoutMultiplierForRule:(KeepRule *)rule {
    // Rule value may be interpreted different ways depending on attribute type.
    switch (self.type) {
        case KeepAttributeTypeWidth:        return (rule.relatedView? rule.value : 1); // Multiple of related view's width.
        case KeepAttributeTypeHeight:       return (rule.relatedView? rule.value : 1); // Multiple of related view's height.
        case KeepAttributeTypeAspectRatio:  return rule.value       ; // Rule specified the multiplier.
        case KeepAttributeTypeTopInset:     return 1                ;
        case KeepAttributeTypeBottomInset:  return 1                ;
        case KeepAttributeTypeLeftInset:    return 1                ;
        case KeepAttributeTypeRightInset:   return 1                ;
        case KeepAttributeTypeHorizontally: return rule.value * 2   ; // One in constraint multiplier mean 0.5 of the whole width.
        case KeepAttributeTypeVertically:   return rule.value * 2   ; // One in constraint multiplier mean 0.5 of the whole height.
        case KeepAttributeTypeTopOffset:    return 1                ;
        case KeepAttributeTypeBottomOffset: return 1                ;
        case KeepAttributeTypeLeftOffset:   return 1                ;
        case KeepAttributeTypeRightOffset:  return 1                ;
        case KeepAttributeTypeAlignTop:     return 1                ;
        case KeepAttributeTypeAlignCenterX: return 1                ;
        case KeepAttributeTypeAlignBottom:  return 1                ;
        case KeepAttributeTypeAlignLeft:    return 1                ;
        case KeepAttributeTypeAlignCenterY: return 1                ;
        case KeepAttributeTypeAlignRight:   return 1                ;
        case KeepAttributeTypeAlignBaseline:return 1                ;
    }
}

- (CGFloat)layoutConstantForRule:(KeepRule *)rule {
    switch (self.type) {
        case KeepAttributeTypeWidth:        return  (rule.relatedView? 0 : rule.value); // Multiple of related view's width.
        case KeepAttributeTypeHeight:       return  (rule.relatedView? 0 : rule.value); // Multiple of related view's height.
        case KeepAttributeTypeAspectRatio:  return  0           ; // No constant.
        case KeepAttributeTypeTopInset:     return  rule.value  ;
        case KeepAttributeTypeBottomInset:  return -rule.value  ; // Bottom inset is inverted on Y axis.
        case KeepAttributeTypeLeftInset:    return  rule.value  ;
        case KeepAttributeTypeRightInset:   return -rule.value  ; // Right inset is inverted on X axis.
        case KeepAttributeTypeHorizontally: return  0           ; // No constant.
        case KeepAttributeTypeVertically:   return  0           ; // No constant.
        case KeepAttributeTypeTopOffset:    return  rule.value  ;
        case KeepAttributeTypeBottomOffset: return -rule.value  ;
        case KeepAttributeTypeLeftOffset:   return  rule.value  ;
        case KeepAttributeTypeRightOffset:  return -rule.value  ;
        case KeepAttributeTypeAlignTop:     return  rule.value  ;
        case KeepAttributeTypeAlignCenterX: return  rule.value  ;
        case KeepAttributeTypeAlignBottom:  return  rule.value  ;
        case KeepAttributeTypeAlignLeft:    return  rule.value  ;
        case KeepAttributeTypeAlignCenterY: return  rule.value  ;
        case KeepAttributeTypeAlignRight:   return  rule.value  ;
        case KeepAttributeTypeAlignBaseline:return  rule.value  ;
    }
}



@end





@implementation KeepWidth           + (KeepAttributeType)classType { return KeepAttributeTypeWidth          ; }     @end
@implementation KeepHeight          + (KeepAttributeType)classType { return KeepAttributeTypeHeight         ; }     @end
@implementation KeepAspectRatio     + (KeepAttributeType)classType { return KeepAttributeTypeAspectRatio    ; }     @end
@implementation KeepTopInset        + (KeepAttributeType)classType { return KeepAttributeTypeTopInset       ; }     @end
@implementation KeepBottomInset     + (KeepAttributeType)classType { return KeepAttributeTypeBottomInset    ; }     @end
@implementation KeepLeftInset       + (KeepAttributeType)classType { return KeepAttributeTypeLeftInset      ; }     @end
@implementation KeepRightInset      + (KeepAttributeType)classType { return KeepAttributeTypeRightInset     ; }     @end
@implementation KeepHorizontally    + (KeepAttributeType)classType { return KeepAttributeTypeHorizontally   ; }     @end
@implementation KeepVertically      + (KeepAttributeType)classType { return KeepAttributeTypeVertically     ; }     @end
@implementation KeepTopOffset       + (KeepAttributeType)classType { return KeepAttributeTypeTopOffset      ; }     @end
@implementation KeepBottomOffset    + (KeepAttributeType)classType { return KeepAttributeTypeBottomOffset   ; }     @end
@implementation KeepLeftOffset      + (KeepAttributeType)classType { return KeepAttributeTypeLeftOffset     ; }     @end
@implementation KeepRightOffset     + (KeepAttributeType)classType { return KeepAttributeTypeRightOffset    ; }     @end
@implementation KeepAlignTop        + (KeepAttributeType)classType { return KeepAttributeTypeAlignTop       ; }     @end
@implementation KeepAlignCenterX    + (KeepAttributeType)classType { return KeepAttributeTypeAlignCenterX   ; }     @end
@implementation KeepAlignBottom     + (KeepAttributeType)classType { return KeepAttributeTypeAlignBottom    ; }     @end
@implementation KeepAlignLeft       + (KeepAttributeType)classType { return KeepAttributeTypeAlignLeft      ; }     @end
@implementation KeepAlignCenterY    + (KeepAttributeType)classType { return KeepAttributeTypeAlignCenterY   ; }     @end
@implementation KeepAlignRight      + (KeepAttributeType)classType { return KeepAttributeTypeAlignRight     ; }     @end
@implementation KeepAlignBaseline   + (KeepAttributeType)classType { return KeepAttributeTypeAlignBaseline  ; }     @end
