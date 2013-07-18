//
//  KeepTypes.h
//  Keep Layout
//
//  Created by Martin Kiss on 28.1.13.
//  Copyright (c) 2013 Triceratops. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>



#define KeepAssert(CONDITION, DESCRIPTION...)   NSAssert((CONDITION), @"Keep Layout: " DESCRIPTION)
#define KeepParameterAssert(CONDITION)          NSAssert((CONDITION), @"Keep Layout: " @"Invalid parameter not satisfying: %s", #CONDITION)





#pragma mark Priority
/// Use custom names.
typedef enum : NSInteger {
    KeepPriorityRequired = UILayoutPriorityRequired,
    KeepPriorityHigh = UILayoutPriorityDefaultHigh,
    KeepPriorityLow = UILayoutPriorityDefaultLow,
    KeepPriorityFitting = UILayoutPriorityFittingSizeLevel,
} KeepPriority;

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

/// Debug description (example “42@750”, or just “42” if priority is Required)
extern NSString *KeepValueDescription(KeepValue);


