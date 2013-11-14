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
#import "KeepTypes.h"

@class KeepAttribute;




/// Category that provides very easy access to all Auto Layout features through abstraction above NSLayoutConstraints.
@interface UIView (KeepLayout)





#pragma mark Dimensions

/// Attributes representing internal size of the receiver.
- (KeepAttribute *)keepWidth;
/// Attributes representing internal size of the receiver.
- (KeepAttribute *)keepHeight;

/// Grouped proxy attribute for size (keepWidth + keepHeight).
- (KeepAttribute *)keepSize;

/// Convenience methods for setting both dimensions at once.
- (void)keepSize:(CGSize)size priority:(KeepPriority)priority;
/// Convenience methods for setting both dimensions at once.
/// Uses Required priority. Use is discouraged.
- (void)keepSize:(CGSize)size;

/// Attributes representing aspect ratio of receiver's dimensions. Values are multipliers of width/height.
- (KeepAttribute *)keepAspectRatio;

/// Attributes representing relative dimension to other view.
/// Example values: 0.5 = half width, 1 = same width
- (KeepAttribute *(^)(UIView *))keepWidthTo;
/// Attributes representing relative dimension to other view.
/// Example values: 0.5 = half height, 1 = same height
- (KeepAttribute *(^)(UIView *))keepHeightTo;

/// Grouped proxy attribute for relative size (keepWidth + keepHeight).
/// Example values: 0.5 = half size, 1 = same size
- (KeepAttribute *(^)(UIView *))keepSizeTo;



#pragma mark Superview Insets

/// Attributes representing internal inset (margin) of the receive to its superview.
/// Requires superview.
- (KeepAttribute *)keepLeftInset;
/// Attributes representing internal inset (margin) of the receive to its superview.
/// Requires superview.
/// Automatically inverts values.
- (KeepAttribute *)keepRightInset;
/// Attributes representing internal inset (margin) of the receive to its superview.
/// Requires superview.
- (KeepAttribute *)keepTopInset;
/// Attributes representing internal inset (margin) of the receive to its superview.
/// Requires superview.
/// Automatically inverts values.
- (KeepAttribute *)keepBottomInset;



/// Grouped proxy attributes for insets (keepTop + keepBottom).
- (KeepAttribute *)keepInsets;
/// Grouped proxy attributes for horizontal insets (keepLeft + keepRight).
- (KeepAttribute *)keepHorizontalInsets;
/// Grouped proxy attributes for vertical insets (keepTop + keepBottom).
- (KeepAttribute *)keepVerticalInsets;



/// Convenience methods for setting all dimensions at once.
- (void)keepInsets:(UIEdgeInsets)insets priority:(KeepPriority)priority;
/// Convenience methods for setting all dimensions at once.
/// Uses Required priority. Use is discouraged.
- (void)keepInsets:(UIEdgeInsets)insets;


#pragma mark Center

/// Attributes representing relative position of the receiver to its superview.
/// Requires superview.
/// Example values: 0 = left edge, 0.5 = middle, 1 = right edge
- (KeepAttribute *)keepHorizontalCenter;
/// Attributes representing relative position of the receiver to its superview.
/// Requires superview.
/// Example values: 0 = left edge, 0.5 = middle, 1 = right edge
- (KeepAttribute *)keepVerticalCenter;

/// Grouped proxy attribute of the two centers above.
/// Requires superview.
/// Example values: 0 = left edge, 0.5 = middle, 1 = right edge
- (KeepAttribute *)keepCenter;


/// Convenience methods for setting both centers at once to 0.5.
- (void)keepCenteredWithPriority:(KeepPriority)priority;
/// Convenience methods for setting both centers at once to 0.5.
/// Uses Required priority. Use is discouraged.
- (void)keepCentered;
/// Convenience methods for setting horizontal center to 0.5.
- (void)keepHorizontallyCenteredWithPriority:(KeepPriority)priority;
/// Convenience methods for setting horizontal center to 0.5.
/// Uses Required priority. Use is discouraged.
- (void)keepHorizontallyCentered;
/// Convenience methods for setting vertical center to 0.5.
/// Uses Required priority. Use is discouraged.
- (void)keepVerticallyCenteredWithPriority:(KeepPriority)priority;
/// Convenience methods for setting vertical center to 0.5.
/// Uses Required priority. Use is discouraged.
- (void)keepVerticallyCentered;
/// Convenience methods for setting both centers at once.
/// Uses Required priority. Use is discouraged.
- (void)keepCenter:(CGPoint)center priority:(KeepPriority)priority;
/// Convenience methods for setting both centers at once.
/// Uses Required priority. Use is discouraged.
- (void)keepCenter:(CGPoint)center;



#pragma mark Offsets

/// Attributes representing offset (padding, distance) of two views.
/// Requires both views to be in the same hierarchy.
/// Usage `view.keepLeftOffset(anotherView)`
/// Default is “0 required”
- (KeepAttribute *(^)(UIView *))keepLeftOffsetTo;
/// Attributes representing offset (padding, distance) of two views.
/// Requires both views to be in the same hierarchy.
/// Usage `view.keepLeftOffset(anotherView)`
/// Default is “0 required”
/// Identical to left offset in reversed direction.
- (KeepAttribute *(^)(UIView *))keepRightOffsetTo;
/// Attributes representing offset (padding, distance) of two views.
/// Requires both views to be in the same hierarchy.
/// Usage `view.keepLeftOffset(anotherView)`
/// Default is “0 required”
- (KeepAttribute *(^)(UIView *))keepTopOffsetTo;
/// Attributes representing offset (padding, distance) of two views.
/// Requires both views to be in the same hierarchy.
/// Usage `view.keepLeftOffset(anotherView)`
/// Default is “0 required”
/// Identical to top offset in reversed direction.
- (KeepAttribute *(^)(UIView *))keepBottomOffsetTo;



#pragma mark Alignments

/// Attributes representing edge alignments of two views.
/// Requires both views to be in the same hierarchy.
/// Usage `view.keepLeftAlign(anotherView)`.
/// Optional values specify offset from the alignment line.
/// Default is „0 required”.
- (KeepAttribute *(^)(UIView *))keepLeftAlignTo;
/// Attributes representing edge alignments of two views.
/// Requires both views to be in the same hierarchy.
/// Usage `view.keepLeftAlign(anotherView)`.
/// Optional values specify offset from the alignment line.
/// Default is „0 required”.
/// Automatically inverts values.
- (KeepAttribute *(^)(UIView *))keepRightAlignTo;
/// Attributes representing edge alignments of two views.
/// Requires both views to be in the same hierarchy.
/// Usage `view.keepLeftAlign(anotherView)`.
/// Optional values specify offset from the alignment line.
/// Default is „0 required”.
- (KeepAttribute *(^)(UIView *))keepTopAlignTo;
/// Attributes representing edge alignments of two views.
/// Requires both views to be in the same hierarchy.
/// Usage `view.keepLeftAlign(anotherView)`.
/// Optional values specify offset from the alignment line.
/// Default is „0 required”.
/// Automatically inverts values.
- (KeepAttribute *(^)(UIView *))keepBottomAlignTo;

/// Convenience methods for setting all edge alignments at once.
- (void)keepEdgeAlignTo:(UIView *)view insets:(UIEdgeInsets)insets withPriority:(KeepPriority)priority;
/// Convenience methods for setting all edge alignments at once.
/// Uses Required priority. Use is discouraged.
- (void)keepEdgeAlignTo:(UIView *)view insets:(UIEdgeInsets)insets;
/// Convenience methods for setting all edge alignments at once.
/// Uses zero insets and Required priority. Use is discouraged.
- (void)keepEdgeAlignTo:(UIView *)view;

/// Attributes representing center alignments of two views.
- (KeepAttribute *(^)(UIView *))keepVerticalAlignTo;
/// Attributes representing center alignments of two views.
/// Automatically inverts values.
- (KeepAttribute *(^)(UIView *))keepHorizontalAlignTo;

/// Convenience methods for setting center (both axis) alignment.
- (void)keepCenterAlignTo:(UIView *)view offset:(UIOffset)offset withPriority:(KeepPriority)priority;
/// Convenience methods for setting center (both axis) alignment.
/// Uses Required priority.  Use is discouraged.
- (void)keepCenterAlignTo:(UIView *)view offset:(UIOffset)offset;
/// Convenience methods for setting center (both axis) alignment.
/// Uses zero offset and Required priority. Use is discouraged.
- (void)keepCenterAlignTo:(UIView *)view;

/// Attribute representing baseline alignments of two views.
/// Not all views have baseline.
/// Automatically inverts values.
- (KeepAttribute *(^)(UIView *))keepBaselineAlignTo;



#pragma mark Animating Constraints

/// Animation methods allowing you to modify all above attributes (or even constraints directly) animatedly.
/// Receiver automatically calls `-layoutIfNeeded` right in the animation block.
/// All animations are scheduled on main queue with given delay. The layout code itself is executed after the delay (this is different than in UIView animation methods)
- (void)keepAnimatedWithDuration:(NSTimeInterval)duration layout:(void(^)(void))animations;
/// Animation methods allowing you to modify all above attributes (or even constraints directly) animatedly.
/// Receiver automatically calls `-layoutIfNeeded` right in the animation block.
/// All animations are scheduled on main queue with given delay. The layout code itself is executed after the delay (this is different than in UIView animation methods)
- (void)keepAnimatedWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay layout:(void(^)(void))animations;
/// Animation methods allowing you to modify all above attributes (or even constraints directly) animatedly.
/// Receiver automatically calls `-layoutIfNeeded` right in the animation block.
/// All animations are scheduled on main queue with given delay. The layout code itself is executed after the delay (this is different than in UIView animation methods)
- (void)keepAnimatedWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay options:(UIViewAnimationOptions)options layout:(void(^)(void))animations completion:(void(^)(BOOL finished))completion;

/// Animation methods allowing you to modify all above attributes (or even constraints directly) animatedly.
/// Receiver automatically calls `-layoutIfNeeded` right in the animation block.
/// All animations are scheduled on main queue with given delay. The layout code itself is executed after the delay (this is different than in UIView animation methods)
- (void)keepAnimatedWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay usingSpringWithDamping:(CGFloat)dampingRatio initialSpringVelocity:(CGFloat)velocity options:(UIViewAnimationOptions)options layout:(void (^)(void))animations completion:(void (^)(BOOL finished))completion;

/// Animation methods allowing you to modify all above attributes (or even constraints directly) animatedly.
/// Receiver automatically calls `-layoutIfNeeded` right in the animation block.
/// All animations are scheduled on main queue with given delay. The layout code itself is executed after the delay (this is different than in UIView animation methods)
- (void)keepNotAnimated:(void (^)(void))layout;


#pragma mark Common Superview
/// Traverses superviews and returns the first common for both, the receiver and the argument.
- (UIView *)commonSuperview:(UIView *)anotherView;


#pragma mark Convenience Auto Layout
/// Methods not used by Keep Layout directly, but are provided for convenience purpose.
/// Add single constraint.
- (void)addConstraintToCommonSuperview:(NSLayoutConstraint *)constraint;
/// Methods not used by Keep Layout directly, but are provided for convenience purpose.
/// Remove single constraint.
- (void)removeConstraintFromCommonSuperview:(NSLayoutConstraint *)constraint;

/// Methods not used by Keep Layout directly, but are provided for convenience purpose.
/// Add collection of constraints.
- (void)addConstraintsToCommonSuperview:(id<NSFastEnumeration>)constraints;
/// Methods not used by Keep Layout directly, but are provided for convenience purpose.
/// Remove collection of constraints.
- (void)removeConstraintsFromCommonSuperview:(id<NSFastEnumeration>)constraints;



@end
