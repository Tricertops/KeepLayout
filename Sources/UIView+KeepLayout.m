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
    KeepParameterAssert(selector);
    KeepParameterAssert(dimensionAttribute == NSLayoutAttributeWidth
                        || dimensionAttribute == NSLayoutAttributeHeight);
    KeepParameterAssert(name);
    
    return [self keep_attributeForSelector:selector creationBlock:^KeepAttribute *{
        KeepAttribute *attribute = [[[KeepConstantAttribute alloc] initWithView:self
                                                                layoutAttribute:dimensionAttribute
                                                                    relatedView:nil
                                                         relatedLayoutAttribute:NSLayoutAttributeNotAnAttribute
                                                                    coefficient:1]
                                    name:@"%@ of <%@ %p>", name, self.class, self];
        self.translatesAutoresizingMaskIntoConstraints = NO;
        return attribute;
    }];
}


- (KeepAttribute *)keep_dimensionForSelector:(SEL)selector dimensionAttribute:(NSLayoutAttribute)dimensionAttribute relatedView:(UIView *)relatedView name:(NSString *)name {
    KeepParameterAssert(selector);
    KeepParameterAssert(dimensionAttribute == NSLayoutAttributeWidth
                        || dimensionAttribute == NSLayoutAttributeHeight);
    KeepParameterAssert(relatedView);
    KeepParameterAssert(name);
    KeepAssert([self commonSuperview:relatedView], @"%@ requires both views to be in common hierarchy", NSStringFromSelector(selector));
    
    return [self keep_attributeForSelector:selector relatedView:relatedView creationBlock:^KeepAttribute *{
        KeepAttribute *attribute = [[KeepMultiplierAttribute alloc] initWithView:self
                                                                 layoutAttribute:dimensionAttribute
                                                                     relatedView:relatedView
                                                          relatedLayoutAttribute:dimensionAttribute
                                                                     coefficient:1];
        [attribute name:@"%@ of <%@ %p> to <%@ %p>", name, self.class, self, relatedView.class, relatedView];
        self.translatesAutoresizingMaskIntoConstraints = NO;
        relatedView.translatesAutoresizingMaskIntoConstraints = NO;
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


- (KeepAttribute *)keepSize {
    return [[KeepAttribute group:
            self.keepWidth,
            self.keepHeight,
            nil] name:@"size of <%@ %p>", self.class, self];
}


- (void)keepSize:(CGSize)size {
    [self keepSize:size priority:KeepPriorityRequired];
}


- (void)keepSize:(CGSize)size priority:(KeepPriority)priority {
    self.keepWidth.equal = KeepValueMake(size.width, priority);
    self.keepHeight.equal = KeepValueMake(size.height, priority);
}


- (KeepAttribute *)keepAspectRatio {
    return [self keep_attributeForSelector:_cmd creationBlock:^KeepAttribute *{
        KeepAttribute *attribute = [[KeepMultiplierAttribute alloc] initWithView:self
                                                                 layoutAttribute:NSLayoutAttributeWidth
                                                                     relatedView:self
                                                          relatedLayoutAttribute:NSLayoutAttributeHeight
                                                                     coefficient:1];
        [attribute name:@"aspect ration of <%@ %p>", self.class, self];
        self.translatesAutoresizingMaskIntoConstraints = NO;
        return attribute;
    }];
}


- (KeepRelatedAttributeBlock)keepWidthTo {
    return ^KeepAttribute *(UIView *view) {
        return [self keep_dimensionForSelector:_cmd dimensionAttribute:NSLayoutAttributeWidth relatedView:view name:@"width"];
    };
}


- (KeepRelatedAttributeBlock)keepHeightTo {
    return ^KeepAttribute *(UIView *view) {
        return [self keep_dimensionForSelector:_cmd dimensionAttribute:NSLayoutAttributeHeight relatedView:view name:@"height"];
    };
}


- (KeepRelatedAttributeBlock)keepSizeTo {
    return ^KeepAttribute *(UIView *view) {
        return [[KeepAttribute group:
                 self.keepWidthTo(view),
                 self.keepHeightTo(view),
                 nil] name:@"size of <%@ %p> to <%@ %p>", self.class, self, view.class, view];
    };
}





#pragma mark Supreview Insets


- (KeepAttribute *)keep_insetForSelector:(SEL)selector edgeAttribute:(NSLayoutAttribute)edgeAttribute coefficient:(CGFloat)coefficient name:(NSString *)name {
    KeepParameterAssert(selector);
    KeepParameterAssert(edgeAttribute == NSLayoutAttributeLeft
                        || edgeAttribute == NSLayoutAttributeRight
                        || edgeAttribute == NSLayoutAttributeTop
                        || edgeAttribute == NSLayoutAttributeBottom
                        || edgeAttribute == NSLayoutAttributeLeading
                        || edgeAttribute == NSLayoutAttributeTrailing);
    KeepParameterAssert(name);
    KeepAssert(self.superview, @"Calling %@ allowed only when superview exists", NSStringFromSelector(selector));
    
    return [self keep_attributeForSelector:selector creationBlock:^KeepAttribute *{
        KeepAttribute *attribute = [[[KeepConstantAttribute alloc] initWithView:self
                                                                layoutAttribute:edgeAttribute
                                                                    relatedView:self.superview
                                                         relatedLayoutAttribute:edgeAttribute
                                                                    coefficient:coefficient]
                                    name:@"%@ of <%@ %p> to superview <%@ %p>", name, self.class, self, self.superview.class, self.superview];
        self.translatesAutoresizingMaskIntoConstraints = NO;
        return attribute;
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


- (KeepAttribute *)keepHorizontalInsets {
    return [[[KeepGroupAttribute alloc] initWithAttributes:@[
             self.keepLeftInset,
             self.keepRightInset ]]
            name:@"horizontal insets of <%@ %p> to superview <%@ %p>", self.class, self, self.superview.class, self.superview];
}


- (KeepAttribute *)keepVerticalInsets {
    return [[[KeepGroupAttribute alloc] initWithAttributes:@[
             self.keepTopInset,
             self.keepBottomInset ]]
            name:@"vertical insets of <%@ %p> to superview <%@ %p>", self.class, self, self.superview.class, self.superview];
}


- (void)keepInsets:(UIEdgeInsets)insets {
    [self keepInsets:insets priority:KeepPriorityRequired];
}


- (void)keepInsets:(UIEdgeInsets)insets priority:(KeepPriority)priority {
    self.keepLeftInset.equal = KeepValueMake(insets.left, priority);
    self.keepRightInset.equal = KeepValueMake(insets.right, priority);
    self.keepTopInset.equal = KeepValueMake(insets.top, priority);
    self.keepBottomInset.equal = KeepValueMake(insets.bottom, priority);
}





#pragma mark Center


- (KeepAttribute *)keep_centerForSelector:(SEL)selector centerAttribute:(NSLayoutAttribute)centerAttribute name:(NSString *)name {
    KeepParameterAssert(selector);
    KeepParameterAssert(centerAttribute == NSLayoutAttributeCenterX
                        || centerAttribute == NSLayoutAttributeCenterY);
    KeepParameterAssert(name);
    KeepAssert(self.superview, @"Calling %@ allowed only when superview exists", NSStringFromSelector(selector));
    
    return [self keep_attributeForSelector:selector creationBlock:^KeepAttribute *{
        KeepAttribute *attribute = [[[KeepMultiplierAttribute alloc] initWithView:self
                                                                  layoutAttribute:centerAttribute
                                                                      relatedView:self.superview
                                                           relatedLayoutAttribute:centerAttribute
                                                                      coefficient:2]
                                    name:@"%@ of <%@ %p> in superview <%@ %p>", name, self.class, self, self.superview.class, self.superview];
        self.translatesAutoresizingMaskIntoConstraints = NO;
        return attribute;
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


- (void)keepCentered {
    [self keepCenteredWithPriority:KeepPriorityRequired];
}


- (void)keepCenteredWithPriority:(KeepPriority)priority {
    [self keepCenter:CGPointMake(0.5, 0.5) priority:priority];
}


- (void)keepHorizontallyCentered {
    [self keepHorizontallyCenteredWithPriority:KeepPriorityRequired];
}


- (void)keepHorizontallyCenteredWithPriority:(KeepPriority)priority {
    self.keepHorizontalCenter.equal = KeepValueMake(0.5, priority);
}


- (void)keepVerticallyCentered {
    [self keepVerticallyCenteredWithPriority:KeepPriorityRequired];
}


- (void)keepVerticallyCenteredWithPriority:(KeepPriority)priority {
    self.keepVerticalCenter.equal = KeepValueMake(0.5, priority);
}


- (void)keepCenter:(CGPoint)center {
    [self keepCenter:center priority:KeepPriorityRequired];
}


- (void)keepCenter:(CGPoint)center priority:(KeepPriority)priority {
    self.keepHorizontalCenter.equal = KeepValueMake(center.x, priority);
    self.keepVerticalCenter.equal = KeepValueMake(center.y, priority);
}





#pragma mark Offsets


- (KeepAttribute *)keep_offsetForSelector:(SEL)selector edgeAttribute:(NSLayoutAttribute)edgeAttribute relatedView:(UIView *)relatedView name:(NSString *)name {
    KeepParameterAssert(selector);
    KeepParameterAssert(edgeAttribute == NSLayoutAttributeLeft
                        || edgeAttribute == NSLayoutAttributeRight
                        || edgeAttribute == NSLayoutAttributeTop
                        || edgeAttribute == NSLayoutAttributeBottom
                        || edgeAttribute == NSLayoutAttributeLeading
                        || edgeAttribute == NSLayoutAttributeTrailing);
    KeepParameterAssert(relatedView);
    KeepParameterAssert(name);
    KeepAssert([self commonSuperview:relatedView], @"%@ requires both views to be in common hierarchy", NSStringFromSelector(selector));
    
    return [self keep_attributeForSelector:selector relatedView:relatedView creationBlock:^KeepAttribute *{
        NSDictionary *oppositeEdges = @{
                                        @(NSLayoutAttributeLeft): @(NSLayoutAttributeRight),
                                        @(NSLayoutAttributeRight): @(NSLayoutAttributeLeft),
                                        @(NSLayoutAttributeTop): @(NSLayoutAttributeBottom),
                                        @(NSLayoutAttributeBottom): @(NSLayoutAttributeTop),
                                        };
        KeepAttribute *attribute =  [[[KeepConstantAttribute alloc] initWithView:self
                                                                 layoutAttribute:edgeAttribute
                                                                     relatedView:relatedView
                                                          relatedLayoutAttribute:[[oppositeEdges objectForKey:@(edgeAttribute)] integerValue]
                                                                     coefficient:1]
                                     name:@"%@ of <%@ %p> to <%@ %p>", name, self.class, self, relatedView.class, relatedView];
        self.translatesAutoresizingMaskIntoConstraints = NO;
        relatedView.translatesAutoresizingMaskIntoConstraints = NO;
        return attribute;
    }];
}


- (KeepRelatedAttributeBlock)keepLeftOffsetTo {
    return ^KeepAttribute *(UIView *view) {
        return [self keep_offsetForSelector:_cmd edgeAttribute:NSLayoutAttributeLeft relatedView:view name:@"left offset"];
    };
}


- (KeepRelatedAttributeBlock)keepRightOffsetTo {
    return ^KeepAttribute *(UIView *view) {
        return view.keepLeftOffsetTo(self);
    };
}


- (KeepRelatedAttributeBlock)keepTopOffsetTo {
    return ^KeepAttribute *(UIView *view) {
        return [self keep_offsetForSelector:_cmd edgeAttribute:NSLayoutAttributeTop relatedView:view name:@"top offset"];
    };
}


- (KeepRelatedAttributeBlock)keepBottomOffsetTo {
    return ^KeepAttribute *(UIView *view) {
        return view.keepTopOffsetTo(self);
    };
}





#pragma mark Alignments


- (KeepAttribute *)keep_alignForSelector:(SEL)selector alignAttribute:(NSLayoutAttribute)alignAttribute relatedView:(UIView *)relatedView coefficient:(CGFloat)coefficient name:(NSString *)name {
    KeepParameterAssert(selector);
    KeepParameterAssert(alignAttribute == NSLayoutAttributeLeft
                        || alignAttribute == NSLayoutAttributeRight
                        || alignAttribute == NSLayoutAttributeTop
                        || alignAttribute == NSLayoutAttributeBottom
                        || alignAttribute == NSLayoutAttributeLeading
                        || alignAttribute == NSLayoutAttributeTrailing
                        || alignAttribute == NSLayoutAttributeCenterX
                        || alignAttribute == NSLayoutAttributeBaseline
                        || alignAttribute == NSLayoutAttributeCenterY);
    KeepParameterAssert(relatedView);
    KeepParameterAssert(name);
    KeepAssert([self commonSuperview:relatedView], @"%@ requires both views to be in common hierarchy", NSStringFromSelector(selector));
    
    return [self keep_attributeForSelector:selector relatedView:relatedView creationBlock:^KeepAttribute *{
        KeepAttribute *attribute =  [[[KeepConstantAttribute alloc] initWithView:self
                                                                 layoutAttribute:alignAttribute
                                                                     relatedView:relatedView
                                                          relatedLayoutAttribute:alignAttribute
                                                                     coefficient:coefficient]
                                     name:@"%@ of <%@ %p> to <%@ %p>", name, self.class, self, relatedView.class, relatedView];
        self.translatesAutoresizingMaskIntoConstraints = NO;
        relatedView.translatesAutoresizingMaskIntoConstraints = NO;
        // Establish inverse attribute
        [relatedView keep_attributeForSelector:selector relatedView:self creationBlock:^KeepAttribute *{
            return attribute;
        }];
        return attribute;
    }];
}


- (KeepRelatedAttributeBlock)keepLeftAlignTo {
    return ^KeepAttribute *(UIView *view) {
        return [self keep_alignForSelector:_cmd alignAttribute:NSLayoutAttributeLeft relatedView:view coefficient:1 name:@"left alignment"];
    };
}


- (KeepRelatedAttributeBlock)keepRightAlignTo {
    return ^KeepAttribute *(UIView *view) {
        return [self keep_alignForSelector:_cmd alignAttribute:NSLayoutAttributeRight relatedView:view coefficient:-1 name:@"right alignment"];
    };
}


- (KeepRelatedAttributeBlock)keepTopAlignTo {
    return ^KeepAttribute *(UIView *view) {
        return [self keep_alignForSelector:_cmd alignAttribute:NSLayoutAttributeTop relatedView:view coefficient:1 name:@"top alignment"];
    };
}


- (KeepRelatedAttributeBlock)keepBottomAlignTo {
    return ^KeepAttribute *(UIView *view) {
        return [self keep_alignForSelector:_cmd alignAttribute:NSLayoutAttributeBottom relatedView:view coefficient:-1 name:@"bottom alignment"];
    };
}


- (void)keepEdgeAlignTo:(UIView *)view {
    [self keepEdgeAlignTo:view insets:UIEdgeInsetsZero];
}


- (void)keepEdgeAlignTo:(UIView *)view insets:(UIEdgeInsets)insets {
    [self keepEdgeAlignTo:view insets:insets withPriority:KeepPriorityRequired];
}


- (void)keepEdgeAlignTo:(UIView *)view insets:(UIEdgeInsets)insets withPriority:(KeepPriority)priority {
    self.keepLeftAlignTo(view).equal = KeepValueMake(insets.left, priority);
    self.keepRightAlignTo(view).equal = KeepValueMake(insets.right, priority);
    self.keepTopAlignTo(view).equal = KeepValueMake(insets.top, priority);
    self.keepBottomAlignTo(view).equal = KeepValueMake(insets.bottom, priority);
}


- (KeepRelatedAttributeBlock)keepVerticalAlignTo {
    return ^KeepAttribute *(UIView *view) {
        return [self keep_alignForSelector:_cmd alignAttribute:NSLayoutAttributeCenterX relatedView:view coefficient:1 name:@"vertical center alignment"];
    };
}


- (KeepRelatedAttributeBlock)keepHorizontalAlignTo {
    return ^KeepAttribute *(UIView *view) {
        return [self keep_alignForSelector:_cmd alignAttribute:NSLayoutAttributeCenterY relatedView:view coefficient:1 name:@"horizontal center alignment"];
    };
}


- (void)keepCenterAlignTo:(UIView *)view {
    [self keepCenterAlignTo:view offset:UIOffsetZero];
}


- (void)keepCenterAlignTo:(UIView *)view offset:(UIOffset)offset {
    [self keepCenterAlignTo:view offset:offset withPriority:KeepPriorityRequired];
}


- (void)keepCenterAlignTo:(UIView *)view offset:(UIOffset)offset withPriority:(KeepPriority)priority {
    self.keepHorizontalAlignTo(view).equal = KeepValueMake(offset.horizontal, priority);
    self.keepVerticalAlignTo(view).equal = KeepValueMake(offset.vertical, priority);
}


- (KeepRelatedAttributeBlock)keepBaselineAlignTo {
    return ^KeepAttribute *(UIView *view) {
        return [self keep_alignForSelector:_cmd alignAttribute:NSLayoutAttributeBaseline relatedView:view coefficient:-1 name:@"baseline alignment"];
    };
}





#pragma mark Animating Constraints


- (void)keepAnimatedWithDuration:(NSTimeInterval)duration layout:(void(^)(void))animations {
    KeepParameterAssert(duration >= 0);
    KeepParameterAssert(animations);
    
    [self keep_animationPerformWithDuration:duration delay:0 block:^{
        [UIView animateWithDuration:duration
                         animations:^{
                             animations();
                             [self layoutIfNeeded];
                         }];
    }];
}


- (void)keepAnimatedWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay layout:(void(^)(void))animations {
    KeepParameterAssert(duration >= 0);
    KeepParameterAssert(delay >= 0);
    KeepParameterAssert(animations);
    
    [self keep_animationPerformWithDuration:duration delay:delay block:^{
        [UIView animateWithDuration:duration
                         animations:^{
                             animations();
                             [self layoutIfNeeded];
                         }];
    }];
}


- (void)keepAnimatedWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay options:(UIViewAnimationOptions)options layout:(void(^)(void))animations completion:(void(^)(BOOL finished))completion {
    KeepParameterAssert(duration >= 0);
    KeepParameterAssert(delay >= 0);
    KeepParameterAssert(animations);
    
    [self keep_animationPerformWithDuration:duration delay:delay block:^{
        [UIView animateWithDuration:duration
                              delay:0
                            options:options
                         animations:^{
                             animations();
                             [self layoutIfNeeded];
                         }
                         completion:completion];
    }];
}


#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000   // Compiled with iOS 7 SDK
- (void)keepAnimatedWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay usingSpringWithDamping:(CGFloat)dampingRatio initialSpringVelocity:(CGFloat)velocity options:(UIViewAnimationOptions)options layout:(void (^)(void))animations completion:(void (^)(BOOL finished))completion {
    KeepParameterAssert(duration >= 0);
    KeepParameterAssert(delay >= 0);
    KeepParameterAssert(animations);
    
    if ([UIView respondsToSelector:@selector(animateWithDuration:delay:usingSpringWithDamping:initialSpringVelocity:options:animations:completion:)]) {
        // Running on iOS 7
        [self keep_animationPerformWithDuration:duration delay:delay block:^{
            [UIView animateWithDuration:duration
                                  delay:0
                 usingSpringWithDamping:dampingRatio
                  initialSpringVelocity:velocity
                                options:options
                             animations:^{
                                 animations();
                                 [self layoutIfNeeded];
                             }
                             completion:completion];
        }];
    }
    else {
        // Running on iOS 6, fallback to non-spring animation
        [self keep_animationPerformWithDuration:duration delay:delay block:^{
            [UIView animateWithDuration:duration
                                  delay:0
                                options:options
                             animations:^{
                                 animations();
                                 [self layoutIfNeeded];
                             }
                             completion:completion];
        }];
    }
}
#endif


- (void)keep_animationPerformWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay block:(void(^)(void))block {
    if (duration > 0 || delay > 0) {
        [[NSOperationQueue mainQueue] performSelector:@selector(addOperationWithBlock:)
                                           withObject:block
                                           afterDelay:delay
                                              inModes:@[NSRunLoopCommonModes]];
    }
    else {
        block();
    }
}


#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000   // Compiled with iOS 7 SDK
- (void)keepNotAnimated:(void (^)(void))layout {
    
    if ([UIView respondsToSelector:@selector(performWithoutAnimation:)]) {
        // Running iOS 7
        [UIView performWithoutAnimation:^{
            layout();
            [self layoutIfNeeded];
        }];
    }
    else {
        // Running iOS 6, just execute block
        layout();
        [self layoutIfNeeded];
    }
}
#endif





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
