//
// Created by ASPCartman on 04/06/14.
// Copyright (c) 2014 Martin Kiss. All rights reserved.
//
#import <Foundation/Foundation.h>

#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#define KIT_VIEW_CLASS UIView
#define KIT_VIEW_ANIMATION_OPTIONS_CLASS UIViewAnimationOptions
#define KIT_VIEW_EDGE_INSETS UIEdgeInsets
#define KIT_VIEW_EDGE_INSETS_ZERO UIEdgeInsetsZero
#define KIT_VIEW_OFFSET UIOffset
#define KIT_VIEW_OFFSET_ZERO UIOffsetZero
#else
#import <AppKit/AppKit.h>
#define KIT_VIEW_CLASS NSView
#define KIT_VIEW_ANIMATION_OPTIONS_CLASS NSViewAnimationOptions
#define KIT_VIEW_EDGE_INSETS NSEdgeInsets
#define KIT_VIEW_EDGE_INSETS_ZERO NSEdgeInsetsMake(0,0,0,0)
typedef struct {
	CGFloat horizontal, vertical;
} KeepOffset_t;
#define KIT_VIEW_OFFSET KeepOffset_t
#define KIT_VIEW_OFFSET_ZERO (KeepOffset_t){0.f,0.f}
#endif
