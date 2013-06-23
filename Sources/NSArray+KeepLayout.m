//
//  NSArray+KeepLayout.m
//  Keep Layout
//
//  Created by Martin Kiss on 23.6.13.
//  Copyright (c) 2013 Triceratops. All rights reserved.
//

#import "NSArray+KeepLayout.h"
#import "KeepAttribute.h"
#import "UIView+KeepLayout.h"





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


- (KeepGroupAttribute *)keep_groupAttributeForSelector:(SEL)selector {
    KeepAssert([self keep_onlyContainsUIViews], @"%@ can only be called on array of UIView objects", NSStringFromSelector(selector));
    
    return [[KeepGroupAttribute alloc] initWithAttributes:[self valueForKeyPath:NSStringFromSelector(selector)]];
}


- (KeepGroupAttribute *)keep_groupAttributeForSelector:(SEL)selector relatedView:(UIView *)relatedView {
    KeepAssert([self keep_onlyContainsUIViews], @"%@ can only be called on array of UIView objects", NSStringFromSelector(selector));
    
    NSMutableArray *builder = [[NSMutableArray alloc] initWithCapacity:self.count];
    for (UIView *view in self) {
        KeepAttribute *(^block)(UIView *) = [view valueForKeyPath:NSStringFromSelector(selector)];
        [builder addObject:block(relatedView)];
    }
    return [[KeepGroupAttribute alloc] initWithAttributes:builder];
}


- (void)keep_invoke:(SEL)selector each:(void(^)(UIView *view))block {
    KeepAssert([self keep_onlyContainsUIViews], @"%@ can only be called on array of UIView objects", NSStringFromSelector(selector));
    
    for (UIView *view in self) {
        block(view);
    }
}


- (void)keep_invoke:(SEL)selector eachTwo:(void(^)(UIView *this, UIView *next))block {
    KeepAssert([self keep_onlyContainsUIViews], @"%@ can only be called on array of UIView objects", NSStringFromSelector(selector));
    
    if (self.count < 2) return;
    
    for (NSUInteger index = 0; index < self.count - 1; index++) {
        UIView *this = [self objectAtIndex:index];
        UIView *next = [self objectAtIndex:index + 1];
        block(this, next);
    }
}





#pragma mark Dimensions


- (KeepAttribute *)keepWidth {
    return [self keep_groupAttributeForSelector:_cmd];
}


- (KeepAttribute *)keepHeight {
    return [self keep_groupAttributeForSelector:_cmd];
}


- (KeepAttribute *)keepSize {
    return [self keep_groupAttributeForSelector:_cmd];
}


- (void)keepSize:(CGSize)size {
    [self keep_invoke:_cmd each:^(UIView *view) {
        [view keepSize:size];
    }];
}


- (void)keepSize:(CGSize)size priority:(KeepPriority)priority {
    [self keep_invoke:_cmd each:^(UIView *view) {
        [view keepSize:size priority:priority];
    }];
}


- (KeepAttribute *)keepAspectRatio {
    return [self keep_groupAttributeForSelector:_cmd];
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


- (KeepAttribute *(^)(UIView *))keepSizeTo {
    return ^KeepAttribute *(UIView *view) {
        return [self keep_groupAttributeForSelector:_cmd relatedView:view];
    };
}


- (void)keepWidthsEqual {
    [self keep_invoke:_cmd eachTwo:^(UIView *this, UIView *next) {
        this.keepWidthTo(next).equal = KeepRequired(1);
    }];
}


- (void)keepHeightsEqual {
    [self keep_invoke:_cmd eachTwo:^(UIView *this, UIView *next) {
        this.keepHeightTo(next).equal = KeepRequired(1);
    }];
}


- (void)keepSizesEqual {
    [self keep_invoke:_cmd eachTwo:^(UIView *this, UIView *next) {
        this.keepSizeTo(next).equal = KeepRequired(1);
    }];
}





#pragma mark Superview Insets


- (KeepAttribute *)keepLeftInset {
    return [self keep_groupAttributeForSelector:_cmd];
}


- (KeepAttribute *)keepRightInset {
    return [self keep_groupAttributeForSelector:_cmd];
}


- (KeepAttribute *)keepTopInset {
    return [self keep_groupAttributeForSelector:_cmd];
}


- (KeepAttribute *)keepBottomInset {
    return [self keep_groupAttributeForSelector:_cmd];
}


- (KeepAttribute *)keepInsets {
    return [self keep_groupAttributeForSelector:_cmd];
}


- (KeepAttribute *)keepHorizontalInsets {
    return [self keep_groupAttributeForSelector:_cmd];
}


- (KeepAttribute *)keepVerticalInsets {
    return [self keep_groupAttributeForSelector:_cmd];
}


- (void)keepInsets:(UIEdgeInsets)insets {
    [self keep_invoke:_cmd each:^(UIView *view) {
        [view keepInsets:insets];
    }];
}


- (void)keepInsets:(UIEdgeInsets)insets priority:(KeepPriority)priority {
    [self keep_invoke:_cmd each:^(UIView *view) {
        [view keepInsets:insets priority:priority];
    }];
}





#pragma mark Center

- (KeepAttribute *)keepHorizontalCenter {
    return [self keep_groupAttributeForSelector:_cmd];
}


- (KeepAttribute *)keepVerticalCenter {
    return [self keep_groupAttributeForSelector:_cmd];
}


- (KeepAttribute *)keepCenter {
    return [self keep_groupAttributeForSelector:_cmd];
}


- (void)keepCentered {
    [self keep_invoke:_cmd each:^(UIView *view) {
        [view keepCentered];
    }];
}


- (void)keepCenteredWithPriority:(KeepPriority)priority {
    [self keep_invoke:_cmd each:^(UIView *view) {
        [view keepCenteredWithPriority:priority];
    }];
}


- (void)keepCenter:(CGPoint)center {
    [self keep_invoke:_cmd each:^(UIView *view) {
        [view keepCenter:center];
    }];
}


- (void)keepCenter:(CGPoint)center priority:(KeepPriority)priority {
    [self keep_invoke:_cmd each:^(UIView *view) {
        [view keepCenter:center priority:priority];
    }];
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


- (void)keepHorizontalOffsets:(KeepValue)value {
    [self keep_invoke:_cmd eachTwo:^(UIView *this, UIView *next) {
        this.keepRightOffsetTo(next).equal = value;
    }];
}


- (void)keepVerticalOffsets:(KeepValue)value {
    [self keep_invoke:_cmd eachTwo:^(UIView *this, UIView *next) {
        this.keepBottomOffsetTo(next).equal = value;
    }];
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


- (void)keep_alignedSelector:(SEL)selector invokeSelector:(SEL)invokeSelector {
    [self keep_invoke:selector eachTwo:^(UIView *this, UIView *next) {
        KeepAttribute *(^block)(UIView *) = [this valueForKey:NSStringFromSelector(invokeSelector)];
        KeepAttribute *attribute = block(next);
        attribute.equal = KeepRequired(0);
    }];
}


- (void)keepLeftAligned {
    [self keep_alignedSelector:_cmd invokeSelector:@selector(keepLeftAlignTo)];
}


- (void)keepRightAligned {
    [self keep_alignedSelector:_cmd invokeSelector:@selector(keepRightAlignTo)];
}


- (void)keepTopAligned {
    [self keep_alignedSelector:_cmd invokeSelector:@selector(keepTopAlignTo)];
}


- (void)keepBottomAligned {
    [self keep_alignedSelector:_cmd invokeSelector:@selector(keepBottomAlignTo)];
}


- (void)keepVerticallyAligned {
    [self keep_alignedSelector:_cmd invokeSelector:@selector(keepVerticalAlignTo)];
}


- (void)keepHorizontallyAligned {
    [self keep_alignedSelector:_cmd invokeSelector:@selector(keepHorizontalAlignTo)];
}


- (void)keepBaselineAligned {
    [self keep_alignedSelector:_cmd invokeSelector:@selector(keepBaselineAlignTo)];
}





@end
