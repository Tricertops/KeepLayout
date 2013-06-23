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



#define KeepAssert(CONDITION, DESCRIPTION...)   NSAssert(CONDITION, @"KeepLayout: " DESCRIPTION)





#pragma mark Priority

typedef enum : NSInteger {
    KeepPriorityRequired = UILayoutPriorityRequired,
    KeepPriorityHigh = UILayoutPriorityDefaultHigh,
    KeepPriorityLow = UILayoutPriorityDefaultLow,
    KeepPriorityFitting = UILayoutPriorityFittingSizeLevel,
} KeepPriority;



#pragma mark Value


typedef struct {
    CGFloat value;
    KeepPriority priority;
} KeepValue;

extern KeepValue KeepNone;
extern BOOL KeepValueIsNone(KeepValue);

extern KeepValue KeepValueMake(CGFloat, KeepPriority);
extern KeepValue KeepRequired(CGFloat);
extern KeepValue KeepHigh(CGFloat);
extern KeepValue KeepLow(CGFloat);
extern KeepValue KeepFitting(CGFloat);

extern NSString *KeepValueDescription(KeepValue);
