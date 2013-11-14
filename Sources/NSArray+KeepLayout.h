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





#pragma mark -
#pragma mark Dimensions: Grouped

/// Grouped attribute for Width of contained views.
@property (nonatomic, readonly) KeepAttribute *keepWidth;

/// Grouped attribute for Height of contained views.
@property (nonatomic, readonly) KeepAttribute *keepHeight;

/// Grouped attribute for Size (Width + Height) of contained views.
@property (nonatomic, readonly) KeepAttribute *keepSize;

/// Grouped attribute for Aspect Ratio of contained views.
@property (nonatomic, readonly) KeepAttribute *keepAspectRatio;

/// Grouped attribute for Relative Width of contained views.
@property (nonatomic, readonly) KeepRelatedAttributeBlock keepWidthTo;

/// Grouped attribute for Relative Height of contained views.
@property (nonatomic, readonly) KeepRelatedAttributeBlock keepHeightTo;

/// Grouped attribute for Relative Size of contained views.
@property (nonatomic, readonly) KeepRelatedAttributeBlock keepSizeTo;



#pragma mark Dimensions: Forwarded

/// Forwards to contained views.
- (void)keepSize:(CGSize)size priority:(KeepPriority)priority;

/// Forwards to contained views. Use is discouraged.
- (void)keepSize:(CGSize)size;



#pragma mark Dimensions: Batch Convenience
/// Convenience methods applied to whole array, in the order they are in array.

/// All contained views will share the same Width using given priority. Width of the first is tied to Width of the second and so on.
- (void)keepWidthsEqualWithPriority:(KeepPriority)priority;

/// All contained views will share the same Width using Required priority. Use is discouraged. Width of the first is tied to Width of the second and so on.
- (void)keepWidthsEqual;

/// All contained views will share the same Width using given priority. Height of the first is tied to Height of the second and so on.
- (void)keepHeightsEqualWithPriority:(KeepPriority)priority;

/// All contained views will share the same Height using Required priority. Use is discouraged. Height of the first is tied to Height of the second and so on.
- (void)keepHeightsEqual;

/// All contained views will share the same Size (Width + Height) using given priority. Width of the first is tied to Width of the second and so on.
- (void)keepSizesEqualWithPriority:(KeepPriority)priority;

/// All contained views will share the same Size using Required priority. Use is discouraged. Size of the first is tied to Size of the second and so on.
- (void)keepSizesEqual;





#pragma mark -
#pragma mark Superview Insets: Grouped

/// Grouped attribute for Left Inset of contained views.
@property (nonatomic, readonly) KeepAttribute *keepLeftInset;

/// Grouped attribute for Right Inset of contained views.
@property (nonatomic, readonly) KeepAttribute *keepRightInset;

/// Grouped attribute for Top Inset of contained views.
@property (nonatomic, readonly) KeepAttribute *keepTopInset;

/// Grouped attribute for Bottom Inset of contained views.
@property (nonatomic, readonly) KeepAttribute *keepBottomInset;

/// Grouped attribute for All Insets of contained views.
@property (nonatomic, readonly) KeepAttribute *keepInsets;

/// Grouped attribute for Horizontal Insets of contained views.
@property (nonatomic, readonly) KeepAttribute *keepHorizontalInsets;

/// Grouped attribute for Vertical Insets of contained views.
@property (nonatomic, readonly) KeepAttribute *keepVerticalInsets;



#pragma mark Superview Insets: Forwarded

/// Forwards to contained views.
- (void)keepInsets:(UIEdgeInsets)insets priority:(KeepPriority)priority;

/// Forwards to contained views. Use is discouraged.
- (void)keepInsets:(UIEdgeInsets)insets;





#pragma mark -
#pragma mark Center: Grouped

/// Grouped attribute for Horizontal Center of contained views.
@property (nonatomic, readonly) KeepAttribute *keepHorizontalCenter;

/// Grouped attribute for Vertical Center of contained views.
@property (nonatomic, readonly) KeepAttribute *keepVerticalCenter;

/// Grouped attribute for Both Center Axis of contained views.
@property (nonatomic, readonly) KeepAttribute *keepCenter;



#pragma mark Center: Forwarded

/// Forwards to contained views.
- (void)keepCenteredWithPriority:(KeepPriority)priority;

/// Forwards to contained views. Use is discouraged.
- (void)keepCentered;

/// Forwards to contained views.
- (void)keepHorizontallyCenteredWithPriority:(KeepPriority)priority;

/// Forwards to contained views. Use is discouraged.
- (void)keepHorizontallyCentered;

/// Forwards to contained views.
- (void)keepVerticallyCenteredWithPriority:(KeepPriority)priority;

/// Forwards to contained views. Use is discouraged.
- (void)keepVerticallyCentered;

/// Forwards to contained views.
- (void)keepCenter:(CGPoint)center priority:(KeepPriority)priority;

/// Forwards to contained views. Use is discouraged.
- (void)keepCenter:(CGPoint)center;





#pragma mark -
#pragma mark Offsets: Grouped

/// Grouped attribute for Left Offset of contained views.
@property (nonatomic, readonly) KeepRelatedAttributeBlock keepLeftOffset;

/// Grouped attribute for Right Offset of contained views.
@property (nonatomic, readonly) KeepRelatedAttributeBlock keepRightOffset;

/// Grouped attribute for Top Offset of contained views.
@property (nonatomic, readonly) KeepRelatedAttributeBlock keepTopOffset;

/// Grouped attribute for Bottom Offset of contained views.
@property (nonatomic, readonly) KeepRelatedAttributeBlock keepBottomOffset;



#pragma mark Offsets: Batch Convenience
/// Convenience methods applied to whole array, in the order they are in array.

/// All contained views will share the same Horizontal Offset (left to right) using given priority. First view will keep Right Offset to second view and so on.
- (void)keepHorizontalOffsets:(KeepValue)value;

/// All contained views will share the same Vertical Offset (top to bottom) using given priority. First view will keep Bottom Offset to second view and so on.
- (void)keepVerticalOffsets:(KeepValue)value;





#pragma mark -
#pragma mark Alignments: Grouped

/// Grouped attribute for Left Alignment of contained views.
@property (nonatomic, readonly) KeepRelatedAttributeBlock keepLeftAlignTo;

/// Grouped attribute for Right Alignment of contained views.
@property (nonatomic, readonly) KeepRelatedAttributeBlock keepRightAlignTo;

/// Grouped attribute for Top Alignment of contained views.
@property (nonatomic, readonly) KeepRelatedAttributeBlock keepTopAlignTo;

/// Grouped attribute for Bottom Alignment of contained views.
@property (nonatomic, readonly) KeepRelatedAttributeBlock keepBottomAlignTo;

/// Grouped attribute for Vertical Center Alignment of contained views.
@property (nonatomic, readonly) KeepRelatedAttributeBlock keepVerticalAlignTo;

/// Grouped attribute for Horizontal Center Alignment of contained views.
@property (nonatomic, readonly) KeepRelatedAttributeBlock keepHorizontalAlignTo;

/// Grouped attribute for Baseline Alignment of contained views.
@property (nonatomic, readonly) KeepRelatedAttributeBlock keepBaselineAlignTo;


#pragma mark Alignments: Batch Convenience
/// Convenience methods applied to whole array, in the order they are in array.

/// All contained views will share the same Left Alignment. First view will keep Left Alignment (with offset) with second view and so on.
- (void)keepLeftAlignments:(KeepValue)value;

/// All contained views will be aligned to the left. First view will keep Left Alignment with second view and so on.
- (void)keepLeftAligned;

/// All contained views will share the same Right Alignment. First view will keep Right Alignment (with offset) with second view and so on.
- (void)keepRightAlignments:(KeepValue)value;

/// All contained views will be aligned to the right. First view will keep Right Alignment with second view and so on.
- (void)keepRightAligned;

/// All contained views will share the same Top Alignment. First view will keep Top Alignment (with offset) with second view and so on.
- (void)keepTopAlignments:(KeepValue)value;

/// All contained views will be aligned to the top. First view will keep Top Alignment with second view and so on.
- (void)keepTopAligned;

/// All contained views will share the same Bottom Alignment. First view will keep Bottom Alignment (with offset) with second view and so on.
- (void)keepBottomAlignments:(KeepValue)value;

/// All contained views will be aligned to the bottom. First view will keep Bottom Alignment with second view and so on.
- (void)keepBottomAligned;

/// All contained views will share the same Vertical Center Alignment. First view will keep Vertical Center Alignment (with offset) with second view and so on.
- (void)keepVerticalAlignments:(KeepValue)value;

/// All contained views will vertically aligned. First view will keep Vertical Center Alignment with second view and so on.
- (void)keepVerticallyAligned;

/// All contained views will share the same Horizontal Center Alignment. First view will keep Horizontal Center Alignment (with offset) with second view and so on.
- (void)keepHorizontalAlignments:(KeepValue)value;

/// All contained views will horizontally aligned. First view will keep Horizontal Center Alignment with second view and so on.
- (void)keepHorizontallyAligned;

/// All contained views will share the same Baseline Alignment. First view will keep Baseline Center Alignment (with offset) with second view and so on.
- (void)keepBaselineAlignments:(KeepValue)value;

/// All contained views will baseline aligned. First view will keep baseline Alignment with second view and so on.
- (void)keepBaselineAligned;





@end
