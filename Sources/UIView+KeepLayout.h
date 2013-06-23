//
//  UIView+KeepLayout.h
//  Geografia
//
//  Created by Martin Kiss on 21.10.12.
//  Copyright (c) 2012 iMartin Kiss. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

@class KeepAttribute;




/// Category that provides very easy access to all Auto Layout features through abstraction above NSLayoutConstraints.
@interface UIView (KeepLayout)





#pragma mark Dimensions
/// Attributes representing internal size of the receiver.
// TODO: Use intrictic size by default.
- (KeepAttribute *)keepWidth;
- (KeepAttribute *)keepHeight;


#pragma mark Superview Insets
/// Attributes representing internal inset (margin) of the receive to its superview.
/// Requires superview.
- (KeepAttribute *)keepLeftInset;
- (KeepAttribute *)keepRightInset; /// Automatically inverts values.
- (KeepAttribute *)keepTopInset;
- (KeepAttribute *)keepBottomInset; /// Automatically inverts values.

/// Grouped proxy attribute of all 4 insets above.
- (KeepAttribute *)keepInsets;


#pragma mark Center
/// Attributes representing relative position of the receiver to its superview.
/// Requires superview.
/// Example values: 0 = left edge, 0.5 = middle, 1 = right edge
// TODO: Use 0.5 by default
- (KeepAttribute *)keepHorizontalCenter;
- (KeepAttribute *)keepVerticalCenter;

/// Grouped proxy attribute of the two centers above.
- (KeepAttribute *)keepCenter;


#pragma mark Offsets
/// Attributes representing offset (padding, distance) of two views.
/// Requires both views to be in the same hierarchy.
/// Usage `view.keepLeftOffset(anotherView)`
// TODO: Use 0 as default
- (KeepAttribute *(^)(UIView *))keepLeftOffset;
- (KeepAttribute *(^)(UIView *))keepRightOffset; /// Identical to left offset in reversed direction.
- (KeepAttribute *(^)(UIView *))keepTopOffset;
- (KeepAttribute *(^)(UIView *))keepBottomOffset; /// Identical to top offset in reversed direction.


#pragma mark Alignments
/// Attributes representing edge alignments of two views.
/// Requires both views to be in the same hierarchy.
/// Usage `view.keepLeftAlign(anotherView)`.
/// Optional values specify offset from the alignment line.
/// Default is „0 required”.
- (KeepAttribute *(^)(UIView *))keepLeftAlign;
- (KeepAttribute *(^)(UIView *))keepRightAlign; /// Automatically inverts values.
- (KeepAttribute *(^)(UIView *))keepTopAlign;
- (KeepAttribute *(^)(UIView *))keepBottomAlign; /// Automatically inverts values.

/// Attributes representing center alignments of two views.
- (KeepAttribute *(^)(UIView *))keepVerticalAlign;
- (KeepAttribute *(^)(UIView *))keepHorizontalAlign; /// Automatically inverts values.

/// Attribute representing baseline alignments of two views.
/// Not all views have baseline.
- (KeepAttribute *(^)(UIView *))keepBaselineAlign; /// Automatically inverts values.


#pragma mark Animating Constraints
/// Animation methods allowing you to modify all above attributes (or even constraints directly) animatedly.
/// Receiver automatically calls `-layoutIfNeeded` right in the animation block.
- (void)keepAnimatedWithDuration:(NSTimeInterval)duration layout:(void(^)(void))animations;
- (void)keepAnimatedWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay layout:(void(^)(void))animations;
- (void)keepAnimatedWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay options:(UIViewAnimationOptions)options layout:(void(^)(void))animations completion:(void(^)(BOOL finished))completion;


#pragma mark Common Superview
/// Traverses superviews and returns the first common for both, the receiver and the argument.
- (UIView *)commonSuperview:(UIView *)anotherView;


#pragma mark Convenience Auto Layout
/// Methods not used by Keep Layout directly, but are provided for your convenience.

/// Add/remove single constraint.
- (void)addConstraintToCommonSuperview:(NSLayoutConstraint *)constraint;
- (void)removeConstraintFromCommonSuperview:(NSLayoutConstraint *)constraint;

/// Add/remove collection of constraints.
- (void)addConstraintsToCommonSuperview:(id<NSFastEnumeration>)constraints;
- (void)removeConstraintsFromCommonSuperview:(id<NSFastEnumeration>)constraints;



@end
