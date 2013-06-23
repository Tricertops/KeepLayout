//
//  NSArray+KeepLayout.h
//  Keep Layout
//
//  Created by Martin Kiss on 23.6.13.
//  Copyright (c) 2013 Triceratops. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

@class KeepAttribute;





@interface NSArray (KeepLayout)




#pragma mark Dimensions

- (KeepAttribute *)keepWidth;
- (KeepAttribute *)keepHeight;

- (KeepAttribute *(^)(UIView *))keepWidthTo;
- (KeepAttribute *(^)(UIView *))keepHeightTo;


#pragma mark Superview Insets

- (KeepAttribute *)keepLeftInset;
- (KeepAttribute *)keepRightInset;
- (KeepAttribute *)keepTopInset;
- (KeepAttribute *)keepBottomInset;

- (KeepAttribute *)keepInsets;


#pragma mark Center

- (KeepAttribute *)keepHorizontalCenter;
- (KeepAttribute *)keepVerticalCenter;

- (KeepAttribute *)keepCenter;


#pragma mark Offsets

- (KeepAttribute *(^)(UIView *))keepLeftOffset;
- (KeepAttribute *(^)(UIView *))keepRightOffset;

- (KeepAttribute *(^)(UIView *))keepTopOffset;
- (KeepAttribute *(^)(UIView *))keepBottomOffset;


#pragma mark Alignments

- (KeepAttribute *(^)(UIView *))keepLeftAlignTo;
- (KeepAttribute *(^)(UIView *))keepRightAlignTo;
- (KeepAttribute *(^)(UIView *))keepTopAlignTo;
- (KeepAttribute *(^)(UIView *))keepBottomAlignTo;

- (KeepAttribute *(^)(UIView *))keepVerticalAlignTo;
- (KeepAttribute *(^)(UIView *))keepHorizontalAlignTo;

- (KeepAttribute *(^)(UIView *))keepBaselineAlignTo;





@end
