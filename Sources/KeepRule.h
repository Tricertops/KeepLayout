//
//  KeepRule.h
//  Keep Layout
//
//  Created by Martin Kiss on 28.1.13.
//  Copyright (c) 2013 Triceratops. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>



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





@interface KeepRule : NSObject

- (id)initWithType:(KeepRuleType)type value:(CGFloat)value priority:(KeepPriority)priority;
@property (nonatomic, readonly, assign) KeepRuleType type;
@property (nonatomic, readonly, assign) CGFloat value;
@property (nonatomic, readonly, assign) KeepPriority priority;

/// Short Syntax constructors
+ (instancetype)must :(CGFloat)value; /// Priority Required
+ (instancetype)shall:(CGFloat)value; /// Priority High
+ (instancetype)may  :(CGFloat)value; /// Priority Low
+ (instancetype)fit  :(CGFloat)value; /// Priority Fitting Size

@end



/// Short Syntax subclasses
@interface KeepEqual : KeepRule @end /// Type Equal
@interface KeepMax   : KeepRule @end /// Type Max (value lower or equal)
@interface KeepMin   : KeepRule @end /// Type Min (value greater or equal)
