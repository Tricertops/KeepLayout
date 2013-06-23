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
    return [[KeepGroupAttribute alloc] initWithAttributes:[self valueForKeyPath:NSStringFromSelector(selector)]];
}


- (KeepGroupAttribute *)keep_getGroupAttributeForSelector:(SEL)selector relatedView:(UIView *)relatedView {
    NSMutableArray *builder = [[NSMutableArray alloc] initWithCapacity:self.count];
    for (UIView *view in self) {
        KeepAttribute *(^block)(UIView *) = [view valueForKeyPath:NSStringFromSelector(selector)];
        [builder addObject:block(relatedView)];
    }
    return [[KeepGroupAttribute alloc] initWithAttributes:builder];
}





#pragma mark Dimensions


- (KeepAttribute *)keepWidth {
    NSAssert([self keep_onlyContainsUIViews], @"%@ can only be called on array of UIView objects", NSStringFromSelector(_cmd));
    return [self keep_getGroupAttributeForSelector:_cmd];
}


- (KeepAttribute *)keepHeight {
    NSAssert([self keep_onlyContainsUIViews], @"%@ can only be called on array of UIView objects", NSStringFromSelector(_cmd));
    return [self keep_getGroupAttributeForSelector:_cmd];
}





#pragma mark Superview Insets


- (KeepAttribute *)keepLeftInset {
    NSAssert([self keep_onlyContainsUIViews], @"%@ can only be called on array of UIView objects", NSStringFromSelector(_cmd));
    return [self keep_getGroupAttributeForSelector:_cmd];
}


- (KeepAttribute *)keepRightInset {
    NSAssert([self keep_onlyContainsUIViews], @"%@ can only be called on array of UIView objects", NSStringFromSelector(_cmd));
    return [self keep_getGroupAttributeForSelector:_cmd];
}


- (KeepAttribute *)keepTopInset {
    NSAssert([self keep_onlyContainsUIViews], @"%@ can only be called on array of UIView objects", NSStringFromSelector(_cmd));
    return [self keep_getGroupAttributeForSelector:_cmd];
}


- (KeepAttribute *)keepBottomInset {
    NSAssert([self keep_onlyContainsUIViews], @"%@ can only be called on array of UIView objects", NSStringFromSelector(_cmd));
    return [self keep_getGroupAttributeForSelector:_cmd];
}


- (KeepAttribute *)keepInsets {
    NSAssert([self keep_onlyContainsUIViews], @"%@ can only be called on array of UIView objects", NSStringFromSelector(_cmd));
    return [self keep_getGroupAttributeForSelector:_cmd];
}





#pragma mark Center

- (KeepAttribute *)keepHorizontalCenter {
    NSAssert([self keep_onlyContainsUIViews], @"%@ can only be called on array of UIView objects", NSStringFromSelector(_cmd));
    return [self keep_getGroupAttributeForSelector:_cmd];
}


- (KeepAttribute *)keepVerticalCenter {
    NSAssert([self keep_onlyContainsUIViews], @"%@ can only be called on array of UIView objects", NSStringFromSelector(_cmd));
    return [self keep_getGroupAttributeForSelector:_cmd];
}


- (KeepAttribute *)keepCenter {
    NSAssert([self keep_onlyContainsUIViews], @"%@ can only be called on array of UIView objects", NSStringFromSelector(_cmd));
    return [self keep_getGroupAttributeForSelector:_cmd];
}





#pragma mark Offsets


- (KeepAttribute *(^)(UIView *))keepLeftOffset {
    NSAssert([self keep_onlyContainsUIViews], @"%@ can only be called on array of UIView objects", NSStringFromSelector(_cmd));
    return ^KeepAttribute *(UIView *view) {
        return [self keep_getGroupAttributeForSelector:_cmd relatedView:view];
    };
}


- (KeepAttribute *(^)(UIView *))keepRightOffset {
    NSAssert([self keep_onlyContainsUIViews], @"%@ can only be called on array of UIView objects", NSStringFromSelector(_cmd));
    return ^KeepAttribute *(UIView *view) {
        return [self keep_getGroupAttributeForSelector:_cmd relatedView:view];
    };
}


- (KeepAttribute *(^)(UIView *))keepTopOffset {
    NSAssert([self keep_onlyContainsUIViews], @"%@ can only be called on array of UIView objects", NSStringFromSelector(_cmd));
    return ^KeepAttribute *(UIView *view) {
        return [self keep_getGroupAttributeForSelector:_cmd relatedView:view];
    };
}


- (KeepAttribute *(^)(UIView *))keepBottomOffset {
    NSAssert([self keep_onlyContainsUIViews], @"%@ can only be called on array of UIView objects", NSStringFromSelector(_cmd));
    return ^KeepAttribute *(UIView *view) {
        return [self keep_getGroupAttributeForSelector:_cmd relatedView:view];
    };
}





@end
