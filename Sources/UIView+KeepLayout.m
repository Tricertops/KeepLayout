//
//  UIView+KeepLayout.m
//  Geografia
//
//  Created by Martin Kiss on 21.10.12.
//  Copyright (c) 2012 iMartin Kiss. All rights reserved.
//

#import "UIView+KeepLayout.h"
#import "KeepAttribute.h"



@implementation UIView (KeepLayout)



- (void)keep:(KeepAttribute *)attribute {
    [attribute applyInView:self];
}

- (UIView *)commonAncestor:(UIView *)anotherView {
    UIView *ancestor = self;
    while (ancestor) {
        if ([anotherView isDescendantOfView:ancestor]) {
            break; // This view is common ancestor to both views.
        }
        ancestor = ancestor.superview;
    }
    return ancestor;
}



@end
