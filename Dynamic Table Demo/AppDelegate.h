/*******************************************************************************
 * AppDelegate.h
 *
 * Title:			Dynamic Table Demo
 * Description:		Demo App for Dynamic, Editable Table Cell Classes
 *						This header file contains the template for the
 *						application's delegated methods
 * Author:			Eric Crichlow
 * Version:			1.0
 * Copyright:		(c) 2011 Infusions of Grandeur. All rights reserved.
 ********************************************************************************
 *	08/27/11		*	EGC	*	File creation date
 *******************************************************************************/

#import <UIKit/UIKit.h>
#import "DemoTableViewController.h"

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
}
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet DemoTableViewController *demoTableViewController;
@end
