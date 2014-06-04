//
//  KPLExampleWindowController.m
//  Keep Layout
//
//  Created by ASPCartman on 04/06/14.
//  Copyright (c) 2014 Martin Kiss. All rights reserved.
//

#import "KPLExampleWindowController.h"
#import "KeepLayout.h"

@implementation KPLExampleWindowController
- (id) init
{
	if (self = [super init])
	{
		self.window = [[NSWindow alloc] initWithContentRect:CGRectMake(0, 0, 600, 300) styleMask:NSTitledWindowMask|NSClosableWindowMask|NSResizableWindowMask backing:NSBackingStoreBuffered defer:FALSE];
		
		NSTextField *someView = [NSTextField new];
		someView.stringValue = @"OMG";
		[self.window.contentView addSubview:someView];
		someView.keepWidth.min = KeepRequired(50);
		someView.keepHeight.min = KeepRequired(20);
		[someView keepCentered];
	}
	return self;
}
@end
