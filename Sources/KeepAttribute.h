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



@class KeepRule;

@interface KeepAttribute : NSObject

- (id)initWithType:(KeepAttributeType)type rules:(NSArray *)rules;
@property (nonatomic, readonly, assign) KeepAttributeType type;
@property (nonatomic, readonly, copy) NSArray *rules;

/// Short Syntax contructor
+ (instancetype)rules:(NSArray *)rules;

- (void)applyInView:(UIView *)view;

@end



/// Short Syntax subclasses
@interface KeepWidth        : KeepAttribute @end
@interface KeepHeight       : KeepAttribute @end
@interface KeepAspectRatio  : KeepAttribute @end
@interface KeepTopInset     : KeepAttribute @end
@interface KeepBottomInset  : KeepAttribute @end
@interface KeepLeftInset    : KeepAttribute @end
@interface KeepRightInset   : KeepAttribute @end
@interface KeepHorizontally : KeepAttribute @end
@interface KeepVertically   : KeepAttribute @end
