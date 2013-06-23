//
//  NSArray+KeepLayout.h
//  Keep Layout
//
//  Created by Martin Kiss on 23.6.13.
//  Copyright (c) 2013 Triceratops. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

#import "KeepTypes.h"

@class KeepAttribute;





/// Provides similar methods than UIView+KeepLayout. Works only on arrays of UIViews.
/// Most of the methods invokes the same selector on contained views and returns group proxy attribute.
/// Setting values of this group will set attributes to all attributes in the group.
/// For method descriptions see method in UIView+KeepLayout with the same name.
/// In addition, for every relative attribute there is convenience method, that applies on views in the array in the order.
@interface NSArray (KeepLayout)





#pragma mark Dimensions

- (KeepAttribute *)keepWidth;
- (KeepAttribute *)keepHeight;

- (KeepAttribute *)keepSize;

- (void)keepSize:(CGSize)size;
- (void)keepSize:(CGSize)size priority:(KeepPriority)priority;

- (KeepAttribute *)keepAspectRatio;

- (KeepAttribute *(^)(UIView *))keepWidthTo;
- (KeepAttribute *(^)(UIView *))keepHeightTo;

- (KeepAttribute *(^)(UIView *))keepSizeTo;



#pragma mark Superview Insets

- (KeepAttribute *)keepLeftInset;
- (KeepAttribute *)keepRightInset;
- (KeepAttribute *)keepTopInset;
- (KeepAttribute *)keepBottomInset;

- (KeepAttribute *)keepInsets;
- (KeepAttribute *)keepHorizontalInsets;
- (KeepAttribute *)keepVerticalInsets;

- (void)keepInsets:(UIEdgeInsets)insets;
- (void)keepInsets:(UIEdgeInsets)insets priority:(KeepPriority)priority;



#pragma mark Center

- (KeepAttribute *)keepHorizontalCenter;
- (KeepAttribute *)keepVerticalCenter;

- (KeepAttribute *)keepCenter;

- (void)keepCentered;
- (void)keepCenteredWithPriority:(KeepPriority)priority;
- (void)keepCenter:(CGPoint)center;
- (void)keepCenter:(CGPoint)center priority:(KeepPriority)priority;



#pragma mark Offsets

- (KeepAttribute *(^)(UIView *))keepLeftOffset;
- (KeepAttribute *(^)(UIView *))keepRightOffset;
- (KeepAttribute *(^)(UIView *))keepTopOffset;
- (KeepAttribute *(^)(UIView *))keepBottomOffset;



#pragma mark Alignments

- (KeepAttribute *(^)(UIView *))keepLeftAlignTo;
- (KeepAttribute *(^)(UIView *))keepRightAlignTo;
- (KeepAttribute *(^)(UIView *))keepTopAlignTo;
- (KeepAttribute *(^)(UIView *))keepBottomAlignTo;

- (KeepAttribute *(^)(UIView *))keepVerticalAlignTo;
- (KeepAttribute *(^)(UIView *))keepHorizontalAlignTo;

- (KeepAttribute *(^)(UIView *))keepBaselineAlignTo;





@end
