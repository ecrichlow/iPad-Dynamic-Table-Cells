/*******************************************************************************
 * main.m
 *
 * Title:			Dynamic Table Demo
 * Description:		Demo App for Dynamic, Editable Table Cell Classes
 *						This file is the app starting point
 * Author:			Eric Crichlow
 * Version:			1.0
 * Copyright:		(c) 2011 Infusions of Grandeur. All rights reserved.
 ********************************************************************************
 *	08/27/11		*	EGC	*	File creation date
 *******************************************************************************/

#import <UIKit/UIKit.h>

#import "AppDelegate.h"

int main(int argc, char *argv[])
{
    
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    int retVal = UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    [pool release];
    return retVal;
}
