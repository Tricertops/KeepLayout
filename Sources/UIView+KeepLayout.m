//
//  UIView+KeepLayout.m
//  Geografia
//
//  Created by Martin Kiss on 21.10.12.
//  Copyright (c) 2012 iMartin Kiss. All rights reserved.
//

#import "UIView+KeepLayout.h"
#import "KeepTypes.h"

@implementation UIView (KeepLayout)


- (void)KeepAttributeType:(KeepAttributeType)attribute toView:(UIView *)view minimum:(CGFloat)minimum maximum:(CGFloat)maximum coeficient:(CGFloat)coeficient priority:(UILayoutPriority)priority {
    NSAssert(minimum <= maximum, @"Less is sometimes more?");
    NSAssert(self.superview, @"Lost without parent!");
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    BOOL constantRelation = (minimum == maximum);
    
    NSLayoutAttribute myAttribute = NSLayoutAttributeNotAnAttribute;
    switch (attribute) {
        case KeepAttributeTypeWidth:         myAttribute = NSLayoutAttributeWidth;   break;
        case KeepAttributeTypeHeight:        myAttribute = NSLayoutAttributeHeight;  break;
        case KeepAttributeTypeAspectRatio:   myAttribute = NSLayoutAttributeWidth;   break;
        case KeepAttributeTypeLeftInset:     myAttribute = NSLayoutAttributeLeft;    break;
        case KeepAttributeTypeRightInset:    myAttribute = NSLayoutAttributeRight;   break;
        case KeepAttributeTypeTopInset:      myAttribute = NSLayoutAttributeTop;     break;
        case KeepAttributeTypeBottomInset:   myAttribute = NSLayoutAttributeBottom;  break;
    }
    
    UIView *relatedView = nil;
    switch (attribute) {
        case KeepAttributeTypeWidth:         relatedView = nil;              break;
        case KeepAttributeTypeHeight:        relatedView = nil;              break;
        case KeepAttributeTypeAspectRatio:   relatedView = self;             break;
        case KeepAttributeTypeLeftInset:     relatedView = self.superview;   break;
        case KeepAttributeTypeRightInset:    relatedView = self.superview;   break;
        case KeepAttributeTypeTopInset:      relatedView = self.superview;   break;
        case KeepAttributeTypeBottomInset:   relatedView = self.superview;   break;
    }
    
    NSLayoutAttribute relatedAttribute = NSLayoutAttributeNotAnAttribute;
    switch (attribute) {
        case KeepAttributeTypeWidth:         relatedAttribute = NSLayoutAttributeNotAnAttribute; break;
        case KeepAttributeTypeHeight:        relatedAttribute = NSLayoutAttributeNotAnAttribute; break;
        case KeepAttributeTypeAspectRatio:   relatedAttribute = NSLayoutAttributeHeight;         break;
        case KeepAttributeTypeLeftInset:     relatedAttribute = NSLayoutAttributeLeft;           break;
        case KeepAttributeTypeRightInset:    relatedAttribute = NSLayoutAttributeRight;          break;
        case KeepAttributeTypeTopInset:      relatedAttribute = NSLayoutAttributeTop;            break;
        case KeepAttributeTypeBottomInset:   relatedAttribute = NSLayoutAttributeBottom;         break;
    }
    
    CGFloat multiplierExponent = 0; // x^0 is always 1
    switch (attribute) {
        case KeepAttributeTypeWidth:         multiplierExponent = 0;     break;
        case KeepAttributeTypeHeight:        multiplierExponent = 0;     break;
        case KeepAttributeTypeAspectRatio:   multiplierExponent = 1;     break;
        case KeepAttributeTypeLeftInset:     multiplierExponent = 0;     break;
        case KeepAttributeTypeRightInset:    multiplierExponent = 0;     break;
        case KeepAttributeTypeTopInset:      multiplierExponent = 0;     break;
        case KeepAttributeTypeBottomInset:   multiplierExponent = 0;     break;
    }
    
    CGFloat constantMultiplier = 1; // x*1 is always x
    switch (attribute) {
        case KeepAttributeTypeWidth:         constantMultiplier =  1;    break;
        case KeepAttributeTypeHeight:        constantMultiplier =  1;    break;
        case KeepAttributeTypeAspectRatio:   constantMultiplier =  0;    break;
        case KeepAttributeTypeLeftInset:     constantMultiplier =  1;    break;
        case KeepAttributeTypeRightInset:    constantMultiplier = -1;    break; // reversed direction
        case KeepAttributeTypeTopInset:      constantMultiplier =  1;    break;
        case KeepAttributeTypeBottomInset:   constantMultiplier = -1;    break; // reversed direction
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
