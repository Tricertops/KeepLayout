//
//  KeepAttribute.h
//  Keep Layout
//
//  Created by Martin Kiss on 28.1.13.
//  Copyright (c) 2013 Triceratops. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

#import "KeepTypes.h"

@class KeepGroupAttribute;



@interface KeepAttribute : NSObject

@property (nonatomic, readwrite, assign) KeepValue equal;
@property (nonatomic, readwrite, assign) KeepValue max;
@property (nonatomic, readwrite, assign) KeepValue min;

- (void)remove;

- (instancetype)initWithView:(UIView *)view
             layoutAttribute:(NSLayoutAttribute)layoutAttribute
                 relatedView:(UIView *)relatedView
      relatedLayoutAttribute:(NSLayoutAttribute)relatedLayoutAttribute
                 coefficient:(CGFloat)coefficient;
@property (nonatomic, readonly, assign) CGFloat coefficient;

@property (nonatomic, readwrite, copy) NSString *name;
- (instancetype)name:(NSString *)format, ... NS_FORMAT_FUNCTION(1, 2);

+ (KeepGroupAttribute *)group:(KeepAttribute *)first, ... NS_REQUIRES_NIL_TERMINATION;

@end



/// Used for attributes where the related view is none or is the main view itself - Width, Height
@interface KeepConstantAttribute : KeepAttribute
@end



/// Attribute that applies its equal, max and min as multipliers for underlaying constraints.
@interface KeepMultiplierAttribute : KeepAttribute
@end



/// Used to group many attributes to single one. Setting equal, max and min properties will forward them to all.
@interface KeepGroupAttribute : KeepAttribute
- (instancetype)initWithAttributes:(id<NSFastEnumeration>)attributes;
@property (nonatomic, readonly, strong) id<NSFastEnumeration> attributes;
@end


