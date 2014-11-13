//
//  KeepTypes.m
//  Keep Layout
//
//  Created by Martin Kiss on 19.6.13.
//  Copyright (c) 2013 Triceratops. All rights reserved.
//

#import "KeepTypes.h"



#if TARGET_OS_IPHONE


#else

const KPEdgeInsets KPEdgeInsetsZero = (KPEdgeInsets){.top = 0, .left = 0, .bottom = 0, .right = 0};
const KPOffset KPOffsetZero = (KPOffset){.horizontal = 0, .vertical = 0};

#endif



extern NSString *KeepPriorityDescription(KeepPriority priority) {
    NSString *name = @"";
    
    if (priority > KeepPriorityRequired || isnan(priority) || priority <= 0) {
        name = @"undefined";
    }
    else if (priority >= (KeepPriorityRequired + KeepPriorityHigh) / 2) {
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
        name = [name stringByAppendingFormat:@"(%+g)", priority];
    }
    
    return name;
}








KeepValue KeepValueSetDefaultPriority(KeepValue value, KeepPriority priority) {
    if (KeepValueIsNone(value)) return KeepNone;
    
    if (KeepValueGetPriority(value) == 0) {
        return KeepValueMake(value.value, priority);
    }
    else {
        return value;
    }
}


KeepPriority KeepValueGetPriority(KeepValue value) {
    return value.priority;
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


