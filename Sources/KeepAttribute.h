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



@interface KeepAttribute : NSObject

@property (nonatomic, readwrite, assign) KeepValue equal;
@property (nonatomic, readwrite, assign) KeepValue max;
@property (nonatomic, readwrite, assign) KeepValue min;

- (void)remove;

@end



/// Used for attributes where the related view is none or is the main view itself - Width, Height
@interface KeepSelfAttribute : KeepAttribute
- (instancetype)initWithView:(UIView *)view
             layoutAttribute:(NSLayoutAttribute)layoutAttribute;
@property (nonatomic, readonly, weak) UIView *view;
@property (nonatomic, readonly, assign) NSLayoutAttribute layoutAttribute;
@end


/// Used for attributes where the related view is superview of the main view - Insets, 
@interface KeepSuperviewAttribute : KeepAttribute
- (instancetype)initWithView:(UIView *)view
             layoutAttribute:(NSLayoutAttribute)layoutAttribute
    superviewLayoutAttribute:(NSLayoutAttribute)superviewLayoutAttribute;
- (instancetype)initWithView:(UIView *)view
             layoutAttribute:(NSLayoutAttribute)layoutAttribute
    superviewLayoutAttribute:(NSLayoutAttribute)superviewLayoutAttribute
              invertRelation:(BOOL)invertRelation;
@property (nonatomic, readonly, weak) UIView *view;
@property (nonatomic, readonly, assign) NSLayoutAttribute layoutAttribute;
@property (nonatomic, readonly, assign) NSLayoutAttribute superviewLayoutAttribute;
@property (nonatomic, readonly, assign) BOOL invertRelation;
@end

