//
//  UIView+KeepLayout.m
//  Geografia
//
//  Created by Martin Kiss on 21.10.12.
//  Copyright (c) 2012 iMartin Kiss. All rights reserved.
//

#import "UIView+KeepLayout.h"
#import "KeepAttribute.h"
#import <objc/runtime.h>



@implementation UIView (KeepLayout)




- (KeepAttribute *)keep_getAttributeForSelector:(SEL)selector creationBlock:(KeepAttribute *(^)())creationBlock {
    KeepAttribute *attribute = objc_getAssociatedObject(self, selector);
    if ( ! attribute && creationBlock) {
        attribute = creationBlock();
        objc_setAssociatedObject(self, selector, attribute, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return attribute;
}

- (KeepAttribute *)keepWidth {
    return [self keep_getAttributeForSelector:_cmd creationBlock:^KeepAttribute *{
        return [[KeepSelfAttribute alloc] initWithView:self
                                       layoutAttribute:NSLayoutAttributeWidth];
    }];
}

- (KeepAttribute *)keepHeight {
    return [self keep_getAttributeForSelector:_cmd creationBlock:^KeepAttribute *{
        return [[KeepSelfAttribute alloc] initWithView:self
                                       layoutAttribute:NSLayoutAttributeHeight];
    }];
}

- (KeepAttribute *)keepLeftInset {
    return [self keep_getAttributeForSelector:_cmd creationBlock:^KeepAttribute *{
        return [[KeepSuperviewAttribute alloc] initWithView:self
                                            layoutAttribute:NSLayoutAttributeLeft
                                   superviewLayoutAttribute:NSLayoutAttributeLeft];
    }];
}

- (KeepAttribute *)keepRightInset {
    return [self keep_getAttributeForSelector:_cmd creationBlock:^KeepAttribute *{
        return [[KeepSuperviewAttribute alloc] initWithView:self
                                            layoutAttribute:NSLayoutAttributeRight
                                   superviewLayoutAttribute:NSLayoutAttributeRight
                                             invertRelation:YES];
    }];
}

- (KeepAttribute *)keepTopInset {
    return [self keep_getAttributeForSelector:_cmd creationBlock:^KeepAttribute *{
        return [[KeepSuperviewAttribute alloc] initWithView:self
                                            layoutAttribute:NSLayoutAttributeTop
                                   superviewLayoutAttribute:NSLayoutAttributeTop];
    }];
}

- (KeepAttribute *)keepBottomInset {
    return [self keep_getAttributeForSelector:_cmd creationBlock:^KeepAttribute *{
        return [[KeepSuperviewAttribute alloc] initWithView:self
                                            layoutAttribute:NSLayoutAttributeBottom
                                   superviewLayoutAttribute:NSLayoutAttributeBottom
                                             invertRelation:YES];
    }];
}

- (KeepAttribute *)keepAllInsets {
    return [self keep_getAttributeForSelector:_cmd creationBlock:^KeepAttribute *{
        return [[KeepGroupAttribute alloc] initWithAttributes:@[
                self.keepTopInset,
                self.keepBottomInset,
                self.keepLeftInset,
                self.keepRightInset ]];
    }];
}



- (UIView *)commonSuperview:(UIView *)anotherView {
    UIView *superview = self;
    while (superview) {
        if ([anotherView isDescendantOfView:superview]) {
            break; // The `superview` is common for both views.
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

- (void)removeConstraintFromCommonSuperview:(NSLayoutConstraint *)constraint {
    UIView *relatedLayoutView = constraint.secondItem;
    UIView *commonView = (relatedLayoutView? [self commonSuperview:relatedLayoutView] : self);
    [commonView removeConstraint:constraint];
}



- (void)addConstraintsToCommonSuperview:(id<NSFastEnumeration>)constraints {
    for (NSLayoutConstraint *constraint in constraints) {
        [self addConstraintToCommonSuperview:constraint];
    }
}

- (void)removeConstraintsFromCommonSuperview:(id<NSFastEnumeration>)constraints {
    for (NSLayoutConstraint *constraint in constraints) {
        [self removeConstraintFromCommonSuperview:constraint];
    }
}





@end
