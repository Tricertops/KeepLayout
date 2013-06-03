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
- (id)initWithType:(KeepAttributeType)type relatedView:(UIView *)view rules:(NSArray *)rules;
@property (nonatomic, readonly, assign) KeepAttributeType type;
@property (nonatomic, readonly, weak) UIView * relatedView;
@property (nonatomic, readonly, copy) NSArray *rules;

/// Short Syntax contructor
+ (instancetype)rules:(NSArray *)rules;
+ (instancetype)to:(UIView *)view rules:(NSArray *)rules;

/// Generates constraints, finds appropriate common views and adds them to the layout.
- (void)applyInView:(UIView *)view;

/// Returns mapping from KeepRule to propriate NSLayoutConstraint, so you can keep reference to them and add them yourself.
/// You will need to find common superview of both (in case of two) views. You can do this by using -[UIView commonAncestor:] in UIView+KeepLayout.
- (NSDictionary *)generateConstraintsForView:(UIView *)mainView;

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
@interface KeepTopOffset    : KeepAttribute @end
@interface KeepBottomOffset : KeepAttribute @end
@interface KeepLeftOffset   : KeepAttribute @end
@interface KeepRightOffset  : KeepAttribute @end
@interface KeepAlignTop     : KeepAttribute @end
@interface KeepAlignCenterX : KeepAttribute @end
@interface KeepAlignBottom  : KeepAttribute @end
@interface KeepAlignLeft    : KeepAttribute @end
@interface KeepAlignCenterY : KeepAttribute @end
@interface KeepAlignRight   : KeepAttribute @end
@interface KeepAlignBaseline: KeepAttribute @end
