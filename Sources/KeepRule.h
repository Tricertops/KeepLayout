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

#import "KeepTypes.h"



@interface KeepRule : NSObject

- (id)initWithType:(KeepRuleType)type value:(CGFloat)value relatedView:(UIView *)view priority:(KeepPriority)priority;
@property (nonatomic, readonly, assign) KeepRuleType type;
@property (nonatomic, readonly, assign) CGFloat value;
@property (nonatomic, readonly, weak) UIView *relatedView;
@property (nonatomic, readonly, assign) KeepPriority priority;

/// Short Syntax constructors
+ (instancetype)must :(CGFloat)value; /// Priority Required
+ (instancetype)shall:(CGFloat)value; /// Priority High
+ (instancetype)may  :(CGFloat)value; /// Priority Low
+ (instancetype)fit  :(CGFloat)value; /// Priority Fitting Size
// Related to another view. E.g. to synchronize widths.
+ (instancetype)must :(CGFloat)value to:(UIView *)view;
+ (instancetype)shall:(CGFloat)value to:(UIView *)view;
+ (instancetype)may:(CGFloat)value   to:(UIView *)view;
+ (instancetype)fit:(CGFloat)value   to:(UIView *)view;

@end



/// Short Syntax subclasses
@interface KeepEqual : KeepRule @end /// Type Equal
@interface KeepMax   : KeepRule @end /// Type Max (value lower or equal)
@interface KeepMin   : KeepRule @end /// Type Min (value greater or equal)
