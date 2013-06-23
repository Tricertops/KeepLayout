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



@interface UIView (KeepLayout)



#pragma mark Dimensions
- (KeepAttribute *)keepWidth;
- (KeepAttribute *)keepHeight;

#pragma mark Superview Insets
- (KeepAttribute *)keepLeftInset;
- (KeepAttribute *)keepRightInset;
- (KeepAttribute *)keepTopInset;
- (KeepAttribute *)keepBottomInset;
- (KeepAttribute *)keepInsets;

#pragma mark Center
- (KeepAttribute *)keepHorizontalCenter;
- (KeepAttribute *)keepVerticalCenter;
- (KeepAttribute *)keepCenter;

#pragma mark Offsets
/// Usage: `view.keepLeftOffset(anotherView).equal = KeepRequired(10);`
- (KeepAttribute *(^)(UIView *))keepLeftOffset;
- (KeepAttribute *(^)(UIView *))keepRightOffset;
- (KeepAttribute *(^)(UIView *))keepTopOffset;
- (KeepAttribute *(^)(UIView *))keepBottomOffset;

#pragma mark Alignments
/// Usage: `view.keepLeftAlign(anotherView).equal = KeepRequired(0);`
/// Simplified: `view.keepLeftAlign(anotherView);` (".equal = KeepRequired(0)" is default)
- (KeepAttribute *(^)(UIView *))keepLeftAlign;
- (KeepAttribute *(^)(UIView *))keepRightAlign;
- (KeepAttribute *(^)(UIView *))keepTopAlign;
- (KeepAttribute *(^)(UIView *))keepBottomAlign;
- (KeepAttribute *(^)(UIView *))keepBaselineAlign;


#pragma mark Animating Constraints
- (void)keepAnimatedWithDuration:(NSTimeInterval)duration layout:(void(^)(void))animations;
- (void)keepAnimatedWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay layout:(void(^)(void))animations;
- (void)keepAnimatedWithDuration:(NSTimeInterval)duration delay:(NSTimeInterval)delay options:(UIViewAnimationOptions)options layout:(void(^)(void))animations completion:(void(^)(BOOL finished))completion;


#pragma mark Common Superview
/// Traverses superviews and returns the first common for both, the receiver and the argument.
- (UIView *)commonSuperview:(UIView *)anotherView;

#pragma mark Convenience Auto Layout
/// Add/remove single constraint.
- (void)addConstraintToCommonSuperview:(NSLayoutConstraint *)constraint;
- (void)removeConstraintFromCommonSuperview:(NSLayoutConstraint *)constraint;
/// Add/remove collection of constraints.
- (void)addConstraintsToCommonSuperview:(id<NSFastEnumeration>)constraints;
- (void)removeConstraintsFromCommonSuperview:(id<NSFastEnumeration>)constraints;



@end
