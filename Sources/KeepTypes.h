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
    KeepAttributeTypeWidth,
    KeepAttributeTypeHeight,
    KeepAttributeTypeAspectRatio,
    KeepAttributeTypeTopInset,
    KeepAttributeTypeBottomInset,
    KeepAttributeTypeLeftInset,
    KeepAttributeTypeRightInset,
} KeepAttributeType;



/// Types of rules
typedef enum KeepRuleType : NSInteger {
    KeepRuleTypeEqual,
    KeepRuleTypeMax,
    KeepRuleTypeMin,
} KeepRuleType;



/// Priorities
enum {
    KeepPriorityMust = UILayoutPriorityRequired,
    KeepPriorityShall = UILayoutPriorityDefaultHigh,
    KeepPriorityMay = UILayoutPriorityDefaultLow,
    KeepPriorityFit = UILayoutPriorityFittingSizeLevel,
};
typedef UILayoutPriority KeepPriority;
