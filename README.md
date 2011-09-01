# Dynamic Table Demo

## Background

Dynamic Table Demo is a sample app created as a showcase and tutorial for "Reusable Dynamic Table Cell Classes", a set of classes designed to increase the usefulness and flexibility of the built-in iPad UITableView.

On the iPhone, the display is so small that tables are only suited to displaying limited information. The only in-line editing that makes sense in that context is data where the table row has a label and a value.

The iPad, however, is much more suitable for having table rows that can more closely approximate the UI of desktop applications.

"Reusable Dynamic Table Cell Classes" bridges this gap.

The classes give developers the ability to set up relatively complex table rows, in code, with UI elements that mimic popup boxes, combo boxes and check boxes from Mac OS X Cocoa. They also include standard text fields and buttons from Cocoa Touch.

The developer has the ability to access the underlying UI objects to perform as much customization as the iOS SDK allows.

Sample images are provided and you are free to use them.

## History

Version 1.0 - Initial release

## Classes

EditableTableDataRow

This is the subclass of UITableViewCell that is instantiated in calls to cellForRowAtIndexPath.
It contains 5 properties of interest to the developer:
* delegate - the object responsible for processing the data returned by the EditableTableDataRowItems in the cell
* editColumn - when the cell is drawn, if a value for this property is set, focus will be given to that column, such as making a text field first responder
* rowItems - an array of EditableTableDataRowItem objects which will be used to populate the cell
* itemPadding - the number of points to place between each EditableTableDataRowItem in the cell
* scaleToFillRow - determines whether the sizes of the EditableTableDataRowItems will be scaled to take up as much of the space as possible

EditableTableDataRowItem

This class represents a control to be placed in the table view cell.
It contains 8 properties of interest to the developer:
* itemControlType - defines the type of control to create for the item, choices are: ControlTypeTextField, ControlTypePopup, ControlTypeCombo, ControlTypeTextField, ControlTypeButton, ControlTypeToggleButton
* controlSelections - an array of objects used to populate the popup and combo list types. Objects in the array can be either strings, dictionaries or NSManagedObjects
* listKey - if the array in controlSelections is a dictionary or NSManagedObject, this property contains the key to use is retrieving the string value to place in the popup/combo
* baseSize - if the resizeable property is set to "YES", the width of this value is not given in absolute units (pixels, points, etc...) Rather, the value for each EditableTableDataRowItem is relative to the total of all of the values for all of the items. In other words, if one item has a value twice as big as another item, then that item will display twice as wide as the other item. The actual size of each item is determined by the space available
* resizeable - flag that determines whether the control associated with this item can be scaled to fill as much space as possible
* control - the UIControl object used to represent the simulated control in the cell. For ControlTypeTextField this control is a UITextField. For  all other types the underlying control is a UIButton; This object can be retrieved through this property by the developer to perform any customizations allowed by the UIKit Framework
* normalImage - for the button-based types, this is the image set for the button in the normal state
* selectedImage - for the button-based types, this is the image set for the button in the selected state

## Usage

Add the following 4 files to your project:

* EditableTableDataRow.h
* EditableTableDataRow.m
* EditableTableDataRowItem.h
* EditableTableDataRowItem.m

In the  cellForRowAtIndexPath method of your tableview data source, initialize or dequeue the EditableTableDataRow object to use for the table row, initialize the EditableTableDataRowItem objects that will populate the row, perform any UIKIT customizations of the underlying UIKit objects used to represent the EditableTableDataRowItem objects, assign the delegate of the cell and assign an array of the items to the rowItems property of the cell:

	- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
	{
	
		static NSString *customCellIdentifier = @"customCell";
		EditableTableDataRow *cell = nil;
    
		cell = (EditableTableDataRow *)[tableView dequeueReusableCellWithIdentifier:customCellIdentifier];
		if (cell == nil)
			{
			cell = [[[EditableTableDataRow alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:customCellIdentifier itemPadding:DEFAULT_ROW_ITEM_PADDING scaleToFill:YES] autorelease];
			}
	
		EditableTableDataRowItem *yearRowItem = [[[EditableTableDataRowItem alloc] initWithRowItemControlType:ControlTypeTextField selections:nil selectionListKey:nil baseSize:CGSizeMake(YEAR_COLUMN_RELATIVE_WIDTH, DEFAULT_TEXTFIELD_HEIGHT) canResize:NO normalImage:nil selectedImage:nil controlLabel:[[dataManager.autoCollection objectAtIndex:indexPath.row] valueForKey:@"year"] buttonTarget:nil buttonAction:nil] autorelease];
		.
		.
		.
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
		.
		.
		.
		cell.rowItems = dataRowItems;
   		return cell;
	}

Implement the EditableTableDataRow delegate method.

	- (void)dataRow:(EditableTableDataRow *)dataRow didSetValue:(id)newValue forColumn:(int)column
	{
	
		NSMutableDictionary				*editedAuto = [dataManager.autoCollection objectAtIndex:dataRow.tag];
	
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
	}

## Known Issues

Because the popup and combo box control types are actually simulated by placing relevant appearing images over UIButtons, the text label displaying the value of those controls extends to the ends of the buttons, and can thus overwrite parts of the image that normally wouldn't be able to be written over with real popups and combo boxes.

The scaling algorithm doesn't currently take maximum advantage of the space available.

## Support

Questions, suggestions or contributions to the codebase can be submitted to support@infusionsofgrandeur.com

## License

Copyright 2011 Infusions of Grandeur

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

