/*******************************************************************************
 * EditableDataRow.m
 *
 * Title:			Giftory
 * Description:		Gift Repository for iPad
 *						This header file contains the implementation for the
 *						application's editable table row for data entities
 * Author:			Eric Crichlow
 * Version:			1.0
 * Copyright:		(c) 2011 Infusions of Grandeur. All rights reserved.
 ********************************************************************************
 *	08/12/11		*	EGC	*	File creation date
 *******************************************************************************/

#import "EditableTableDataRow.h"

@implementation EditableTableDataRow

@synthesize delegate;
@dynamic editColumn;
@dynamic rowItems;
@synthesize itemPadding;
@synthesize scaleToFillRow;

#pragma mark - Business Logic

- (void)adjustItemSizes
{

	CGRect			frame = self.contentView.frame;
	int				totalItemWidth = 0;

	if (sizesAdjusted)
		{
		return;
		}
	else
		{
		sizesAdjusted = YES;
		}

	// First deal with adjusting the width
	for (EditableTableDataRowItem *nextItem in rowItems)
		{
		CGSize size = nextItem.originalBaseSize;
		totalItemWidth += size.width;
		}
	totalItemWidth += self.itemPadding * ([self.rowItems count] + 1);

	if (totalItemWidth > frame.size.width || self.scaleToFillRow == TRUE)
		{
		for (EditableTableDataRowItem *nextItem in rowItems)
			{
			if (nextItem.resizeable == TRUE)
				{
				CGSize size = nextItem.originalBaseSize;
				nextItem.baseSize = CGSizeMake((int)((size.width / totalItemWidth) * frame.size.width), size.height);		// Maintains proportional size of all resizeable items
				}
			}
		}

	// Then deal with adjusting the height
	for (EditableTableDataRowItem *nextItem in rowItems)
		{
		if (nextItem.baseSize.height == 0)
			{
			CGSize size = nextItem.originalBaseSize;
			switch (nextItem.itemControlType)
				{
				case ControlTypeTextField:
					size.height = TEXTFIELD_DEFAULT_HEIGHT;
					break;
				case ControlTypePopup:
				case ControlTypeButton:
				case ControlTypeToggleButton:
				default:
					size.height = BUTTON_DEFAULT_HEIGHT;
					break;
				}
			nextItem.baseSize = size;
			}
		}
}

- (void)updateSizes
{
	sizesAdjusted = NO;
}

- (NSNumber *)editColumn
{
	return (editColumn);
}

- (void)setEditColumn:(NSNumber *)EditColumn
{

	[EditColumn retain];
	[editColumn release];
	editColumn = EditColumn;
	if (EditColumn)
		{
		EditableTableDataRowItem *rowItem = [rowItems objectAtIndex:[EditColumn intValue]];
		if (rowItem.itemControlType == ControlTypeTextField)
			{
			UITextField *textField = (UITextField *)rowItem.control;
			[textField becomeFirstResponder];
			}
		else if (rowItem.itemControlType == ControlTypePopup || rowItem.itemControlType == ControlTypeCombo)
			{
			UIButton *button = (UIButton *)rowItem.control;
			[button sendActionsForControlEvents:UIControlEventTouchUpInside];
			}
		}
}

- (NSArray *)rowItems
{
	return (rowItems);
}

- (void)setRowItems:(NSArray *)RowItems
{

	for (UIView *subview in self.contentView.subviews)
		{
		[subview removeFromSuperview];
		}
	[RowItems retain];
	[rowItems release];
	rowItems = RowItems;
	for (EditableTableDataRowItem *rowItem in RowItems)
		{
		rowItem.delegate = self;
		[self.contentView addSubview:rowItem.control];
		}
}

#pragma mark - View lifecycle

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier itemPadding:(int)padding scaleToFill:(BOOL)scale;
{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
		{
		itemPadding = padding;
		scaleToFillRow = scale;
		sizesAdjusted = NO;
		}
    return self;
}

- (void)dealloc
{

	[editColumn release];
	[rowItems release];
    [super dealloc];
}

- (void)layoutSubviews
{

	int				start_x = self.itemPadding;

	[super layoutSubviews];
	[self adjustItemSizes];
	for (EditableTableDataRowItem *nextItem in rowItems)
		{
		CGRect frame = nextItem.control.frame;
		frame.origin.x = start_x;
		frame.size.width = nextItem.baseSize.width;
		start_x += (frame.size.width + self.itemPadding);
		frame.size.height = nextItem.baseSize.height;
		if (nextItem.baseSize.height < self.frame.size.height)
			{
			frame.origin.y = (self.frame.size.height - nextItem.baseSize.height) / 2;
			}
		else
			{
			frame.origin.y = 0;
			frame.size.height = self.frame.size.height;
			}
		nextItem.control.frame = frame;
		}
}

- (void) prepareForReuse
{

	[super prepareForReuse];
	[self setEditColumn:nil];
	[self setRowItems:nil];
	delegate = nil;
	sizesAdjusted = NO;
}

#pragma mark - EditableTableDataRowItem Delegate methods

- (void)rowItem:(EditableTableDataRowItem *)rowItem controlDidSelectItem:(id)selection
{
	[delegate dataRow:self didSetValue:selection forColumn:[self.rowItems indexOfObject:rowItem]];
}

- (void)rowItem:(EditableTableDataRowItem *)rowItem controlDidSetValue:(NSString *)newValue
{
	[delegate dataRow:self didSetValue:newValue forColumn:[self.rowItems indexOfObject:rowItem]];
}

- (void)rowItem:(EditableTableDataRowItem *)rowItem controlDidToggleToValue:(BOOL)newToggleValue
{
	[delegate dataRow:self didSetValue:[NSNumber numberWithBool:newToggleValue] forColumn:[self.rowItems indexOfObject:rowItem]];
}

@end
