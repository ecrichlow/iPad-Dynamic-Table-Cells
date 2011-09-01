/*******************************************************************************
 * AppDelegate.m
 *
 * Title:			Dynamic Table Demo
 * Description:		Demo App for Dynamic, Editable Table Cell Classes
 *						This header file contains the implementation for the
 *						application's delegated methods
 * Author:			Eric Crichlow
 * Version:			1.0
 * Copyright:		(c) 2011 Infusions of Grandeur. All rights reserved.
 ********************************************************************************
 *	08/27/11		*	EGC	*	File creation date
 *******************************************************************************/

#import "AppDelegate.h"
#import "DemoTableViewController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize demoTableViewController;

- (void)dealloc
{
	[_window release];
	[demoTableViewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
	self.demoTableViewController = [[[DemoTableViewController alloc] initWithNibName:@"DemoTableViewController" bundle:nil] autorelease];
	self.window.rootViewController = self.demoTableViewController;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
