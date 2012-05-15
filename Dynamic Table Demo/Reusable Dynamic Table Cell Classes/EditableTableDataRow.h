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
 *	01/17/12		*	EGC	*	Made changes to delegate to support row selection
 *	05/01/12		*	EGC	*	Added tracking of associated table view
 *	05/06/12		*	EGC	*	Added option to not pad beginning or end of line
 *******************************************************************************/

#import <UIKit/UIKit.h>
#import "EditableTableDataRowItem.h"

#define TEXTFIELD_DEFAULT_HEIGHT		31
#define BUTTON_DEFAULT_HEIGHT			37
#define DEFAULT_MIN_START_PADDING		6					// Used if row is set to not use the regular itemPadding for before the first item
#define DEFAULT_MIN_END_PADDING			6					// Used if row is set to not use the regular itemPadding for after the last item

@protocol EditableTableDataRowDelegate;

@interface EditableTableDataRow : UITableViewCell <EditableTableDataRowItemDelegate>
{

	id<EditableTableDataRowDelegate> delegate;

	NSNumber					*editColumn;				// Index of column to set as being edited
	NSArray						*rowItems;					// List of EditableTableDataRowItems to place in the row
	int							itemPadding;				// Points to pad between row items
	BOOL						scaleToFillRow;				// Determines if item widths of resizeable items are expanded to fill row
	UITableView					*tableView;					// Tableview this row is associated with
	BOOL						padStartItem;				// Pad far left of the row
	BOOL						padEndItem;					// Pad far right of the row

}
@property(assign) id<EditableTableDataRowDelegate> delegate;
@property (nonatomic, retain) NSNumber *editColumn;
@property (nonatomic, retain) NSArray *rowItems;
@property (nonatomic, assign, readonly) int itemPadding;
@property(nonatomic, assign, readonly) BOOL scaleToFillRow;
@property(nonatomic, assign, readonly) BOOL padStartItem;
@property(nonatomic, assign, readonly) BOOL padEndItem;
@property(nonatomic, retain, readonly) UITableView *tableView;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier itemPadding:(int)padding scaleToFill:(BOOL)scale forTable:(UITableView *)table;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier itemPadding:(int)padding padStartItem:(BOOL)padStart padEndItem:(BOOL)padEnd scaleToFill:(BOOL)scale forTable:(UITableView *)table;
@end

@protocol EditableTableDataRowDelegate
- (void)dataRow:(EditableTableDataRow *)dataRow didSetValue:(id)newValue forColumn:(int)column inTable:(UITableView *)table;			// Used to inform delegate of data change
- (void)didSelectDataRow:(EditableTableDataRow *)dataRow inTable:(UITableView *)table;													// Used to infor delegate of selected row
@end
