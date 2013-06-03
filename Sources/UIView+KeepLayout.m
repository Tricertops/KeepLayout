//
//  UIView+KeepLayout.m
//  Geografia
//
//  Created by Martin Kiss on 21.10.12.
//  Copyright (c) 2012 iMartin Kiss. All rights reserved.
//

#import "UIView+KeepLayout.h"
#import "KeepAttribute.h"



@implementation UIView (KeepLayout)



- (void)keep:(KeepAttribute *)attribute {
    [attribute applyInView:self];
}

- (UIView *)commonSuperview:(UIView *)anotherView {
    UIView *superview = self;
    while (superview) {
        if ([anotherView isDescendantOfView:superview]) {
            break; // This view is common ancestor to both views.
        }
        superview = superview.superview;
    }
    return superview;
}

- (void)addConstraintToCommonSuperview:(NSLayoutConstraint *)constraint {
    UIView *relatedLayoutView = constraint.secondItem;
    UIView *commonView = (relatedLayoutView? [self commonSuperview:relatedLayoutView] : self);
    [commonView addConstraint:constraint];
}

- (void)addConstraintsToCommonSuperview:(id<NSFastEnumeration>)constraints {
    for (NSLayoutConstraint *constraint in constraints) {
        [self addConstraintToCommonSuperview:constraint];
    }
}

- (UIView *)commonAncestor:(UIView *)anotherView {
    return [self commonSuperview:anotherView];
}



@end
