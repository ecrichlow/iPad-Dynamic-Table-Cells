/*******************************************************************************
 * EditableDataRow.h
 *
 * Title:			Giftory
 * Description:		Gift Repository for iPad
 *						This header file contains the template for the
 *						application's editable table row for data entities
 * Author:			Eric Crichlow
 * Version:			1.0
 * Copyright:		(c) 2011 Infusions of Grandeur. All rights reserved.
 ********************************************************************************
 *	08/12/11		*	EGC	*	File creation date
 *******************************************************************************/

#import <UIKit/UIKit.h>
#import "EditableTableDataRowItem.h"

#define TEXTFIELD_DEFAULT_HEIGHT		31
#define BUTTON_DEFAULT_HEIGHT			37

@protocol EditableTableDataRowDelegate;

@interface EditableTableDataRow : UITableViewCell <EditableTableDataRowItemDelegate>
{

	id<EditableTableDataRowDelegate> delegate;

	NSNumber					*editColumn;				// Index of column to set as being edited
	NSArray						*rowItems;					// List of EditableTableDataRowItems to place in the row
	int							itemPadding;				// Points to pad between row items
	BOOL						scaleToFillRow;				// Determines if item widths of resizeable items are expanded to fill row

	BOOL						sizesAdjusted;				// Adjusting sizes twice shifts the controls slightly because of the new bases widths

}
@property(assign) id<EditableTableDataRowDelegate> delegate;
@property (nonatomic, retain) NSNumber *editColumn;
@property (nonatomic, retain) NSArray *rowItems;
@property (nonatomic, assign, readonly) int itemPadding;
@property(nonatomic, assign, readonly) BOOL scaleToFillRow;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier itemPadding:(int)padding scaleToFill:(BOOL)scale;
- (void)updateSizes;
@end

@protocol EditableTableDataRowDelegate
- (void)dataRow:(EditableTableDataRow *)dataRow didSetValue:(id)newValue forColumn:(int)column;			// Used to inform delegate of data change
@end
