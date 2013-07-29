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

/// Convenience methods applied to whole array, in the order they are in array.
- (void)keepWidthsEqualWithPriority:(KeepPriority)priority;
- (void)keepHeightsEqualWithPriority:(KeepPriority)priority;
- (void)keepSizesEqualWithPriority:(KeepPriority)priority;

// Methods which invoke the above with `KeepPriorityRequired` value. Use of these is discouraged.
- (void)keepWidthsEqual;
- (void)keepWidthsEqualWithPriority:(KeepPriority)priority;
- (void)keepHeightsEqual;
//TODO: keepHeightsEqualWithPriority:
- (void)keepSizesEqual;
//TODO: keepSizesEqualWithPriority:



#pragma mark Superview Insets

- (KeepAttribute *)keepLeftInset;
- (KeepAttribute *)keepRightInset;
- (KeepAttribute *)keepTopInset;
- (KeepAttribute *)keepBottomInset;

- (KeepAttribute *)keepInsets;
- (KeepAttribute *)keepHorizontalInsets;
- (KeepAttribute *)keepVerticalInsets;

- (void)keepInsets:(UIEdgeInsets)insets priority:(KeepPriority)priority;

// Method which invoke the above with `KeepPriorityRequired` value. Use of this is discouraged.
- (void)keepInsets:(UIEdgeInsets)insets;



#pragma mark Center

- (KeepAttribute *)keepHorizontalCenter;
- (KeepAttribute *)keepVerticalCenter;

- (KeepAttribute *)keepCenter;

- (void)keepCenteredWithPriority:(KeepPriority)priority;
- (void)keepCenter:(CGPoint)center priority:(KeepPriority)priority;

// Methods which invoke the above with `KeepPriorityRequired` value. Use of these is discouraged.
- (void)keepCentered;
- (void)keepCenter:(CGPoint)center;



#pragma mark Offsets

- (KeepAttribute *(^)(UIView *))keepLeftOffset;
- (KeepAttribute *(^)(UIView *))keepRightOffset;
- (KeepAttribute *(^)(UIView *))keepTopOffset;
- (KeepAttribute *(^)(UIView *))keepBottomOffset;

/// Convenience methods applied to whole array, in the order they are in array.
- (void)keepHorizontalOffsets:(KeepValue)value;
- (void)keepVerticalOffsets:(KeepValue)value;



#pragma mark Alignments

- (KeepAttribute *(^)(UIView *))keepLeftAlignTo;
- (KeepAttribute *(^)(UIView *))keepRightAlignTo;
- (KeepAttribute *(^)(UIView *))keepTopAlignTo;
- (KeepAttribute *(^)(UIView *))keepBottomAlignTo;

- (KeepAttribute *(^)(UIView *))keepVerticalAlignTo;
- (KeepAttribute *(^)(UIView *))keepHorizontalAlignTo;

- (KeepAttribute *(^)(UIView *))keepBaselineAlignTo;

/// Convenience methods applied to whole array, in the order they are in array.
- (void)keepLeftAlignments:(KeepValue)value;
- (void)keepRightAlignments:(KeepValue)value;
- (void)keepTopAlignments:(KeepValue)value;
- (void)keepBottomAlignments:(KeepValue)value;
- (void)keepVerticalAlignments:(KeepValue)value;
- (void)keepHorizontalAlignments:(KeepValue)value;
- (void)keepBaselineAlignments:(KeepValue)value;

// Methods which invoke the above with `KeepRequired(0)` value. Use of these is discouraged.
- (void)keepLeftAligned;
- (void)keepRightAligned;
- (void)keepTopAligned;
- (void)keepBottomAligned;
- (void)keepVerticallyAligned;
- (void)keepHorizontallyAligned;
- (void)keepBaselineAligned;





@end
