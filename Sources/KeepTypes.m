//
//  KeepTypes.m
//  Keep Layout
//
//  Created by Martin Kiss on 19.6.13.
//  Copyright (c) 2013 Triceratops. All rights reserved.
//

#import "KeepTypes.h"



extern NSString *KeepPriorityDescription(KeepPriority priority) {
    NSString *name = @"";
    
    if (priority >= (KeepPriorityRequired + KeepPriorityHigh) / 2) {
        priority -= KeepPriorityRequired;
        name = @"required";
    }
    else if (priority >= (KeepPriorityHigh + KeepPriorityLow) / 2) {
        priority -= KeepPriorityHigh;
        name = @"high";
    }
    else if (priority >= (KeepPriorityLow + KeepPriorityFitting) / 2) {
        priority -= KeepPriorityLow;
        name = @"low";
    }
    else {
        priority -= KeepPriorityFitting;
        name = @"fitting";
    }
    
    if (priority) {
        name = [name stringByAppendingFormat:@"(%@%i)", (priority > 0? @"+" : @""), (uint32_t)priority];
    }
    
    return name;
}




const KeepValue KeepNone = {
    .value = CGFLOAT_MIN,
    .priority = 0,
};


BOOL KeepValueIsNone(KeepValue keepValue) {
    return (keepValue.value == CGFLOAT_MIN || keepValue.priority <= 0);
}





KeepValue KeepValueMake(CGFloat value, KeepPriority priority) {
    return (KeepValue) {
        .value = value,
        .priority = priority,
    };
}


KeepValue KeepRequired(CGFloat value) {
    return KeepValueMake(value, KeepPriorityRequired);
}


KeepValue KeepHigh(CGFloat value) {
    return KeepValueMake(value, KeepPriorityHigh);
}


KeepValue KeepLow(CGFloat value) {
    return KeepValueMake(value, KeepPriorityLow);
}


KeepValue KeepFitting(CGFloat value) {
    return KeepValueMake(value, KeepPriorityFitting);
}





NSString *KeepValueDescription(KeepValue value) {
    if (KeepValueIsNone(value)) return @"none";
    
    NSString *description = @(value.value).stringValue;
    if (value.priority != KeepPriorityRequired) {
        description = [description stringByAppendingFormat:@"@%@", @(value.priority).stringValue];
    }
    return description;
}
