//
//  UIView+KeepLayout.h
//  Geografia
//
//  Created by Martin Kiss on 21.10.12.
//  Copyright (c) 2012 iMartin Kiss. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>


typedef enum kViewLayoutAttribute : NSInteger {
    kViewLayoutAttributeWidth,
    kViewLayoutAttributeHeight,
    kViewLayoutAttributeAspectRatio,
    kViewLayoutAttributeLeftInset,
    kViewLayoutAttributeRightInset,
    kViewLayoutAttributeTopInset,
    kViewLayoutAttributeBottomInset,
    kViewLayoutAttributeHorizontal,
    kViewLayoutAttributeVertical,
} kViewLayoutAttribute;



@interface UIView (KeepLayout)

#define METHOD_DECLARATION_FOR(__ATTR__) \
- (void)keep##__ATTR__:(CGFloat)constant; \
- (void)keep##__ATTR__##Minimum:(CGFloat)minimum; \
- (void)keep##__ATTR__##Maximum:(CGFloat)maximum; \
- (void)keep##__ATTR__##Minimum:(CGFloat)minimum maximum:(CGFloat)maximum; \


METHOD_DECLARATION_FOR(Width)
METHOD_DECLARATION_FOR(Height)
METHOD_DECLARATION_FOR(AspectRatio)

METHOD_DECLARATION_FOR(LeftInset)
METHOD_DECLARATION_FOR(RightInset)
METHOD_DECLARATION_FOR(TopInset)
METHOD_DECLARATION_FOR(BottomInset)

- (void)keepInsets:(UIEdgeInsets)insets;

- (void)keepHorizontally:(CGFloat)coeficient __deprecated;
- (void)keepVertically:(CGFloat)coeficient __deprecated;



- (void)keepAttribute:(kViewLayoutAttribute)attribute
               toView:(UIView *)view
              minimum:(CGFloat)minimum
              maximum:(CGFloat)maximum
           coeficient:(CGFloat)coeficient
             priority:(UILayoutPriority)priority;


- (UIView *)commonAncestor:(UIView *)anotherView;


@end
