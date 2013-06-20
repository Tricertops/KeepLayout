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
        return [[KeepConstantAttribute alloc] initWithView:self
                                           layoutAttribute:NSLayoutAttributeWidth
                                               relatedView:nil
                                    relatedLayoutAttribute:NSLayoutAttributeNotAnAttribute
                                               coefficient:1];
    }];
}

- (KeepAttribute *)keepHeight {
    return [self keep_getAttributeForSelector:_cmd creationBlock:^KeepAttribute *{
        return [[KeepConstantAttribute alloc] initWithView:self
                                           layoutAttribute:NSLayoutAttributeHeight
                                               relatedView:nil
                                    relatedLayoutAttribute:NSLayoutAttributeNotAnAttribute
                                               coefficient:1];
    }];
}

- (KeepAttribute *)keepLeftInset {
    NSAssert(self.superview, @"Calling %@ allowed only when superview exists", NSStringFromSelector(_cmd));
    
    return [self keep_getAttributeForSelector:_cmd creationBlock:^KeepAttribute *{
        return [[KeepConstantAttribute alloc] initWithView:self
                                           layoutAttribute:NSLayoutAttributeLeft
                                               relatedView:self.superview
                                    relatedLayoutAttribute:NSLayoutAttributeLeft
                                               coefficient:1];
    }];
}

- (KeepAttribute *)keepRightInset {
    NSAssert(self.superview, @"Calling %@ allowed only when superview exists", NSStringFromSelector(_cmd));
    
    return [self keep_getAttributeForSelector:_cmd creationBlock:^KeepAttribute *{
        return [[KeepConstantAttribute alloc] initWithView:self
                                           layoutAttribute:NSLayoutAttributeRight
                                               relatedView:self.superview
                                    relatedLayoutAttribute:NSLayoutAttributeRight
                                               coefficient:-1];
    }];
}

- (KeepAttribute *)keepTopInset {
    NSAssert(self.superview, @"Calling %@ allowed only when superview exists", NSStringFromSelector(_cmd));
    
    return [self keep_getAttributeForSelector:_cmd creationBlock:^KeepAttribute *{
        return [[KeepConstantAttribute alloc] initWithView:self
                                           layoutAttribute:NSLayoutAttributeTop
                                               relatedView:self.superview
                                    relatedLayoutAttribute:NSLayoutAttributeTop
                                               coefficient:1];
    }];
}

- (KeepAttribute *)keepBottomInset {
    NSAssert(self.superview, @"Calling %@ allowed only when superview exists", NSStringFromSelector(_cmd));
    
    return [self keep_getAttributeForSelector:_cmd creationBlock:^KeepAttribute *{
        return [[KeepConstantAttribute alloc] initWithView:self
                                           layoutAttribute:NSLayoutAttributeBottom
                                               relatedView:self.superview
                                    relatedLayoutAttribute:NSLayoutAttributeBottom
                                               coefficient:-1];
    }];
}

- (KeepAttribute *)keepInsets {
    return [[KeepGroupAttribute alloc] initWithAttributes:@[
            self.keepTopInset,
            self.keepBottomInset,
            self.keepLeftInset,
            self.keepRightInset ]];
}

- (KeepAttribute *)keepHorizontalCenter {
    NSAssert(self.superview, @"Calling %@ allowed only when superview exists", NSStringFromSelector(_cmd));
    
    return [self keep_getAttributeForSelector:_cmd creationBlock:^KeepAttribute *{
        return [[KeepMultiplierAttribute alloc] initWithView:self
                                             layoutAttribute:NSLayoutAttributeCenterX
                                                 relatedView:self.superview
                                      relatedLayoutAttribute:NSLayoutAttributeCenterX
                                                 coefficient:2];
    }];
}

- (KeepAttribute *)keepVerticalCenter {
    NSAssert(self.superview, @"Calling %@ allowed only when superview exists", NSStringFromSelector(_cmd));
    
    return [self keep_getAttributeForSelector:_cmd creationBlock:^KeepAttribute *{
        return [[KeepMultiplierAttribute alloc] initWithView:self
                                             layoutAttribute:NSLayoutAttributeCenterY
                                                 relatedView:self.superview
                                      relatedLayoutAttribute:NSLayoutAttributeCenterY
                                                 coefficient:2];
    }];
}

- (KeepAttribute *)keepCenter {
    return [[KeepGroupAttribute alloc] initWithAttributes:@[
            self.keepHorizontalCenter,
            self.keepVerticalCenter ]];
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
