//
//  UIView+KeepLayout.m
//  Geografia
//
//  Created by Martin Kiss on 21.10.12.
//  Copyright (c) 2012 iMartin Kiss. All rights reserved.
//

#import "UIView+KeepLayout.h"

@implementation UIView (KeepLayout)

                                                                                                                    \

#define METHOD_IMPLEMENTATION_FOR(__ATTR__) \
- (void)keep##__ATTR__:(CGFloat)constant { [self keep##__ATTR__##Minimum:constant maximum:constant]; } \
- (void)keep##__ATTR__##Minimum:(CGFloat)minimum { [self keep##__ATTR__##Minimum:minimum maximum:INFINITY]; } \
- (void)keep##__ATTR__##Maximum:(CGFloat)maximum { [self keep##__ATTR__##Minimum:0 maximum:maximum]; } \
- (void)keep##__ATTR__##Minimum:(CGFloat)minimum maximum:(CGFloat)maximum { \
[self keepAttribute:kViewLayoutAttribute##__ATTR__ toView:nil minimum:minimum maximum:maximum coeficient:1 priority:UILayoutPriorityRequired]; \
} \


METHOD_IMPLEMENTATION_FOR(Width)
METHOD_IMPLEMENTATION_FOR(Height)
METHOD_IMPLEMENTATION_FOR(AspectRatio)

METHOD_IMPLEMENTATION_FOR(LeftInset)
METHOD_IMPLEMENTATION_FOR(RightInset)
METHOD_IMPLEMENTATION_FOR(TopInset)
METHOD_IMPLEMENTATION_FOR(BottomInset)

- (void)keepInsets:(UIEdgeInsets)insets {
    [self keepTopInset:insets.top];
    [self keepBottomInset:insets.bottom];
    [self keepRightInset:insets.right];
    [self keepLeftInset:insets.left];
}

- (void)keepHorizontally:(CGFloat)coeficient {
    [self keepAttribute:kViewLayoutAttributeHorizontal toView:self.superview minimum:0 maximum:0 coeficient:coeficient priority:UILayoutPriorityRequired];
}

- (void)keepVertically:(CGFloat)coeficient {
    [self keepAttribute:kViewLayoutAttributeVertical toView:self.superview minimum:0 maximum:0 coeficient:coeficient priority:UILayoutPriorityRequired];
}


- (void)keepAttribute:(kViewLayoutAttribute)attribute toView:(UIView *)view minimum:(CGFloat)minimum maximum:(CGFloat)maximum coeficient:(CGFloat)coeficient priority:(UILayoutPriority)priority {
    NSAssert(minimum <= maximum, @"Less is sometimes more?");
    NSAssert(self.superview, @"Lost without parent!");
    NSAssert(attribute != kViewLayoutAttributeHorizontal, @"Auto Layout doesn't like this kind of constraint, maybe it is just a bug?");
    NSAssert(attribute != kViewLayoutAttributeVertical, @"Auto Layout doesn't like this kind of constraint, maybe it is just a bug?");
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    BOOL constantRelation = (minimum == maximum);
    
    NSLayoutAttribute myAttribute = NSLayoutAttributeNotAnAttribute;
    switch (attribute) {
        case kViewLayoutAttributeWidth:         myAttribute = NSLayoutAttributeWidth;   break;
        case kViewLayoutAttributeHeight:        myAttribute = NSLayoutAttributeHeight;  break;
        case kViewLayoutAttributeAspectRatio:   myAttribute = NSLayoutAttributeWidth;   break;
        case kViewLayoutAttributeLeftInset:     myAttribute = NSLayoutAttributeLeft;    break;
        case kViewLayoutAttributeRightInset:    myAttribute = NSLayoutAttributeRight;   break;
        case kViewLayoutAttributeTopInset:      myAttribute = NSLayoutAttributeTop;     break;
        case kViewLayoutAttributeBottomInset:   myAttribute = NSLayoutAttributeBottom;  break;
        case kViewLayoutAttributeHorizontal:    myAttribute = NSLayoutAttributeCenterX; break;
        case kViewLayoutAttributeVertical:      myAttribute = NSLayoutAttributeCenterY; break;
    }
    
    UIView *relatedView = nil;
    switch (attribute) {
        case kViewLayoutAttributeWidth:         relatedView = nil;              break;
        case kViewLayoutAttributeHeight:        relatedView = nil;              break;
        case kViewLayoutAttributeAspectRatio:   relatedView = self;             break;
        case kViewLayoutAttributeLeftInset:     relatedView = self.superview;   break;
        case kViewLayoutAttributeRightInset:    relatedView = self.superview;   break;
        case kViewLayoutAttributeTopInset:      relatedView = self.superview;   break;
        case kViewLayoutAttributeBottomInset:   relatedView = self.superview;   break;
        case kViewLayoutAttributeHorizontal:    relatedView = self.superview;   break;
        case kViewLayoutAttributeVertical:      relatedView = self.superview;   break;
    }
    
    NSLayoutAttribute relatedAttribute = NSLayoutAttributeNotAnAttribute;
    switch (attribute) {
        case kViewLayoutAttributeWidth:         relatedAttribute = NSLayoutAttributeNotAnAttribute; break;
        case kViewLayoutAttributeHeight:        relatedAttribute = NSLayoutAttributeNotAnAttribute; break;
        case kViewLayoutAttributeAspectRatio:   relatedAttribute = NSLayoutAttributeHeight;         break;
        case kViewLayoutAttributeLeftInset:     relatedAttribute = NSLayoutAttributeLeft;           break;
        case kViewLayoutAttributeRightInset:    relatedAttribute = NSLayoutAttributeRight;          break;
        case kViewLayoutAttributeTopInset:      relatedAttribute = NSLayoutAttributeTop;            break;
        case kViewLayoutAttributeBottomInset:   relatedAttribute = NSLayoutAttributeBottom;         break;
        case kViewLayoutAttributeHorizontal:    relatedAttribute = NSLayoutAttributeWidth;          break;
        case kViewLayoutAttributeVertical:      relatedAttribute = NSLayoutAttributeHeight;         break;
    }
    
    CGFloat multiplierExponent = 0; // x^0 is always 1
    switch (attribute) {
        case kViewLayoutAttributeWidth:         multiplierExponent = 0;     break;
        case kViewLayoutAttributeHeight:        multiplierExponent = 0;     break;
        case kViewLayoutAttributeAspectRatio:   multiplierExponent = 1;     break;
        case kViewLayoutAttributeLeftInset:     multiplierExponent = 0;     break;
        case kViewLayoutAttributeRightInset:    multiplierExponent = 0;     break;
        case kViewLayoutAttributeTopInset:      multiplierExponent = 0;     break;
        case kViewLayoutAttributeBottomInset:   multiplierExponent = 0;     break;
        case kViewLayoutAttributeHorizontal:    multiplierExponent = 1;     break;
        case kViewLayoutAttributeVertical:      multiplierExponent = 1;     break;
    }
    
    CGFloat constantMultiplier = 1; // x*1 is always x
    switch (attribute) {
        case kViewLayoutAttributeWidth:         constantMultiplier =  1;    break;
        case kViewLayoutAttributeHeight:        constantMultiplier =  1;    break;
        case kViewLayoutAttributeAspectRatio:   constantMultiplier =  0;    break;
        case kViewLayoutAttributeLeftInset:     constantMultiplier =  1;    break;
        case kViewLayoutAttributeRightInset:    constantMultiplier = -1;    break; // reversed direction
        case kViewLayoutAttributeTopInset:      constantMultiplier =  1;    break;
        case kViewLayoutAttributeBottomInset:   constantMultiplier = -1;    break; // reversed direction
        case kViewLayoutAttributeHorizontal:    constantMultiplier =  0;    break;
        case kViewLayoutAttributeVertical:      constantMultiplier =  0;    break;
    }
    
    UIView *ancestor = [self commonAncestor:relatedView];
    if ( ! relatedView) {
        ancestor = self; // in case this is not 2-views relation
    }
    
    if (constantRelation) {
        CGFloat value = minimum;
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self
                                                                      attribute:myAttribute
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:relatedView
                                                                      attribute:relatedAttribute
                                                                     multiplier: powf(coeficient, multiplierExponent)
                                                                       constant: constantMultiplier * value] // equals maximum
        ;
        constraint.priority = priority;
        [ancestor addConstraint:constraint];
    }
    else {
		if (minimum != INFINITY) {
			NSLayoutConstraint *minimumConstraint = [NSLayoutConstraint constraintWithItem:self
																				 attribute:myAttribute
																				 relatedBy:NSLayoutRelationGreaterThanOrEqual
																					toItem:relatedView
																				 attribute:relatedAttribute
																				multiplier: powf(minimum, multiplierExponent)
																				  constant: constantMultiplier * minimum]
			;
			minimumConstraint.priority = priority;
			[ancestor addConstraint:minimumConstraint];
		}
        if (maximum != INFINITY) {
			NSLayoutConstraint *maximumConstraint = [NSLayoutConstraint constraintWithItem:self
																				 attribute:myAttribute
																				 relatedBy:NSLayoutRelationLessThanOrEqual
																					toItem:relatedView
																				 attribute:relatedAttribute
																				multiplier: powf(maximum, multiplierExponent)
																				  constant: constantMultiplier * maximum] // equals maximum
			;
			maximumConstraint.priority = priority;
			[ancestor addConstraint:maximumConstraint];
		}
    }
}

- (UIView *)commonAncestor:(UIView *)anotherView {
    UIView *ancestor = self;
    while (ancestor) {
        if ([anotherView isDescendantOfView:ancestor]) {
            break; // this ancestor is common to both views
        }
        ancestor = ancestor.superview;
    }
    return ancestor;
}



@end
