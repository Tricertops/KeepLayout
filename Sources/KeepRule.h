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



typedef enum KeepRuleType : NSInteger {
    KeepRuleTypeEqual,
    KeepRuleTypeMaximum,
    KeepRuleTypeMinimum,
} KeepRuleType;

enum {
    KeepPriorityMust = UILayoutPriorityRequired,
    KeepPriorityShould = UILayoutPriorityDefaultHigh,
    KeepPriorityMay = UILayoutPriorityDefaultLow,
    KeepPriorityFit = UILayoutPriorityFittingSizeLevel,
};
typedef UILayoutPriority KeepPriority;



@interface KeepRule : NSObject

- (id)initWithType:(KeepRuleType)type value:(CGFloat)value priority:(KeepPriority)priority;

@end
