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




/**
 Category that provides very easy access to all Auto Layout features through abstraction above NSLayoutConstraints.
 
 Usage of methods returning KeepAttribute:
 \code
 view.keepWidth.equal = KeepRequired(320);
 \endcode
 
 Usage of methods returning block that takes another view:
 \code
 view.keepWidthTo(anotherView).equal = KeepRequired(2); // 2x wider
 \endcode
 
 **/
@interface UIView (KeepLayout)





#pragma mark -
#pragma mark Dimensions: Core
/// Attributes representing internal size of the receiver.

/// Width of the receiver.
- (KeepAttribute *)keepWidth;

/// Height of the receiver.
- (KeepAttribute *)keepHeight;

/// Aspect Ratio of receiver's dimensions in the order Width/Height. For example 16/9 or 4/3.
- (KeepAttribute *)keepAspectRatio;

/// Relative Width to other view. Value is multiplier of the other view's dimension. Both views must be in the same hierarchy.
- (KeepAttribute *(^)(UIView *))keepWidthTo;

/// Relative Height to other view. Value is multiplier of the other view's dimension. Both views must be in the same hierarchy.
- (KeepAttribute *(^)(UIView *))keepHeightTo;



#pragma mark Dimensions: Convenience
/// Convenience methods for setting both dimensions at once.

/// Grouped proxy attribute for Width and Height.
- (KeepAttribute *)keepSize;

/// Grouped proxy attribute for Relative Width and Height. Values are multipliers of the other view's dimensions. Both views must be in the same hierarchy.
- (KeepAttribute *(^)(UIView *))keepSizeTo;

/// Sets custom Width and Height at once with given priority.
- (void)keepSize:(CGSize)size priority:(KeepPriority)priority;

/// Sets custom Width and Height at once with Required priority. Use is discouraged.
- (void)keepSize:(CGSize)size;





#pragma mark -
#pragma mark Superview Insets: Core
/// Attributes representing internal inset (margin or padding) of the receive to its current superview.

/// Left Inset of the receiver in its current superview.
- (KeepAttribute *)keepLeftInset;

/// Right Inset of the receiver in its current superview. Values are inverted to Right-to-Left direction.
- (KeepAttribute *)keepRightInset;

/// Top Inset of the receiver in its current superview.
- (KeepAttribute *)keepTopInset;

/// Bottom Inset of the receiver in its current superview. Values are inverted to Bottom-to-Top direction.
- (KeepAttribute *)keepBottomInset;



#pragma mark Superview Insets: Convenience
/// Convenience methods for setting all insets at once.

/// Grouped proxy attribute for Top, Bottom, Left and Right Inset.
- (KeepAttribute *)keepInsets;

/// Grouped proxy attribute for Left and Right Inset.
- (KeepAttribute *)keepHorizontalInsets;

/// Grouped proxy attribute for Top and Bottom Inset.
- (KeepAttribute *)keepVerticalInsets;

/// Sets custom Insets using given priority.
- (void)keepInsets:(UIEdgeInsets)insets priority:(KeepPriority)priority;

/// Sets custom Insets using Required priority. Use is discouraged.
- (void)keepInsets:(UIEdgeInsets)insets;





#pragma mark -
#pragma mark Center: Core
/// Attributes representing relative position of the receiver in its current superview.

/// Horizontal Center of the receiver in its current superview (X axis). Value is multiplier of superview's width, so 0.5 is middle.
- (KeepAttribute *)keepHorizontalCenter;

/// Vertical Center of the receiver in its current superview (Y axis). Value is multiplier of superview's height, so 0.5 is middle.
- (KeepAttribute *)keepVerticalCenter;



#pragma mark Center: Convenience
/// Convenience methods for both center axis at once or with default values.

/// Grouped proxy attribute for Horizontal and Vertical Center. Value is multiplier of superview's dimensions, so 0.5 is middle.
- (KeepAttribute *)keepCenter;

/// Sets both Center axis to 0.5 with given priority.
- (void)keepCenteredWithPriority:(KeepPriority)priority;

/// Sets both Center axis to 0.5 with Required priority. Use is discouraged.
- (void)keepCentered;

/// Sets Horizontal Center axis to 0.5 with given priority.
- (void)keepHorizontallyCenteredWithPriority:(KeepPriority)priority;

/// Sets Horizontal Center axis to 0.5 with Required priority. Use is discouraged.
- (void)keepHorizontallyCentered;

/// Sets Vertical Center axis to 0.5 with given priority.
- (void)keepVerticallyCenteredWithPriority:(KeepPriority)priority;

/// Sets Vertical Center axis to 0.5 with Required priority. Use is discouraged.
- (void)keepVerticallyCentered;

/// Sets both center axis using given priority. Point values are multiplier of superview's dimensions, so 0.5 is middle.
- (void)keepCenter:(CGPoint)center priority:(KeepPriority)priority;

/// Sets both center axis using Required priority. Use is discouraged. Point values are multiplier of superview's dimensions, so 0.5 is middle.
- (void)keepCenter:(CGPoint)center;





#pragma mark -
#pragma mark Offsets: Core
/// Attributes representing offset (padding or distance) of two views.

/// Left Offset to other view. Views must be in the same view hierarchy.
- (KeepAttribute *(^)(UIView *))keepLeftOffsetTo;

/// Right Offset to other view. Views must be in the same view hierarchy. Identical to Left Offset in reversed direction.
- (KeepAttribute *(^)(UIView *))keepRightOffsetTo;

/// Top Offset to other view. Views must be in the same view hierarchy.
- (KeepAttribute *(^)(UIView *))keepTopOffsetTo;

/// Bottom Offset to other view. Views must be in the same view hierarchy. Identical to Top Offset in reversed direction.
- (KeepAttribute *(^)(UIView *))keepBottomOffsetTo;





#pragma mark -
#pragma mark Alignments: Core
/// Attributes representing alignment of two views. You align view usually to 0 offset, but this can be changed.

/// Left Alignment with other view. Views must be in the same view hierarchy. Value is offset of the receiver from the other view.
- (KeepAttribute *(^)(UIView *))keepLeftAlignTo;

/// Right Alignment with other view. Views must be in the same view hierarchy. Value is offset of the receiver from the other view. Values are inverted to Right-to-Left direction.
- (KeepAttribute *(^)(UIView *))keepRightAlignTo;

/// Top Alignment with other view. Views must be in the same view hierarchy. Value is offset of the receiver from the other view.
- (KeepAttribute *(^)(UIView *))keepTopAlignTo;

/// Bottom Alignment with other view. Views must be in the same view hierarchy. Value is offset of the receiver from the other view. Values are inverted to Bottom-to-Top direction.
- (KeepAttribute *(^)(UIView *))keepBottomAlignTo;

/// Vertical Center Alignment with other view, modifies the X position. Views must be in the same view hierarchy. Value is offset of the receiver from the other view.
- (KeepAttribute *(^)(UIView *))keepVerticalAlignTo;

/// Horizontal Center Alignment with other view, modifies the Y position. Views must be in the same view hierarchy. Value is offset of the receiver from the other view.
- (KeepAttribute *(^)(UIView *))keepHorizontalAlignTo;

/// Baseline Alignments with two views. Not all views have baseline. Values are inverted to Bottom-to-Top direction, so positive offset moves the receiver up.
- (KeepAttribute *(^)(UIView *))keepBaselineAlignTo;



#pragma mark Alignments: Convenience
/// Convenience methods for setting multiple alignments at once.

/// Sets all 4 edge alignments with other view with given insets and priority.
- (void)keepEdgeAlignTo:(UIView *)view insets:(UIEdgeInsets)insets withPriority:(KeepPriority)priority;

/// Sets all 4 edge alignments with other view with given insets and Required priority. Use is discouraged.
- (void)keepEdgeAlignTo:(UIView *)view insets:(UIEdgeInsets)insets;

/// Sets all 4 edge alignments with other view with zero insets and Required priority. Use is discouraged.
- (void)keepEdgeAlignTo:(UIView *)view;

/// Sets both center alignments with other view view given offset and priority.
- (void)keepCenterAlignTo:(UIView *)view offset:(UIOffset)offset withPriority:(KeepPriority)priority;

/// Sets both center alignments with other view view given offset and Required priority.
- (void)keepCenterAlignTo:(UIView *)view offset:(UIOffset)offset;

/// Sets both center alignments with other view view zero offset and Required priority.
- (void)keepCenterAlignTo:(UIView *)view;





#pragma mark -
#pragma mark Animations
/// Animation methods allowing you to modify all above attributes (or even constraints directly) animatedly. All animations are scheduled on main queue with given or zero delay. The layout code itself is executed after the delay, which is different than in UIView animation methods. This behavior is needed, because of different nature of constraint-based layouting and allows you to schedule animations in the same update cycle as your main layout.

/// Animate layout changes. Receiver automatically calls `-layoutIfNeeded` after the animation block. Animation is scheduled on Main Queue with zero delay, so the block not executed immediatelly.
- (void)keepAnimatedWithDuration:(NSTimeInterval)duration layout:(void(^)(void))animations;

/// Animate layout changes with delay. Receiver automatically calls `-layoutIfNeeded` after the animation block. Animation is scheduled on Main Queue with given delay.
- (void)keepAnimatedWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay layout:(void(^)(void))animations;

/// Animate layout changes with delay, options and completion. Receiver automatically calls `-layoutIfNeeded` after the animation block. Animation is scheduled on Main Queue with given delay.
- (void)keepAnimatedWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay options:(UIViewAnimationOptions)options layout:(void(^)(void))animations completion:(void(^)(BOOL finished))completion;

/// Animate layout changes with spring behavior, delay, options and completion. Receiver automatically calls `-layoutIfNeeded` after the animation block. Animation is scheduled on Main Queue with given delay.
- (void)keepAnimatedWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay usingSpringWithDamping:(CGFloat)dampingRatio initialSpringVelocity:(CGFloat)velocity options:(UIViewAnimationOptions)options layout:(void (^)(void))animations completion:(void (^)(BOOL finished))completion;

/// Prevent animating layout changes in the block. Due to different nature of constraint-based layouting, this may not work as you may expect.
- (void)keepNotAnimated:(void (^)(void))layout;





#pragma mark -
#pragma mark Common Superview

/// Traverses superviews and returns the first common for both views.
- (UIView *)commonSuperview:(UIView *)anotherView;





#pragma mark Convenience Auto Layout
/// Methods not used by Keep Layout directly, but are provided for convenience purpose.

/// Finds common superview for all participated views and adds a single constraint to it.
- (void)addConstraintToCommonSuperview:(NSLayoutConstraint *)constraint;

/// Finds common superview for all participated views and removes a single constraint from it.
- (void)removeConstraintFromCommonSuperview:(NSLayoutConstraint *)constraint;

/// Finds common superview for all participated views and adds all given constraint to it.
- (void)addConstraintsToCommonSuperview:(id<NSFastEnumeration>)constraints;

/// Finds common superview for all participated views and removes all given constraint from it.
- (void)removeConstraintsFromCommonSuperview:(id<NSFastEnumeration>)constraints;





@end
