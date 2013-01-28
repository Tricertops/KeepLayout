//
//  KeepAttribute.h
//  Keep Layout
//
//  Created by Martin Kiss on 28.1.13.
//  Copyright (c) 2013 Triceratops. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>



typedef enum KeepAttributeType : NSInteger {
    KeepAttributeTypeWidth,
    KeepAttributeTypeHeight,
    KeepAttributeTypeAspectRatio,
    KeepAttributeTypeLeftInset,
    KeepAttributeTypeRightInset,
    KeepAttributeTypeTopInset,
    KeepAttributeTypeBottomInset,
} KeepAttributeType;



@interface KeepAttribute : NSObject


#pragma mark Initialization

- (id)initWithType:(KeepAttributeType)type;

#pragma mark …

@property (nonatomic, readonly, assign) KeepAttributeType type;


#pragma mark Quick Construction

+ (instancetype)width;
+ (instancetype)height;
+ (instancetype)aspectRatio;
+ (instancetype)leftInset;
+ (instancetype)rightInset;
+ (instancetype)topInset;
+ (instancetype)bottomInset;


@end
