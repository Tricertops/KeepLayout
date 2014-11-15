//
//  KeepTypes.h
//  Keep Layout
//
//  Created by Martin Kiss on 28.1.13.
//  Copyright (c) 2013 Triceratops. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>



#define KeepAssert(CONDITION, DESCRIPTION...)   NSCAssert((CONDITION), @"Keep Layout: " DESCRIPTION)
#define KeepParameterAssert(CONDITION)          NSCAssert((CONDITION), @"Keep Layout: " @"Invalid parameter not satisfying: %s", #CONDITION)



#if TARGET_OS_IPHONE

#import <UIKit/UIKit.h>
#define KPView                  UIView
#define KPEdgeInsets            UIEdgeInsets
#define KPEdgeInsetsZero        UIEdgeInsetsZero

#define KPOffset                UIOffset
#define KPOffsetZero            UIOffsetZero

/// Use custom names.
typedef float KeepPriority;
static const KeepPriority KeepPriorityRequired = UILayoutPriorityRequired;
static const KeepPriority KeepPriorityHigh = UILayoutPriorityDefaultHigh;
static const KeepPriority KeepPriorityLow = UILayoutPriorityDefaultLow;
static const KeepPriority KeepPriorityFitting = UILayoutPriorityFittingSizeLevel;

#else

#import <AppKit/AppKit.h>
#define KPView                  NSView
#define KPEdgeInsets            NSEdgeInsets

extern const KPEdgeInsets KPEdgeInsetsZero;

typedef struct KPOffset {
    CGFloat horizontal, vertical;
} KPOffset;

static inline KPOffset KPOffsetMake(CGFloat horizontal, CGFloat vertical) {
    KPOffset offset = {horizontal, vertical};
    return offset;
}

extern const KPOffset KPOffsetZero;

/// Use custom names.
typedef float KeepPriority;
static const KeepPriority KeepPriorityRequired = NSLayoutPriorityRequired;
static const KeepPriority KeepPriorityHigh = NSLayoutPriorityDefaultHigh;
static const KeepPriority KeepPriorityLow = NSLayoutPriorityDefaultLow;
static const KeepPriority KeepPriorityFitting = NSLayoutPriorityFittingSizeCompression;

/// OS X doesn’t have margins.
#define NSLayoutAttributeTopMargin      NSLayoutAttributeTop
#define NSLayoutAttributeLeftMargin     NSLayoutAttributeLeft
#define NSLayoutAttributeRightMargin    NSLayoutAttributeRight
#define NSLayoutAttributeBottomMargin   NSLayoutAttributeBottom
#define NSLayoutAttributeLeadingMargin  NSLayoutAttributeLeading
#define NSLayoutAttributeTrailingMargin NSLayoutAttributeTrailing

#define NSLayoutAttributeFirstBaseline  NSLayoutAttributeBaseline
#define NSLayoutAttributeLastBaseline   NSLayoutAttributeBaseline

#endif



extern NSString *KeepPriorityDescription(KeepPriority);



#pragma mark Value
/// Represents a value with associated priority. Used as values for attributes and underlaying constraints.
typedef struct {
    CGFloat value;
    KeepPriority priority;
} KeepValue;

/// Value, that represents no value. KeepValueIsNone will return YES.
extern const KeepValue KeepNone;
/// Returns YES for any value that has real value of CGFLOAT_MIN or priority 0.
extern BOOL KeepValueIsNone(KeepValue);

/// Constructor with arbitrary priority
extern KeepValue KeepValueMake(CGFloat, KeepPriority);
/// Constructors for 4 basic priorities
extern KeepValue KeepRequired(CGFloat);
extern KeepValue KeepHigh(CGFloat);
extern KeepValue KeepLow(CGFloat);
extern KeepValue KeepFitting(CGFloat);

extern KeepValue KeepValueSetDefaultPriority(KeepValue, KeepPriority);
extern KeepPriority KeepValueGetPriority(KeepValue);

/// Debug description (example “42@750”, or just “42” if priority is Required)
extern NSString *KeepValueDescription(KeepValue);


