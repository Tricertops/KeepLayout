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





#pragma mark Associations


- (KeepAttribute *)keep_getAttributeForSelector:(SEL)selector creationBlock:(KeepAttribute *(^)())creationBlock {
    NSParameterAssert(selector);
    
    KeepAttribute *attribute = objc_getAssociatedObject(self, selector);
    if ( ! attribute && creationBlock) {
        attribute = creationBlock();
        objc_setAssociatedObject(self, selector, attribute, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return attribute;
}


- (KeepAttribute *)keep_getAttributeForSelector:(SEL)selector relatedView:(UIView *)relatedView creationBlock:(KeepAttribute *(^)())creationBlock {
    NSParameterAssert(selector);
    NSParameterAssert(relatedView);
    
    NSMapTable *attributesByRelatedView = objc_getAssociatedObject(self, selector);
    if ( ! attributesByRelatedView) {
        attributesByRelatedView = [NSMapTable weakToStrongObjectsMapTable];
        objc_setAssociatedObject(self, selector, attributesByRelatedView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    KeepAttribute *attribute = [attributesByRelatedView objectForKey:relatedView];
    if ( ! attribute && creationBlock) {
        attribute = creationBlock();
        [attributesByRelatedView setObject:attribute forKey:relatedView];
    }
    return attribute;
}





#pragma mark Dimensions


- (KeepAttribute *)keepWidth {
    return [self keep_getAttributeForSelector:_cmd creationBlock:^KeepAttribute *{
        return [[[KeepConstantAttribute alloc] initWithView:self
                                            layoutAttribute:NSLayoutAttributeWidth
                                                relatedView:nil
                                     relatedLayoutAttribute:NSLayoutAttributeNotAnAttribute
                                                coefficient:1]
                name:@"width of <%@ %p>", self.class, self];
    }];
}


- (KeepAttribute *)keepHeight {
    return [self keep_getAttributeForSelector:_cmd creationBlock:^KeepAttribute *{
        return [[[KeepConstantAttribute alloc] initWithView:self
                                            layoutAttribute:NSLayoutAttributeHeight
                                                relatedView:nil
                                     relatedLayoutAttribute:NSLayoutAttributeNotAnAttribute
                                                coefficient:1]
                name:@"height of <%@ %p>", self.class, self];
    }];
}





#pragma mark Supreview Insets


- (KeepAttribute *)keepLeftInset {
    NSAssert(self.superview, @"Calling %@ allowed only when superview exists", NSStringFromSelector(_cmd));
    
    return [self keep_getAttributeForSelector:_cmd creationBlock:^KeepAttribute *{
        return [[[KeepConstantAttribute alloc] initWithView:self
                                           layoutAttribute:NSLayoutAttributeLeft
                                               relatedView:self.superview
                                    relatedLayoutAttribute:NSLayoutAttributeLeft
                                               coefficient:1]
                name:@"left inset of <%@ %p> to superview <%@ %p>", self.class, self, self.superview.class, self.superview];
    }];
}


- (KeepAttribute *)keepRightInset {
    NSAssert(self.superview, @"Calling %@ allowed only when superview exists", NSStringFromSelector(_cmd));
    
    return [self keep_getAttributeForSelector:_cmd creationBlock:^KeepAttribute *{
        return [[[KeepConstantAttribute alloc] initWithView:self
                                           layoutAttribute:NSLayoutAttributeRight
                                               relatedView:self.superview
                                    relatedLayoutAttribute:NSLayoutAttributeRight
                                               coefficient:-1]
                name:@"right inset of <%@ %p> to superview <%@ %p>", self.class, self, self.superview.class, self.superview];
    }];
}


- (KeepAttribute *)keepTopInset {
    NSAssert(self.superview, @"Calling %@ allowed only when superview exists", NSStringFromSelector(_cmd));
    
    return [self keep_getAttributeForSelector:_cmd creationBlock:^KeepAttribute *{
        return [[[KeepConstantAttribute alloc] initWithView:self
                                           layoutAttribute:NSLayoutAttributeTop
                                               relatedView:self.superview
                                    relatedLayoutAttribute:NSLayoutAttributeTop
                                               coefficient:1]
                name:@"top inset of <%@ %p> to superview <%@ %p>", self.class, self, self.superview.class, self.superview];
    }];
}


- (KeepAttribute *)keepBottomInset {
    NSAssert(self.superview, @"Calling %@ allowed only when superview exists", NSStringFromSelector(_cmd));
    
    return [self keep_getAttributeForSelector:_cmd creationBlock:^KeepAttribute *{
        return [[[KeepConstantAttribute alloc] initWithView:self
                                           layoutAttribute:NSLayoutAttributeBottom
                                               relatedView:self.superview
                                    relatedLayoutAttribute:NSLayoutAttributeBottom
                                               coefficient:-1]
                name:@"bottom inset of <%@ %p> to superview <%@ %p>", self.class, self, self.superview.class, self.superview];
    }];
}


- (KeepAttribute *)keepInsets {
    NSAssert(self.superview, @"Calling %@ allowed only when superview exists", NSStringFromSelector(_cmd));
    
    return [[[KeepGroupAttribute alloc] initWithAttributes:@[
            self.keepTopInset,
            self.keepBottomInset,
            self.keepLeftInset,
            self.keepRightInset ]]
            name:@"all insets of <%@ %p> to superview <%@ %p>", self.class, self, self.superview.class, self.superview];
}





#pragma mark Center


- (KeepAttribute *)keepHorizontalCenter {
    NSAssert(self.superview, @"Calling %@ allowed only when superview exists", NSStringFromSelector(_cmd));
    
    return [self keep_getAttributeForSelector:_cmd creationBlock:^KeepAttribute *{
        return [[[KeepMultiplierAttribute alloc] initWithView:self
                                             layoutAttribute:NSLayoutAttributeCenterX
                                                 relatedView:self.superview
                                      relatedLayoutAttribute:NSLayoutAttributeCenterX
                                                 coefficient:2]
                name:@"horizontal center of <%@ %p> in superview <%@ %p>", self.class, self, self.superview.class, self.superview];
    }];
}


- (KeepAttribute *)keepVerticalCenter {
    NSAssert(self.superview, @"Calling %@ allowed only when superview exists", NSStringFromSelector(_cmd));
    
    return [self keep_getAttributeForSelector:_cmd creationBlock:^KeepAttribute *{
        return [[[KeepMultiplierAttribute alloc] initWithView:self
                                             layoutAttribute:NSLayoutAttributeCenterY
                                                 relatedView:self.superview
                                      relatedLayoutAttribute:NSLayoutAttributeCenterY
                                                 coefficient:2]
                name:@"vertical center of <%@ %p> in superview <%@ %p>", self.class, self, self.superview.class, self.superview];
    }];
}


- (KeepAttribute *)keepCenter {    
    return [[[KeepGroupAttribute alloc] initWithAttributes:@[
            self.keepHorizontalCenter,
            self.keepVerticalCenter ]]
            name:@"center of <%@ %p> in superview <%@ %p>", self.class, self, self.superview.class, self.superview];
}





#pragma mark Offsets


- (KeepAttribute *(^)(UIView *))keepLeftOffset {
    return ^KeepAttribute *(UIView *view) {
        return [self keep_getAttributeForSelector:_cmd relatedView:view creationBlock:^KeepAttribute *{
            return [[[KeepConstantAttribute alloc] initWithView:self
                                                layoutAttribute:NSLayoutAttributeLeft
                                                    relatedView:view
                                         relatedLayoutAttribute:NSLayoutAttributeRight
                                                    coefficient:1]
                    name:@"left offset of <%@ %p> to <%@ %p>", self.class, self, view.class, view];
        }];
    };
}


- (KeepAttribute *(^)(UIView *))keepRightOffset {
    return ^KeepAttribute *(UIView *view) {
        return view.keepLeftOffset(self);
    };
}


- (KeepAttribute *(^)(UIView *))keepTopOffset {
    return ^KeepAttribute *(UIView *view) {
        return [self keep_getAttributeForSelector:_cmd relatedView:view creationBlock:^KeepAttribute *{
            return [[[KeepConstantAttribute alloc] initWithView:self
                                                layoutAttribute:NSLayoutAttributeTop
                                                    relatedView:view
                                         relatedLayoutAttribute:NSLayoutAttributeBottom
                                                    coefficient:1]
                    name:@"top offset of <%@ %p> to <%@ %p>", self.class, self, view.class, view];
        }];
    };
}


- (KeepAttribute *(^)(UIView *))keepBottomOffset {
    return ^KeepAttribute *(UIView *view) {
        return view.keepTopOffset(self);
    };
}





#pragma mark Common Superview


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





#pragma mark Convenience Auto Layout


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
