//
//  KPLAppDelegate.m
//  Example-OSX
//
//  Created by ASPCartman on 04/06/14.
//  Copyright (c) 2014 Martin Kiss. All rights reserved.
//

#import "KPLAppDelegate.h"
#import "KPLExampleWindowController.h"

@implementation KPLAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	KPLExampleWindowController *wc = [KPLExampleWindowController new];
	[wc showWindow:self];
	[wc.window makeKeyAndOrderFront:self];
	self.window = wc.window;
}

@end
