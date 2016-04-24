//
//  KeepLayoutConstraint.m
//  Keep Layout
//
//  Created by Martin Kiss on 18.7.13.
//  Copyright (c) 2013 Martin Kiss. All rights reserved.
//

#import "KeepLayoutConstraint.h"
#import "KeepView.h"





@implementation KeepLayoutConstraint


- (instancetype)name:(NSString *)format, ... {
#ifdef DEBUG
    va_list arguments;
    va_start(arguments, format);
    
    self.name = [[NSString alloc] initWithFormat:format arguments:arguments];
    
    va_end(arguments);
#endif
    return self;
}

- (NSString *)description {
    if (self.name) {
        return [NSString stringWithFormat: @"<%@:%p %@>", self.class, self, self.name];
    }
    else {
        return [super description];
    }
}


@end





@implementation NSLayoutConstraint (Activation)



- (BOOL)isKeepActive {
    if ([self respondsToSelector:@selector(isActive)]) {
        return self.active;
    }
    else {
        KPView *firstView = self.firstItem;
        KPView *secondView = self.secondItem;
        KPView *common = [firstView commonSuperview:secondView];
        return [common.constraints containsObject:self];
    }
}


- (void)keepActive:(BOOL)keepActive {
    [KeepLayoutConstraint keepConstraints:@[self] active:keepActive];
}


+ (void)keepConstraints:(NSArray<NSLayoutConstraint *> *)constraints active:(BOOL)active {
    if ([self respondsToSelector:@selector(activateConstraints:)]) {
        if (active) {
            [self activateConstraints:constraints];
        }
        else {
            [self deactivateConstraints:constraints];
        }
    }
    else {
        for (NSLayoutConstraint *constraint in constraints) {
            KPView *firstView = constraint.firstItem;
            KPView *secondView = constraint.secondItem;
            KPView *common = [firstView commonSuperview:secondView];
            if (active) {
                [common addConstraint:constraint];
            }
            else {
                [common removeConstraint:constraint];
            }
        }
    }
}



@end


