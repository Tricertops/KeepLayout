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
/// Usage: `view.keepLeftOffset(anotherView).equal = KeepRequired(10);`
- (KeepAttribute *(^)(UIView *))keepLeftOffset;
- (KeepAttribute *(^)(UIView *))keepRightOffset;
- (KeepAttribute *(^)(UIView *))keepTopOffset;
- (KeepAttribute *(^)(UIView *))keepBottomOffset;




@end
