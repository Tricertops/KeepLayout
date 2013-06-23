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


- (KeepAttribute *)keep_attributeForSelector:(SEL)selector creationBlock:(KeepAttribute *(^)(void))creationBlock {
    NSParameterAssert(selector);
    
    KeepAttribute *attribute = objc_getAssociatedObject(self, selector);
    if ( ! attribute && creationBlock) {
        attribute = creationBlock();
        objc_setAssociatedObject(self, selector, attribute, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return attribute;
}


- (KeepAttribute *)keep_attributeForSelector:(SEL)selector relatedView:(UIView *)relatedView creationBlock:(KeepAttribute *(^)())creationBlock {
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


- (KeepAttribute *)keep_dimensionForSelector:(SEL)selector dimensionAttribute:(NSLayoutAttribute)dimensionAttribute name:(NSString *)name {
    return [self keep_attributeForSelector:selector creationBlock:^KeepAttribute *{
        KeepAttribute *attribute = [[[KeepConstantAttribute alloc] initWithView:self
                                                                layoutAttribute:dimensionAttribute
                                                                    relatedView:nil
                                                         relatedLayoutAttribute:NSLayoutAttributeNotAnAttribute
                                                                    coefficient:1]
                                    name:@"%@ of <%@ %p>", name, self.class, self];
        return attribute;
    }];
}


- (KeepAttribute *)keep_dimensionForSelector:(SEL)selector dimensionAttribute:(NSLayoutAttribute)dimensionAttribute relatedView:(UIView *)relatedView name:(NSString *)name {
    KeepAssert([self commonSuperview:relatedView], @"%@ requires both views to be in common hierarchy", NSStringFromSelector(selector));
    
    return [self keep_attributeForSelector:selector relatedView:relatedView creationBlock:^KeepAttribute *{
        KeepAttribute *attribute = [[KeepMultiplierAttribute alloc] initWithView:self
                                                                 layoutAttribute:dimensionAttribute
                                                                     relatedView:relatedView
                                                          relatedLayoutAttribute:dimensionAttribute
                                                                     coefficient:1];
        [attribute name:@"%@ of <%@ %p> to <%@ %p>", name, self.class, self, relatedView.class, relatedView];
        attribute.equal = KeepRequired(1); // Default
        // Establish inverse relation
        [relatedView keep_attributeForSelector:_cmd relatedView:self creationBlock:^KeepAttribute *{
            return attribute;
        }];
        return attribute;
    }];
}


- (KeepAttribute *)keepWidth {
    return [self keep_dimensionForSelector:_cmd dimensionAttribute:NSLayoutAttributeWidth name:@"width"];
}


- (KeepAttribute *)keepHeight {
    return [self keep_dimensionForSelector:_cmd dimensionAttribute:NSLayoutAttributeHeight name:@"height"];
}


- (KeepAttribute *(^)(UIView *))keepWidthTo {
    return ^KeepAttribute *(UIView *view) {
        return [self keep_dimensionForSelector:_cmd dimensionAttribute:NSLayoutAttributeWidth relatedView:view name:@"width"];
    };
}


- (KeepAttribute *(^)(UIView *))keepHeightTo {
    return ^KeepAttribute *(UIView *view) {
        return [self keep_dimensionForSelector:_cmd dimensionAttribute:NSLayoutAttributeHeight relatedView:view name:@"height"];
    };
}





#pragma mark Supreview Insets


- (KeepAttribute *)keep_insetForSelector:(SEL)selector edgeAttribute:(NSLayoutAttribute)edgeAttribute coefficient:(CGFloat)coefficient name:(NSString *)name {
    KeepAssert(self.superview, @"Calling %@ allowed only when superview exists", NSStringFromSelector(selector));
    
    return [self keep_attributeForSelector:selector creationBlock:^KeepAttribute *{
        return [[[KeepConstantAttribute alloc] initWithView:self
                                            layoutAttribute:edgeAttribute
                                                relatedView:self.superview
                                     relatedLayoutAttribute:edgeAttribute
                                                coefficient:coefficient]
                name:@"%@ of <%@ %p> to superview <%@ %p>", name, self.class, self, self.superview.class, self.superview];
    }];
}

- (KeepAttribute *)keepLeftInset {
    return [self keep_insetForSelector:_cmd edgeAttribute:NSLayoutAttributeLeft coefficient:1 name:@"left inset"];
}


- (KeepAttribute *)keepRightInset {
    return [self keep_insetForSelector:_cmd edgeAttribute:NSLayoutAttributeRight coefficient:-1 name:@"right inset"];
}


- (KeepAttribute *)keepTopInset {
    return [self keep_insetForSelector:_cmd edgeAttribute:NSLayoutAttributeTop coefficient:1 name:@"top inset"];
}


- (KeepAttribute *)keepBottomInset {
    return [self keep_insetForSelector:_cmd edgeAttribute:NSLayoutAttributeBottom coefficient:-1 name:@"bottom inset"];
}


- (KeepAttribute *)keepInsets {
    return [[[KeepGroupAttribute alloc] initWithAttributes:@[
             self.keepTopInset,
             self.keepBottomInset,
             self.keepLeftInset,
             self.keepRightInset ]]
            name:@"all insets of <%@ %p> to superview <%@ %p>", self.class, self, self.superview.class, self.superview];
}





#pragma mark Center


- (KeepAttribute *)keep_centerForSelector:(SEL)selector centerAttribute:(NSLayoutAttribute)centerAttribute name:(NSString *)name {
    KeepAssert(self.superview, @"Calling %@ allowed only when superview exists", NSStringFromSelector(selector));
    
    return [self keep_attributeForSelector:selector creationBlock:^KeepAttribute *{
        return [[[KeepMultiplierAttribute alloc] initWithView:self
                                              layoutAttribute:centerAttribute
                                                  relatedView:self.superview
                                       relatedLayoutAttribute:centerAttribute
                                                  coefficient:2]
                name:@"%@ of <%@ %p> in superview <%@ %p>", name, self.class, self, self.superview.class, self.superview];
    }];
}


- (KeepAttribute *)keepHorizontalCenter {
    return [self keep_centerForSelector:_cmd centerAttribute:NSLayoutAttributeCenterX name:@"horizontal center"];
}


- (KeepAttribute *)keepVerticalCenter {
    return [self keep_centerForSelector:_cmd centerAttribute:NSLayoutAttributeCenterY name:@"vertical center"];
}


- (KeepAttribute *)keepCenter {
    return [[[KeepGroupAttribute alloc] initWithAttributes:@[
             self.keepHorizontalCenter,
             self.keepVerticalCenter ]]
            name:@"center of <%@ %p> in superview <%@ %p>", self.class, self, self.superview.class, self.superview];
}





#pragma mark Offsets


- (KeepAttribute *)keep_offsetForSelector:(SEL)selector edgeAttribute:(NSLayoutAttribute)edgeAttribute relatedView:(UIView *)relatedView name:(NSString *)name {
    KeepAssert([self commonSuperview:relatedView], @"%@ requires both views to be in common hierarchy", NSStringFromSelector(selector));
    
    return [self keep_attributeForSelector:selector relatedView:relatedView creationBlock:^KeepAttribute *{
        NSDictionary *oppositeEdges = @{
                                        @(NSLayoutAttributeLeft): @(NSLayoutAttributeRight),
                                        @(NSLayoutAttributeRight): @(NSLayoutAttributeLeft),
                                        @(NSLayoutAttributeTop): @(NSLayoutAttributeBottom),
                                        @(NSLayoutAttributeBottom): @(NSLayoutAttributeTop),
                                        };
        return [[[KeepConstantAttribute alloc] initWithView:self
                                            layoutAttribute:edgeAttribute
                                                relatedView:relatedView
                                     relatedLayoutAttribute:[[oppositeEdges objectForKey:@(edgeAttribute)] integerValue]
                                                coefficient:1]
                name:@"%@ of <%@ %p> to <%@ %p>", name, self.class, self, relatedView.class, relatedView];
    }];
}


- (KeepAttribute *(^)(UIView *))keepLeftOffsetTo {
    return ^KeepAttribute *(UIView *view) {
        return [self keep_offsetForSelector:_cmd edgeAttribute:NSLayoutAttributeLeft relatedView:view name:@"left offset"];
    };
}


- (KeepAttribute *(^)(UIView *))keepRightOffsetTo {
    return ^KeepAttribute *(UIView *view) {
        return view.keepLeftOffsetTo(self);
    };
}


- (KeepAttribute *(^)(UIView *))keepTopOffsetTo {
    return ^KeepAttribute *(UIView *view) {
        return [self keep_offsetForSelector:_cmd edgeAttribute:NSLayoutAttributeTop relatedView:view name:@"top offset"];
    };
}


- (KeepAttribute *(^)(UIView *))keepBottomOffsetTo {
    return ^KeepAttribute *(UIView *view) {
        return view.keepTopOffsetTo(self);
    };
}





#pragma mark Alignments


- (KeepAttribute *)keep_alignForSelector:(SEL)selector alignAttribute:(NSLayoutAttribute)alignAttribute relatedView:(UIView *)relatedView coefficient:(CGFloat)coefficient name:(NSString *)name {
    KeepAssert([self commonSuperview:relatedView], @"%@ requires both views to be in common hierarchy", NSStringFromSelector(selector));
    
    return [self keep_attributeForSelector:selector relatedView:relatedView creationBlock:^KeepAttribute *{
        KeepAttribute *attribute =  [[[KeepConstantAttribute alloc] initWithView:self
                                                                 layoutAttribute:alignAttribute
                                                                     relatedView:relatedView
                                                          relatedLayoutAttribute:alignAttribute
                                                                     coefficient:coefficient]
                                     name:@"%@ of <%@ %p> to <%@ %p>", name, self.class, self, relatedView.class, relatedView];
        attribute.equal = KeepRequired(0); // Default
        // Establish inverse attribute
        [relatedView keep_attributeForSelector:selector relatedView:self creationBlock:^KeepAttribute *{
            return attribute;
        }];
        return attribute;
    }];
}


- (KeepAttribute *(^)(UIView *))keepLeftAlignTo {
    return ^KeepAttribute *(UIView *view) {
        return [self keep_alignForSelector:_cmd alignAttribute:NSLayoutAttributeLeft relatedView:view coefficient:1 name:@"left alignment"];
    };
}


- (KeepAttribute *(^)(UIView *))keepRightAlignTo {
    return ^KeepAttribute *(UIView *view) {
        return [self keep_alignForSelector:_cmd alignAttribute:NSLayoutAttributeRight relatedView:view coefficient:-1 name:@"right alignment"];
    };
}


- (KeepAttribute *(^)(UIView *))keepTopAlignTo {
    return ^KeepAttribute *(UIView *view) {
        return [self keep_alignForSelector:_cmd alignAttribute:NSLayoutAttributeTop relatedView:view coefficient:1 name:@"top alignment"];
    };
}


- (KeepAttribute *(^)(UIView *))keepBottomAlignTo {
    return ^KeepAttribute *(UIView *view) {
        return [self keep_alignForSelector:_cmd alignAttribute:NSLayoutAttributeBottom relatedView:view coefficient:-1 name:@"bottom alignment"];
    };
}


- (KeepAttribute *(^)(UIView *))keepVerticalAlignTo {
    return ^KeepAttribute *(UIView *view) {
        return [self keep_alignForSelector:_cmd alignAttribute:NSLayoutAttributeCenterX relatedView:view coefficient:1 name:@"vertical center alignment"];
    };
}


- (KeepAttribute *(^)(UIView *))keepHorizontalAlignTo {
    return ^KeepAttribute *(UIView *view) {
        return [self keep_alignForSelector:_cmd alignAttribute:NSLayoutAttributeCenterY relatedView:view coefficient:1 name:@"horizontal center alignment"];
    };
}


- (KeepAttribute *(^)(UIView *))keepBaselineAlignTo {
    return ^KeepAttribute *(UIView *view) {
        return [self keep_alignForSelector:_cmd alignAttribute:NSLayoutAttributeBaseline relatedView:view coefficient:-1 name:@"baseline alignment"];
    };
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
