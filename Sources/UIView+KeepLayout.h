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

@class KeepAttribute;



@interface UIView (KeepLayout)

- (void)keep:(KeepAttribute *)attribute;

- (UIView *)commonSuperview:(UIView *)anotherView;
- (void)addConstraintToCommonSuperview:(NSLayoutConstraint *)constraint;
- (void)addConstraintsToCommonSuperview:(id<NSFastEnumeration>)constraints;

- (UIView *)commonAncestor:(UIView *)anotherView __attribute__((deprecated("Use -commonSuperview: instead")));

@end
