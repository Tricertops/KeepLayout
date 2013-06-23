//
//  NSArray+KeepLayout.m
//  Keep Layout
//
//  Created by Martin Kiss on 23.6.13.
//  Copyright (c) 2013 Triceratops. All rights reserved.
//

#import "NSArray+KeepLayout.h"
#import "KeepAttribute.h"



@implementation NSArray (KeepLayout)





#pragma mark General


- (BOOL)keep_onlyContainsUIViews {
    for (UIView *view in self) {
        if ( ! [view isKindOfClass:[UIView class]]) {
            return NO;
        }
    }
    return YES;
}


- (KeepGroupAttribute *)keep_getGroupAttributeForSelector:(SEL)selector {
    KeepAssert([self keep_onlyContainsUIViews], @"%@ can only be called on array of UIView objects", NSStringFromSelector(_cmd));
    
    return [[KeepGroupAttribute alloc] initWithAttributes:[self valueForKeyPath:NSStringFromSelector(selector)]];
}


- (KeepGroupAttribute *)keep_groupAttributeForSelector:(SEL)selector relatedView:(UIView *)relatedView {
    KeepAssert([self keep_onlyContainsUIViews], @"%@ can only be called on array of UIView objects", NSStringFromSelector(_cmd));
    
    NSMutableArray *builder = [[NSMutableArray alloc] initWithCapacity:self.count];
    for (UIView *view in self) {
        KeepAttribute *(^block)(UIView *) = [view valueForKeyPath:NSStringFromSelector(selector)];
        [builder addObject:block(relatedView)];
    }
    return [[KeepGroupAttribute alloc] initWithAttributes:builder];
}





#pragma mark Dimensions


- (KeepAttribute *)keepWidth {
    return [self keep_getGroupAttributeForSelector:_cmd];
}


- (KeepAttribute *)keepHeight {
    return [self keep_getGroupAttributeForSelector:_cmd];
}


- (KeepAttribute *(^)(UIView *))keepWidthTo {
    return ^KeepAttribute *(UIView *view) {
        return [self keep_groupAttributeForSelector:_cmd relatedView:view];
    };
}


- (KeepAttribute *(^)(UIView *))keepHeightTo {
    return ^KeepAttribute *(UIView *view) {
        return [self keep_groupAttributeForSelector:_cmd relatedView:view];
    };
}





#pragma mark Superview Insets


- (KeepAttribute *)keepLeftInset {
    return [self keep_getGroupAttributeForSelector:_cmd];
}


- (KeepAttribute *)keepRightInset {
    return [self keep_getGroupAttributeForSelector:_cmd];
}


- (KeepAttribute *)keepTopInset {
    return [self keep_getGroupAttributeForSelector:_cmd];
}


- (KeepAttribute *)keepBottomInset {
    return [self keep_getGroupAttributeForSelector:_cmd];
}


- (KeepAttribute *)keepInsets {
    return [self keep_getGroupAttributeForSelector:_cmd];
}





#pragma mark Center

- (KeepAttribute *)keepHorizontalCenter {
    return [self keep_getGroupAttributeForSelector:_cmd];
}


- (KeepAttribute *)keepVerticalCenter {
    return [self keep_getGroupAttributeForSelector:_cmd];
}


- (KeepAttribute *)keepCenter {
    return [self keep_getGroupAttributeForSelector:_cmd];
}





#pragma mark Offsets


- (KeepAttribute *(^)(UIView *))keepLeftOffset {
    return ^KeepAttribute *(UIView *view) {
        return [self keep_groupAttributeForSelector:_cmd relatedView:view];
    };
}


- (KeepAttribute *(^)(UIView *))keepRightOffset {
    return ^KeepAttribute *(UIView *view) {
        return [self keep_groupAttributeForSelector:_cmd relatedView:view];
    };
}


- (KeepAttribute *(^)(UIView *))keepTopOffset {
    return ^KeepAttribute *(UIView *view) {
        return [self keep_groupAttributeForSelector:_cmd relatedView:view];
    };
}


- (KeepAttribute *(^)(UIView *))keepBottomOffset {
    return ^KeepAttribute *(UIView *view) {
        return [self keep_groupAttributeForSelector:_cmd relatedView:view];
    };
}





#pragma mark Alignments


- (KeepAttribute *(^)(UIView *))keepLeftAlignTo {
    return ^KeepAttribute *(UIView *view) {
        return [self keep_groupAttributeForSelector:_cmd relatedView:view];
    };
}


- (KeepAttribute *(^)(UIView *))keepRightAlignTo {
    return ^KeepAttribute *(UIView *view) {
        return [self keep_groupAttributeForSelector:_cmd relatedView:view];
    };
}


- (KeepAttribute *(^)(UIView *))keepTopAlignTo {
    return ^KeepAttribute *(UIView *view) {
        return [self keep_groupAttributeForSelector:_cmd relatedView:view];
    };
}


- (KeepAttribute *(^)(UIView *))keepBottomAlignTo {
    return ^KeepAttribute *(UIView *view) {
        return [self keep_groupAttributeForSelector:_cmd relatedView:view];
    };
}


- (KeepAttribute *(^)(UIView *))keepVerticalAlignTo {
    return ^KeepAttribute *(UIView *view) {
        return [self keep_groupAttributeForSelector:_cmd relatedView:view];
    };
}


- (KeepAttribute *(^)(UIView *))keepHorizontalAlignTo {
    return ^KeepAttribute *(UIView *view) {
        return [self keep_groupAttributeForSelector:_cmd relatedView:view];
    };
}


- (KeepAttribute *(^)(UIView *))keepBaselineAlignTo {
    return ^KeepAttribute *(UIView *view) {
        return [self keep_groupAttributeForSelector:_cmd relatedView:view];
    };
}





@end
