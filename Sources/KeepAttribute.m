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
@property (nonatomic, readwrite, copy) NSArray *rules;

+ (KeepAttributeType)classType;

@end




@implementation KeepAttribute



#pragma mark Initialization

- (id)initWithType:(KeepAttributeType)type rules:(NSArray *)rules {
	self = [super init];
	if (self) {
		self.type = type;
        self.rules = rules;
	}
	return self;
}

+ (KeepAttributeType)classType {
    @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Class KeepAttribute does not have implitit attribute type, use one of the subclasses" userInfo:nil];
}

+ (instancetype)rules:(NSArray *)rules {
    return [[self alloc] initWithType:[self classType] rules:rules];
}

- (void)applyInView:(UIView *)mainView {
    NSLayoutAttribute mainLayoutAttribute = [self mainLayoutAttribute];
    UIView *relatedLayoutView = [self relatedLayoutViewForMainView:mainView];
    NSLayoutAttribute relatedLayoutAttribute = [self relatedLayoutAttribute];
    
    mainView.translatesAutoresizingMaskIntoConstraints = NO;
    relatedLayoutView.translatesAutoresizingMaskIntoConstraints = NO;
    NSAssert(mainView.superview, @"Must have superview");
    
    for (KeepRule *rule in self.rules) {
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:mainView
                                                                      attribute:mainLayoutAttribute
                                                                      relatedBy:[self layoutRelationForRule:rule]
                                                                         toItem:relatedLayoutView
                                                                      attribute:relatedLayoutAttribute
                                                                     multiplier:[self layoutMultiplierForRule:rule]
                                                                       constant:[self layoutConstantForRule:rule]];
        constraint.priority = rule.priority;
        UIView *commonView = (relatedLayoutView? [mainView commonAncestor:relatedLayoutView] : mainView);
        NSLog(@"KeepLayout: Adding constraint %@", constraint);
        [commonView addConstraint:constraint];
    }
}

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
    }
}

- (UIView *)relatedLayoutViewForMainView:(UIView *)mainView {
    switch (self.type) {
        case KeepAttributeTypeWidth:        return nil                  ;
        case KeepAttributeTypeHeight:       return nil                  ;
        case KeepAttributeTypeAspectRatio:  return mainView             ;
        case KeepAttributeTypeTopInset:     return mainView.superview   ;
        case KeepAttributeTypeBottomInset:  return mainView.superview   ;
        case KeepAttributeTypeLeftInset:    return mainView.superview   ;
        case KeepAttributeTypeRightInset:   return mainView.superview   ;
        case KeepAttributeTypeHorizontally: return mainView.superview   ;
        case KeepAttributeTypeVertically:   return mainView.superview   ;
    }
}

- (NSLayoutAttribute)relatedLayoutAttribute {
    switch (self.type) {
        case KeepAttributeTypeWidth:        return NSLayoutAttributeNotAnAttribute  ;
        case KeepAttributeTypeHeight:       return NSLayoutAttributeNotAnAttribute  ;
        case KeepAttributeTypeAspectRatio:  return NSLayoutAttributeHeight          ;
        case KeepAttributeTypeTopInset:     return NSLayoutAttributeTop             ;
        case KeepAttributeTypeBottomInset:  return NSLayoutAttributeBottom          ;
        case KeepAttributeTypeLeftInset:    return NSLayoutAttributeLeft            ;
        case KeepAttributeTypeRightInset:   return NSLayoutAttributeRight           ;
        case KeepAttributeTypeHorizontally: return NSLayoutAttributeCenterX         ;
        case KeepAttributeTypeVertically:   return NSLayoutAttributeCenterY         ;
    }
}

- (BOOL)swapMaxMinLayoutRelation {
    switch (self.type) {
        case KeepAttributeTypeWidth:        return NO ;
        case KeepAttributeTypeHeight:       return NO ;
        case KeepAttributeTypeAspectRatio:  return YES;
        case KeepAttributeTypeTopInset:     return YES;
        case KeepAttributeTypeBottomInset:  return NO ;
        case KeepAttributeTypeLeftInset:    return YES;
        case KeepAttributeTypeRightInset:   return NO ;
        case KeepAttributeTypeHorizontally: return YES;
        case KeepAttributeTypeVertically:   return YES;
    }
}

- (NSLayoutRelation)layoutRelationForRule:(KeepRule *)rule {
    BOOL swapMaxMin = [self swapMaxMinLayoutRelation];
    switch (rule.type) {
        case KeepRuleTypeEqual: return NSLayoutRelationEqual;
        case KeepRuleTypeMax:   return (swapMaxMin ? NSLayoutRelationLessThanOrEqual    : NSLayoutRelationGreaterThanOrEqual);
        case KeepRuleTypeMin:   return (swapMaxMin ? NSLayoutRelationGreaterThanOrEqual : NSLayoutRelationLessThanOrEqual   );
    }
}

- (CGFloat)layoutMultiplierForRule:(KeepRule *)rule {
    switch (self.type) {
        case KeepAttributeTypeWidth:        return 1                ;
        case KeepAttributeTypeHeight:       return 1                ;
        case KeepAttributeTypeAspectRatio:  return rule.value       ;
        case KeepAttributeTypeTopInset:     return 1                ;
        case KeepAttributeTypeBottomInset:  return 1                ;
        case KeepAttributeTypeLeftInset:    return 1                ;
        case KeepAttributeTypeRightInset:   return 1                ;
        case KeepAttributeTypeHorizontally: return rule.value * 2   ;
        case KeepAttributeTypeVertically:   return rule.value * 2   ;
    }
}

- (CGFloat)layoutConstantForRule:(KeepRule *)rule {
    switch (self.type) {
        case KeepAttributeTypeWidth:        return  rule.value  ;
        case KeepAttributeTypeHeight:       return  rule.value  ;
        case KeepAttributeTypeAspectRatio:  return  0           ;
        case KeepAttributeTypeTopInset:     return  rule.value  ;
        case KeepAttributeTypeBottomInset:  return -rule.value  ;
        case KeepAttributeTypeLeftInset:    return  rule.value  ;
        case KeepAttributeTypeRightInset:   return -rule.value  ;
        case KeepAttributeTypeHorizontally: return  0           ;
        case KeepAttributeTypeVertically:   return  0           ;
    }
}



@end





@implementation KeepWidth            + (KeepAttributeType)classType { return KeepAttributeTypeWidth         ; }     @end
@implementation KeepHeight           + (KeepAttributeType)classType { return KeepAttributeTypeHeight        ; }     @end
@implementation KeepAspectRatio      + (KeepAttributeType)classType { return KeepAttributeTypeAspectRatio   ; }     @end
@implementation KeepTopInset         + (KeepAttributeType)classType { return KeepAttributeTypeTopInset      ; }     @end
@implementation KeepBottomInset      + (KeepAttributeType)classType { return KeepAttributeTypeBottomInset   ; }     @end
@implementation KeepLeftInset        + (KeepAttributeType)classType { return KeepAttributeTypeLeftInset     ; }     @end
@implementation KeepRightInset       + (KeepAttributeType)classType { return KeepAttributeTypeRightInset    ; }     @end
@implementation KeepHorizontally     + (KeepAttributeType)classType { return KeepAttributeTypeHorizontally  ; }     @end
@implementation KeepVertically       + (KeepAttributeType)classType { return KeepAttributeTypeVertically    ; }     @end
