/*******************************************************************************
 * MockDataManager.h
 *
 * Title:			Dynamic Table Demo
 * Description:		Demo App for Dynamic, Editable Table Cell Classes
 *						This header file contains the template for the
 *						application's data storage and retrieval system
 * Author:			Eric Crichlow
 * Version:			1.0
 * Copyright:		(c) 2011 Infusions of Grandeur. All rights reserved.
 ********************************************************************************
 *	08/27/11		*	EGC	*	File creation date
 *******************************************************************************/

#import <Foundation/Foundation.h>

@interface MockDataManager : NSObject
{

	NSMutableArray				*autoCollection;		// Array of dictionaries comprising the auto collection

	NSArray						*makerList;
	NSDictionary				*modelList;
	NSArray						*colorList;
}
@property (nonatomic, retain) NSMutableArray *autoCollection;
@property (nonatomic, retain, readonly) NSArray *makerList;
@property (nonatomic, retain, readonly) NSDictionary *modelList;
@property (nonatomic, retain, readonly) NSArray *colorList;
@end
