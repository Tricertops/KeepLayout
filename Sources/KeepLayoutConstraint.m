//
//  KeepLayoutConstraint.m
//  Keep Layout
//
//  Created by Martin Kiss on 18.7.13.
//  Copyright (c) 2013 Martin Kiss. All rights reserved.
//

#import "KeepLayoutConstraint.h"

@implementation KeepLayoutConstraint


- (instancetype)name:(NSString *)format, ... {
    va_list arguments;
    va_start(arguments, format);
    
    self.name = [[NSString alloc] initWithFormat:format arguments:arguments];
    
    va_end(arguments);
    return self;
}


- (NSString *)description {
    return self.debugDescription;
}

- (NSString *)debugDescription {
    return [NSString stringWithFormat: @"<%@:%p %@>", self.class, self, self.name];
}


@end
