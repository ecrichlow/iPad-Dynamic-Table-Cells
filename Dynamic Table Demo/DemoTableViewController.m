/*******************************************************************************
 * DemoTableViewController.m
 *
 * Title:			Dynamic Table Demo
 * Description:		Demo App for Dynamic, Editable Table Cell Classes
 *						This header file contains the template for the
 *						application's main (only) view
 * Author:			Eric Crichlow
 * Version:			1.0
 * Copyright:		(c) 2011 Infusions of Grandeur. All rights reserved.
 ********************************************************************************
 *	08/27/11		*	EGC	*	File creation date
 *	05/01/12		*	EGC	*	Added tracking of associated table view
 *******************************************************************************/

#import "DemoTableViewController.h"
#import "AppDelegate.h"
#import "EditableTableDataRow.h"
#import "EditableTableDataRowItem.h"

@implementation DemoTableViewController

@synthesize autoTableView;
@synthesize tableHeader;

#pragma mark - View lifecycle

- (void)viewDidLoad
{

    [super viewDidLoad];
	dataManager = [[MockDataManager alloc] init];
	tableHeader.text = TABLE_HEADER_LABEL_PORTRAIT;
}

- (void)viewDidUnload
{
	[autoTableView release];
	[tableHeader release];
	[dataManager release];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{

	// Every EditableTableRow item is going to need to re-adjust its item sizes
	for (EditableTableDataRow *row in self.autoTableView.visibleCells)
		{
//		[row updateSizes];
		}
    return YES;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{

	if (fromInterfaceOrientation == UIInterfaceOrientationPortrait || fromInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
		{
		tableHeader.text = TABLE_HEADER_LABEL_LANDSCAPE;
		}
	else if (fromInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || fromInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
		{
		tableHeader.text = TABLE_HEADER_LABEL_PORTRAIT;
		}
	[self.autoTableView setNeedsLayout];
}

#pragma mark - Business Logic

- (IBAction)addAuto:(id)sender
{

	NSMutableArray				*autos = dataManager.autoCollection;
	NSMutableDictionary			*newAuto = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"", @"year", @"", @"make", @"", @"model", @"", @"color", @"", @"mileage", [NSNumber numberWithBool:YES], @"titled", nil];

	[autos addObject:newAuto];
	[autoTableView reloadData];
}

- (IBAction)attachImageToAuto:(id)sender
{
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Unimplemented Feature" message:@"Still need to implement picture import feature" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

#pragma mark - EditableTableDataRowItem Delegate methods

- (void)dataRow:(EditableTableDataRow *)dataRow didSetValue:(id)newValue forColumn:(int)column inTable:(UITableView *)table
{

	NSMutableDictionary				*editedAuto = [dataManager.autoCollection objectAtIndex:dataRow.tag];
	NSIndexPath						*selectedRow = [autoTableView indexPathForCell:dataRow];

	switch (column)
		{
		case TABLE_COLUMN_YEAR:
			[editedAuto setValue:newValue forKey:@"year"];
			break;
		case TABLE_COLUMN_MAKE:
			[editedAuto setValue:newValue forKey:@"make"];
			[editedAuto setValue:@"" forKey:@"model"];
			break;
		case TABLE_COLUMN_MODEL:
			[editedAuto setValue:newValue forKey:@"model"];
			break;
		case TABLE_COLUMN_COLOR:
			[editedAuto setValue:newValue forKey:@"color"];
			break;
		case TABLE_COLUMN_MILEAGE:
			[editedAuto setValue:newValue forKey:@"mileage"];
			break;
		case TABLE_COLUMN_TITLED:
			[editedAuto setValue:newValue forKey:@"titled"];
			break;
		default:
			break;
		}
	dataRow.editColumn = nil;
	[self.autoTableView reloadData];
	[autoTableView selectRowAtIndexPath:selectedRow animated:NO scrollPosition:UITableViewScrollPositionNone];
}

- (void)didSelectDataRow:(EditableTableDataRow *)dataRow inTable:(UITableView *)table
{
	
	[autoTableView deselectRowAtIndexPath:[autoTableView indexPathForSelectedRow] animated:NO];
	[autoTableView selectRowAtIndexPath:[autoTableView indexPathForCell:dataRow] animated:NO scrollPosition:UITableViewScrollPositionNone];
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{

	if ([[[dataManager.autoCollection objectAtIndex:indexPath.row] valueForKey:@"year"] isEqualToString:@""])
		{
		EditableTableDataRow *dataCell = (EditableTableDataRow *)cell;
		dataCell.editColumn = [NSNumber numberWithInt:TABLE_COLUMN_YEAR];
		}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return ([dataManager.autoCollection count]);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
    static NSString *customCellIdentifier = @"customCell";
	EditableTableDataRow *cell = nil;
    
	cell = (EditableTableDataRow *)[tableView dequeueReusableCellWithIdentifier:customCellIdentifier];
	if (cell == nil)
		{
		cell = [[[EditableTableDataRow alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:customCellIdentifier itemPadding:DEFAULT_ROW_ITEM_PADDING scaleToFill:YES forTable:tableView] autorelease];
		}

	EditableTableDataRowItem *yearRowItem = [[[EditableTableDataRowItem alloc] initWithRowItemControlType:ControlTypeTextField selections:nil selectionListKey:nil baseSize:CGSizeMake(YEAR_COLUMN_RELATIVE_WIDTH, DEFAULT_TEXTFIELD_HEIGHT) canResize:NO normalImage:nil selectedImage:nil controlLabel:[[dataManager.autoCollection objectAtIndex:indexPath.row] valueForKey:@"year"] buttonTarget:nil buttonAction:nil] autorelease];
	EditableTableDataRowItem *makeRowItem = [[[EditableTableDataRowItem alloc] initWithRowItemControlType:ControlTypeCombo selections:dataManager.makerList selectionListKey:nil baseSize:CGSizeMake(MAKE_COLUMN_RELATIVE_WIDTH, DEFAULT_COMBO_HEIGHT) canResize:YES normalImage:[UIImage imageNamed:@"comboBox.png"] selectedImage:[UIImage imageNamed:@"comboBoxSelected.png"] controlLabel:[[dataManager.autoCollection objectAtIndex:indexPath.row] valueForKey:@"make"] buttonTarget:nil buttonAction:nil] autorelease];
	EditableTableDataRowItem *modelRowItem = [[[EditableTableDataRowItem alloc] initWithRowItemControlType:ControlTypeCombo selections:[dataManager.modelList valueForKey:[[dataManager.autoCollection objectAtIndex:indexPath.row] valueForKey:@"make"]] selectionListKey:nil baseSize:CGSizeMake(MODEL_COLUMN_RELATIVE_WIDTH, DEFAULT_COMBO_HEIGHT) canResize:NO normalImage:[UIImage imageNamed:@"comboBox.png"] selectedImage:[UIImage imageNamed:@"comboBoxSelected.png"] controlLabel:[[dataManager.autoCollection objectAtIndex:indexPath.row] valueForKey:@"model"] buttonTarget:nil buttonAction:nil] autorelease];
	EditableTableDataRowItem *colorRowItem = [[[EditableTableDataRowItem alloc] initWithRowItemControlType:ControlTypePopup selections:dataManager.colorList selectionListKey:nil baseSize:CGSizeMake(COLOR_COLUMN_RELATIVE_WIDTH, DEFAULT_POPUP_HEIGHT) canResize:YES normalImage:[UIImage imageNamed:@"popupButton.png"] selectedImage:[UIImage imageNamed:@"popupButtonSelected.png"] controlLabel:[[dataManager.autoCollection objectAtIndex:indexPath.row] valueForKey:@"color"] buttonTarget:nil buttonAction:nil] autorelease];
	EditableTableDataRowItem *mileageRowItem = [[[EditableTableDataRowItem alloc] initWithRowItemControlType:ControlTypeTextField selections:nil selectionListKey:nil baseSize:CGSizeMake(MILEAGE_COLUMN_RELATIVE_WIDTH, DEFAULT_POPUP_HEIGHT) canResize:YES normalImage:nil selectedImage:nil controlLabel:[[dataManager.autoCollection objectAtIndex:indexPath.row] valueForKey:@"mileage"] buttonTarget:nil buttonAction:nil] autorelease];
	EditableTableDataRowItem *titledRowItem = [[[EditableTableDataRowItem alloc] initWithRowItemControlType:ControlTypeToggleButton selections:nil selectionListKey:nil baseSize:CGSizeMake(TITLED_COLUMN_RELATIVE_WIDTH, DEFAULT_TEXTFIELD_HEIGHT) canResize:NO normalImage:[UIImage imageNamed:@"checkBox.png"] selectedImage:[UIImage imageNamed:@"checkBoxChecked.png"] controlLabel:nil buttonTarget:nil buttonAction:nil] autorelease];
	EditableTableDataRowItem *imageRowItem = [[[EditableTableDataRowItem alloc] initWithRowItemControlType:ControlTypeButton selections:nil selectionListKey:nil baseSize:CGSizeMake(IMAGE_COLUMN_RELATIVE_WIDTH, 0) canResize:NO normalImage:[UIImage imageNamed:@"camera.png"] selectedImage:[UIImage imageNamed:@"cameraSelected.png"] controlLabel:nil buttonTarget:self buttonAction:@selector(attachImageToAuto:)] autorelease];
	NSArray *dataRowItems = [NSArray arrayWithObjects:yearRowItem, makeRowItem, modelRowItem, colorRowItem, mileageRowItem, titledRowItem, imageRowItem, nil];
	UITextField *yearField = (UITextField *)yearRowItem.control;
	UITextField *mileageField = (UITextField *)mileageRowItem.control;
	UIButton *titledField = (UIButton *)titledRowItem.control;
	cell.delegate = self;
	cell.tag = indexPath.row;

	if ([[[dataManager.autoCollection objectAtIndex:indexPath.row] valueForKey:@"year"] isEqualToString:@""])
		{
		yearField.placeholder = @"Year";
		}
	else
		{
		yearField.text = [[dataManager.autoCollection objectAtIndex:indexPath.row] valueForKey:@"year"];
		}
	if ([[[dataManager.autoCollection objectAtIndex:indexPath.row] valueForKey:@"mileage"] isEqualToString:@""])
		{
		mileageField.placeholder = @"Mileage";
		}
	else
		{
		mileageField.text = [[dataManager.autoCollection objectAtIndex:indexPath.row] valueForKey:@"mileage"];
		}
	if ([[[dataManager.autoCollection objectAtIndex:indexPath.row] valueForKey:@"titled"] boolValue] == YES)
		{
		[titledField setImage:[UIImage imageNamed:@"checkBoxChecked.png"] forState:UIControlStateNormal];
		}
	else
		{
		[titledField setImage:[UIImage imageNamed:@"checkBox.png"] forState:UIControlStateNormal];
		}
	cell.rowItems = dataRowItems;
    return cell;
}

@end
