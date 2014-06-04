//
//  KIT_VIEW_CLASS+KeepLayout.m
//  Geografia
//
//  Created by Martin Kiss on 21.10.12.
//  Copyright (c) 2012 iMartin Kiss. All rights reserved.
//

#import "View+KeepLayout.h"
#import "KeepAttribute.h"
#import <objc/runtime.h>





@implementation KIT_VIEW_CLASS (KeepLayout)





#pragma mark Swizzle


+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        SEL originalSelector = @selector(willMoveToSuperview:);
        SEL replacementSelector = @selector(keep_willMoveToSuperview:);
        
        Method originalMethod = class_getInstanceMethod(self, originalSelector);
        Method replacementMethod = class_getInstanceMethod(self, replacementSelector);
        
        BOOL didAdd = class_addMethod(self,
                                      originalSelector,
                                      method_getImplementation(replacementMethod),
                                      method_getTypeEncoding(replacementMethod));
        if (didAdd) {
            class_replaceMethod(self,
                                replacementSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, replacementMethod);
        }
    });
}


- (void)keep_willMoveToSuperview:(KIT_VIEW_CLASS *)future {
    [self keep_willMoveToSuperview:future];
    
    KIT_VIEW_CLASS *current = self.superview;
    if (current && current != future) {
        [self keep_clearSuperviewInsets];
        [self keep_clearSuperviewPosition];
    }
}





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


- (KeepAttribute *)keep_attributeForSelector:(SEL)selector relatedView:(KIT_VIEW_CLASS *)relatedView creationBlock:(KeepAttribute *(^)())creationBlock {
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


- (void)keep_clearAttribute:(SEL)selector {
    NSParameterAssert(selector);
    
    KeepAttribute *attribute = objc_getAssociatedObject(self, selector);
    [attribute remove];
    
    objc_setAssociatedObject(self, selector, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
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


- (KeepAttribute *)keep_dimensionForSelector:(SEL)selector dimensionAttribute:(NSLayoutAttribute)dimensionAttribute relatedView:(KIT_VIEW_CLASS *)relatedView name:(NSString *)name {
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
    return ^KeepAttribute *(KIT_VIEW_CLASS *view) {
        return [self keep_dimensionForSelector:_cmd dimensionAttribute:NSLayoutAttributeWidth relatedView:view name:@"width"];
    };
}


- (KeepRelatedAttributeBlock)keepHeightTo {
    return ^KeepAttribute *(KIT_VIEW_CLASS *view) {
        return [self keep_dimensionForSelector:_cmd dimensionAttribute:NSLayoutAttributeHeight relatedView:view name:@"height"];
    };
}


- (KeepRelatedAttributeBlock)keepSizeTo {
    return ^KeepAttribute *(KIT_VIEW_CLASS *view) {
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


- (void)keep_clearSuperviewInsets {
    // Clears all superview insets ever created. Works after removing from superview.
    [self keep_clearAttribute:@selector(keepTopInset)];
    [self keep_clearAttribute:@selector(keepLeftInset)];
    [self keep_clearAttribute:@selector(keepRightInset)];
    [self keep_clearAttribute:@selector(keepBottomInset)];
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


- (void)keepInsets:(KIT_VIEW_EDGE_INSETS)insets {
    [self keepInsets:insets priority:KeepPriorityRequired];
}


- (void)keepInsets:(KIT_VIEW_EDGE_INSETS)insets priority:(KeepPriority)priority {
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


- (void)keep_clearSuperviewPosition {
    // Clears all superview constrains ever created. Works after removing from superview.
    [self keep_clearAttribute:@selector(keepHorizontalCenter)];
    [self keep_clearAttribute:@selector(keepVerticalCenter)];
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


- (KeepAttribute *)keep_offsetForSelector:(SEL)selector edgeAttribute:(NSLayoutAttribute)edgeAttribute relatedView:(KIT_VIEW_CLASS *)relatedView name:(NSString *)name {
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
    return ^KeepAttribute *(KIT_VIEW_CLASS *view) {
        return [self keep_offsetForSelector:_cmd edgeAttribute:NSLayoutAttributeLeft relatedView:view name:@"left offset"];
    };
}


- (KeepRelatedAttributeBlock)keepRightOffsetTo {
    return ^KeepAttribute *(KIT_VIEW_CLASS *view) {
        return view.keepLeftOffsetTo(self);
    };
}


- (KeepRelatedAttributeBlock)keepTopOffsetTo {
    return ^KeepAttribute *(KIT_VIEW_CLASS *view) {
        return [self keep_offsetForSelector:_cmd edgeAttribute:NSLayoutAttributeTop relatedView:view name:@"top offset"];
    };
}


- (KeepRelatedAttributeBlock)keepBottomOffsetTo {
    return ^KeepAttribute *(KIT_VIEW_CLASS *view) {
        return view.keepTopOffsetTo(self);
    };
}





#pragma mark Alignments


- (KeepAttribute *)keep_alignForSelector:(SEL)selector alignAttribute:(NSLayoutAttribute)alignAttribute relatedView:(KIT_VIEW_CLASS *)relatedView coefficient:(CGFloat)coefficient name:(NSString *)name {
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
    return ^KeepAttribute *(KIT_VIEW_CLASS *view) {
        return [self keep_alignForSelector:_cmd alignAttribute:NSLayoutAttributeLeft relatedView:view coefficient:1 name:@"left alignment"];
    };
}


- (KeepRelatedAttributeBlock)keepRightAlignTo {
    return ^KeepAttribute *(KIT_VIEW_CLASS *view) {
        return [self keep_alignForSelector:_cmd alignAttribute:NSLayoutAttributeRight relatedView:view coefficient:-1 name:@"right alignment"];
    };
}


- (KeepRelatedAttributeBlock)keepTopAlignTo {
    return ^KeepAttribute *(KIT_VIEW_CLASS *view) {
        return [self keep_alignForSelector:_cmd alignAttribute:NSLayoutAttributeTop relatedView:view coefficient:1 name:@"top alignment"];
    };
}


- (KeepRelatedAttributeBlock)keepBottomAlignTo {
    return ^KeepAttribute *(KIT_VIEW_CLASS *view) {
        return [self keep_alignForSelector:_cmd alignAttribute:NSLayoutAttributeBottom relatedView:view coefficient:-1 name:@"bottom alignment"];
    };
}


- (void)keepEdgeAlignTo:(KIT_VIEW_CLASS *)view {
    [self keepEdgeAlignTo:view insets:KIT_VIEW_EDGE_INSETS_ZERO];
}


- (void)keepEdgeAlignTo:(KIT_VIEW_CLASS *)view insets:(KIT_VIEW_EDGE_INSETS)insets {
    [self keepEdgeAlignTo:view insets:insets withPriority:KeepPriorityRequired];
}


- (void)keepEdgeAlignTo:(KIT_VIEW_CLASS *)view insets:(KIT_VIEW_EDGE_INSETS)insets withPriority:(KeepPriority)priority {
    self.keepLeftAlignTo(view).equal = KeepValueMake(insets.left, priority);
    self.keepRightAlignTo(view).equal = KeepValueMake(insets.right, priority);
    self.keepTopAlignTo(view).equal = KeepValueMake(insets.top, priority);
    self.keepBottomAlignTo(view).equal = KeepValueMake(insets.bottom, priority);
}


- (KeepRelatedAttributeBlock)keepVerticalAlignTo {
    return ^KeepAttribute *(KIT_VIEW_CLASS *view) {
        return [self keep_alignForSelector:_cmd alignAttribute:NSLayoutAttributeCenterX relatedView:view coefficient:1 name:@"vertical center alignment"];
    };
}


- (KeepRelatedAttributeBlock)keepHorizontalAlignTo {
    return ^KeepAttribute *(KIT_VIEW_CLASS *view) {
        return [self keep_alignForSelector:_cmd alignAttribute:NSLayoutAttributeCenterY relatedView:view coefficient:1 name:@"horizontal center alignment"];
    };
}


- (void)keepCenterAlignTo:(KIT_VIEW_CLASS *)view {
    [self keepCenterAlignTo:view offset:KIT_VIEW_OFFSET_ZERO];
}


- (void)keepCenterAlignTo:(KIT_VIEW_CLASS *)view offset:(KIT_VIEW_OFFSET)offset {
    [self keepCenterAlignTo:view offset:offset withPriority:KeepPriorityRequired];
}


- (void)keepCenterAlignTo:(KIT_VIEW_CLASS *)view offset:(KIT_VIEW_OFFSET)offset withPriority:(KeepPriority)priority {
    self.keepHorizontalAlignTo(view).equal = KeepValueMake(offset.horizontal, priority);
    self.keepVerticalAlignTo(view).equal = KeepValueMake(offset.vertical, priority);
}


- (KeepRelatedAttributeBlock)keepBaselineAlignTo {
    return ^KeepAttribute *(KIT_VIEW_CLASS *view) {
        return [self keep_alignForSelector:_cmd alignAttribute:NSLayoutAttributeBaseline relatedView:view coefficient:-1 name:@"baseline alignment"];
    };
}





#pragma mark Animating Constraints

#if TARGET_OS_IPHONE
- (void)keepAnimatedWithDuration:(NSTimeInterval)duration layout:(void(^)(void))animations {
    KeepParameterAssert(duration >= 0);
    KeepParameterAssert(animations);
    
    [self keep_animationPerformWithDuration:duration delay:0 block:^{
        [KIT_VIEW_CLASS animateWithDuration:duration
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
        [KIT_VIEW_CLASS animateWithDuration:duration
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
        [KIT_VIEW_CLASS animateWithDuration:duration
                              delay:0
                            options:options
                         animations:^{
                             animations();
                             [self layoutIfNeeded];
                         }
                         completion:completion];
    }];
}
#endif

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000   // Compiled with iOS 7 SDK
- (void)keepAnimatedWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay usingSpringWithDamping:(CGFloat)dampingRatio initialSpringVelocity:(CGFloat)velocity options:(UIViewAnimationOptions)options layout:(void (^)(void))animations completion:(void (^)(BOOL finished))completion {
    KeepParameterAssert(duration >= 0);
    KeepParameterAssert(delay >= 0);
    KeepParameterAssert(animations);
    
    if ([KIT_VIEW_CLASS respondsToSelector:@selector(animateWithDuration:delay:usingSpringWithDamping:initialSpringVelocity:options:animations:completion:)]) {
        // Running on iOS 7
        [self keep_animationPerformWithDuration:duration delay:delay block:^{
            [KIT_VIEW_CLASS animateWithDuration:duration
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
            [KIT_VIEW_CLASS animateWithDuration:duration
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
    
    if ([KIT_VIEW_CLASS respondsToSelector:@selector(performWithoutAnimation:)]) {
        // Running iOS 7
        [KIT_VIEW_CLASS performWithoutAnimation:^{
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


- (KIT_VIEW_CLASS *)commonSuperview:(KIT_VIEW_CLASS *)anotherView
{
	NSArray *mySuperviews = [self superviewsOfView:self];
	NSArray *otherSuperviews = [self superviewsOfView:anotherView];
	for (KIT_VIEW_CLASS *view in mySuperviews)
	{
		if ([otherSuperviews containsObject:view])
			return view;
	}
	return nil;
}

- (NSArray *)superviewsOfView:(KIT_VIEW_CLASS*)view
{
	NSMutableArray *superviews = [NSMutableArray new];
	[superviews addObject:view];
	while (view.superview)
	{
		[superviews addObject:view.superview];
		view = view.superview;
	}
	return superviews;
}




#pragma mark Convenience Auto Layout


- (void)addConstraintToCommonSuperview:(NSLayoutConstraint *)constraint {
    KIT_VIEW_CLASS *relatedLayoutView = constraint.secondItem;
    KIT_VIEW_CLASS *commonView = (relatedLayoutView? [self commonSuperview:relatedLayoutView] : self);
    [commonView addConstraint:constraint];
}


- (void)removeConstraintFromCommonSuperview:(NSLayoutConstraint *)constraint {
    KIT_VIEW_CLASS *relatedLayoutView = constraint.secondItem;
    KIT_VIEW_CLASS *commonView = (relatedLayoutView? [self commonSuperview:relatedLayoutView] : self);
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
