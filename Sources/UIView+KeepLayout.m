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


- (KeepAttribute *(^)(UIView *))keep_offsetForSelector:(SEL)selector from:(NSLayoutAttribute)fromAttribute to:(NSLayoutAttribute)toAttribute name:(NSString *)name {
    return ^KeepAttribute *(UIView *view) {
        KeepAssert([self commonSuperview:view], @"%@ requires both views to be in common hierarchy", NSStringFromSelector(selector));
        
        return [self keep_getAttributeForSelector:selector relatedView:view creationBlock:^KeepAttribute *{
            return [[[KeepConstantAttribute alloc] initWithView:self
                                                layoutAttribute:fromAttribute
                                                    relatedView:view
                                         relatedLayoutAttribute:toAttribute
                                                    coefficient:1]
                    name:@"%@ offset of <%@ %p> to <%@ %p>", name, self.class, self, view.class, view];
        }];
    };
}


- (KeepAttribute *(^)(UIView *))keepLeftOffset {
    return [self keep_offsetForSelector:_cmd from:NSLayoutAttributeLeft to:NSLayoutAttributeRight name:@"left"];
}


- (KeepAttribute *(^)(UIView *))keepRightOffset {
    return ^KeepAttribute *(UIView *view) {
        return view.keepLeftOffset(self);
    };
}


- (KeepAttribute *(^)(UIView *))keepTopOffset {
    return [self keep_offsetForSelector:_cmd from:NSLayoutAttributeTop to:NSLayoutAttributeBottom name:@"top"];
}


- (KeepAttribute *(^)(UIView *))keepBottomOffset {
    return ^KeepAttribute *(UIView *view) {
        return view.keepTopOffset(self);
    };
}





#pragma mark Alignments


- (KeepAttribute *(^)(UIView *))keep_alignForSelector:(SEL)selector constraintAttribute:(NSLayoutAttribute)constraintAttribute coefficient:(CGFloat)coefficient name:(NSString *)name {
    return ^KeepAttribute *(UIView *view) {
        KeepAssert([self commonSuperview:view], @"%@ requires both views to be in common hierarchy", NSStringFromSelector(selector));
        
        return [self keep_getAttributeForSelector:selector relatedView:view creationBlock:^KeepAttribute *{
            KeepAttribute *attribute =  [[[KeepConstantAttribute alloc] initWithView:self
                                                                     layoutAttribute:constraintAttribute
                                                                         relatedView:view
                                                              relatedLayoutAttribute:constraintAttribute
                                                                         coefficient:coefficient]
                                         name:@"%@ alignment of <%@ %p> to <%@ %p>", name, self.class, self, view.class, view];
            attribute.equal = KeepRequired(0); // Default
            // Establish inverse attribute
            [view keep_getAttributeForSelector:selector relatedView:self creationBlock:^KeepAttribute *{
                return attribute;
            }];
            return attribute;
        }];
    };
}


- (KeepAttribute *(^)(UIView *))keepLeftAlign {
    return [self keep_alignForSelector:_cmd constraintAttribute:NSLayoutAttributeLeft coefficient:1 name:@"left"];
}


- (KeepAttribute *(^)(UIView *))keepRightAlign {
    return [self keep_alignForSelector:_cmd constraintAttribute:NSLayoutAttributeRight coefficient:-1 name:@"right"];
}


- (KeepAttribute *(^)(UIView *))keepTopAlign {
    return [self keep_alignForSelector:_cmd constraintAttribute:NSLayoutAttributeTop coefficient:1 name:@"top"];
}


- (KeepAttribute *(^)(UIView *))keepBottomAlign {
    return [self keep_alignForSelector:_cmd constraintAttribute:NSLayoutAttributeBottom coefficient:-1 name:@"bottom"];
}


- (KeepAttribute *(^)(UIView *))keepVerticalAlign {
    return [self keep_alignForSelector:_cmd constraintAttribute:NSLayoutAttributeCenterX coefficient:1 name:@"vertical center"];
}


- (KeepAttribute *(^)(UIView *))keepHorizontalAlign {
    return [self keep_alignForSelector:_cmd constraintAttribute:NSLayoutAttributeCenterY coefficient:1 name:@"horizontal center"];
}


- (KeepAttribute *(^)(UIView *))keepBaselineAlign {
    return [self keep_alignForSelector:_cmd constraintAttribute:NSLayoutAttributeBaseline coefficient:-1 name:@"baseline"];
}





#pragma mark Animating Constraints


- (void)keepAnimatedWithDuration:(NSTimeInterval)duration layout:(void(^)(void))animations {
    [self keepAnimatedWithDuration:duration delay:0 options:kNilOptions layout:animations completion:nil];
}


- (void)keepAnimatedWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay layout:(void(^)(void))animations {
    [self keepAnimatedWithDuration:duration delay:delay options:kNilOptions layout:animations completion:nil];
}


- (void)keepAnimatedWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay options:(UIViewAnimationOptions)options layout:(void(^)(void))animations completion:(void(^)(BOOL finished))completion {
    [[NSOperationQueue mainQueue] performSelector:@selector(addOperationWithBlock:)
                                       withObject:^{
                                           [UIView animateWithDuration:duration
                                                                 delay:0
                                                               options:options
                                                            animations:^{
                                                                animations();
                                                                [self layoutIfNeeded];
                                                            }
                                                            completion:completion];
                                       }
                                       afterDelay:delay];
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
