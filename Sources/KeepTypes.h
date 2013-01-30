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



/// Types of attributes
typedef enum KeepAttributeType : NSInteger {
    /// Dimensions
    KeepAttributeTypeWidth,
    KeepAttributeTypeHeight,
    KeepAttributeTypeAspectRatio,
    /// Superview Insets
    KeepAttributeTypeTopInset,
    KeepAttributeTypeBottomInset,
    KeepAttributeTypeLeftInset,
    KeepAttributeTypeRightInset,
    /// Relaive Position
    KeepAttributeTypeHorizontally,
    KeepAttributeTypeVertically,
    /// Offset to Other View
    KeepAttributeTypeTopOffset,
    KeepAttributeTypeBottomOffset,
    KeepAttributeTypeLeftOffset,
    KeepAttributeTypeRightOffset,
} KeepAttributeType;



/// Types of rules
typedef enum KeepRuleType : NSInteger {
    KeepRuleTypeEqual,
    KeepRuleTypeMax,
    KeepRuleTypeMin,
} KeepRuleType;



/// Priorities
enum : NSInteger {
    KeepPriorityMust = UILayoutPriorityRequired,
    KeepPriorityShall = UILayoutPriorityDefaultHigh,
    KeepPriorityMay = UILayoutPriorityDefaultLow,
    KeepPriorityFit = UILayoutPriorityFittingSizeLevel,
};
typedef UILayoutPriority KeepPriority;

/// Priorities
enum : NSInteger {
    KeepVeryWeak = -30,
    KeepWeak = -20,
    KeepBitWeak = -10,
    KeepNormal = 0,
    KeepBitStrong = +10,
    KeepStrong = +20,
    KeepVeryStrong = +30,
};
