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
#import "UIView+KeepLayout.h"

@class KeepAttribute;





/**
 Provides similar methods than UIView+KeepLayout. Works only on arrays of UIViews. For method descriptions see method in UIView+KeepLayout with the same name.
 
 Most of the methods invokes the same selector on contained views and returns group proxy attribute. Setting values of this group will set attributes to all attributes in the group.
 
 In addition, for every relative attribute there is convenience method, that applies on views in the array in the order.
 **/
@interface NSArray (KeepLayout)





#pragma mark Dimensions

@property (nonatomic, readonly) KeepAttribute *keepWidth;
@property (nonatomic, readonly) KeepAttribute *keepHeight;

@property (nonatomic, readonly) KeepAttribute *keepSize;

- (void)keepSize:(CGSize)size;
- (void)keepSize:(CGSize)size priority:(KeepPriority)priority;

@property (nonatomic, readonly) KeepAttribute *keepAspectRatio;

@property (nonatomic, readonly) KeepRelatedAttributeBlock keepWidthTo;
@property (nonatomic, readonly) KeepRelatedAttributeBlock keepHeightTo;

@property (nonatomic, readonly) KeepRelatedAttributeBlock keepSizeTo;

/// Convenience methods applied to whole array, in the order they are in array.
- (void)keepWidthsEqualWithPriority:(KeepPriority)priority;
- (void)keepHeightsEqualWithPriority:(KeepPriority)priority;
- (void)keepSizesEqualWithPriority:(KeepPriority)priority;

// Methods which invoke the above with `KeepPriorityRequired` value. Use of these is discouraged.
- (void)keepWidthsEqual;
- (void)keepHeightsEqual;
- (void)keepSizesEqual;



#pragma mark Superview Insets

@property (nonatomic, readonly) KeepAttribute *keepLeftInset;
@property (nonatomic, readonly) KeepAttribute *keepRightInset;
@property (nonatomic, readonly) KeepAttribute *keepTopInset;
@property (nonatomic, readonly) KeepAttribute *keepBottomInset;

@property (nonatomic, readonly) KeepAttribute *keepInsets;
@property (nonatomic, readonly) KeepAttribute *keepHorizontalInsets;
@property (nonatomic, readonly) KeepAttribute *keepVerticalInsets;

- (void)keepInsets:(UIEdgeInsets)insets priority:(KeepPriority)priority;

// Method which invoke the above with `KeepPriorityRequired` value. Use of this is discouraged.
- (void)keepInsets:(UIEdgeInsets)insets;



#pragma mark Center

@property (nonatomic, readonly) KeepAttribute *keepHorizontalCenter;
@property (nonatomic, readonly) KeepAttribute *keepVerticalCenter;

@property (nonatomic, readonly) KeepAttribute *keepCenter;

- (void)keepCenteredWithPriority:(KeepPriority)priority;
- (void)keepHorizontallyCenteredWithPriority:(KeepPriority)priority;
- (void)keepVerticallyCenteredWithPriority:(KeepPriority)priority;
- (void)keepCenter:(CGPoint)center priority:(KeepPriority)priority;

// Methods which invoke the above with `KeepPriorityRequired` value. Use of these is discouraged.
- (void)keepCentered;
- (void)keepHorizontallyCentered;
- (void)keepVerticallyCentered;
- (void)keepCenter:(CGPoint)center;



#pragma mark Offsets

@property (nonatomic, readonly) KeepRelatedAttributeBlock keepLeftOffset;
@property (nonatomic, readonly) KeepRelatedAttributeBlock keepRightOffset;
@property (nonatomic, readonly) KeepRelatedAttributeBlock keepTopOffset;
@property (nonatomic, readonly) KeepRelatedAttributeBlock keepBottomOffset;

/// Convenience methods applied to whole array, in the order they are in array.
- (void)keepHorizontalOffsets:(KeepValue)value;
- (void)keepVerticalOffsets:(KeepValue)value;



#pragma mark Alignments

@property (nonatomic, readonly) KeepRelatedAttributeBlock keepLeftAlignTo;
@property (nonatomic, readonly) KeepRelatedAttributeBlock keepRightAlignTo;
@property (nonatomic, readonly) KeepRelatedAttributeBlock keepTopAlignTo;
@property (nonatomic, readonly) KeepRelatedAttributeBlock keepBottomAlignTo;

@property (nonatomic, readonly) KeepRelatedAttributeBlock keepVerticalAlignTo;
@property (nonatomic, readonly) KeepRelatedAttributeBlock keepHorizontalAlignTo;

@property (nonatomic, readonly) KeepRelatedAttributeBlock keepBaselineAlignTo;

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
