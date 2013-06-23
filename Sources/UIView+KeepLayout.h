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



- (KeepAttribute *)keepWidth;
- (KeepAttribute *)keepHeight;

- (KeepAttribute *)keepLeftInset;
- (KeepAttribute *)keepRightInset;
- (KeepAttribute *)keepTopInset;
- (KeepAttribute *)keepBottomInset;
- (KeepAttribute *)keepInsets;

- (KeepAttribute *)keepHorizontalCenter;
- (KeepAttribute *)keepVerticalCenter;
- (KeepAttribute *)keepCenter;

/// Usage: `view.keepLeftOffset(anotherView).equal = KeepRequired(10);`
- (KeepAttribute *(^)(UIView *))keepLeftOffset;
- (KeepAttribute *(^)(UIView *))keepRightOffset;
- (KeepAttribute *(^)(UIView *))keepTopOffset;
- (KeepAttribute *(^)(UIView *))keepBottomOffset;


/// Traverses superviews and returns the first common for both, the receiver and the argument.
- (UIView *)commonSuperview:(UIView *)anotherView;

/// Add/remove single constraint.
- (void)addConstraintToCommonSuperview:(NSLayoutConstraint *)constraint;
- (void)removeConstraintFromCommonSuperview:(NSLayoutConstraint *)constraint;

/// Add/remove collection of constraints.
- (void)addConstraintsToCommonSuperview:(id<NSFastEnumeration>)constraints;
- (void)removeConstraintsFromCommonSuperview:(id<NSFastEnumeration>)constraints;

@end
