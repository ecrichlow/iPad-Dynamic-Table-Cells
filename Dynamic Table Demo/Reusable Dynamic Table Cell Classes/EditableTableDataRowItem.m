/*******************************************************************************
 * EditableTableDataRowItem.m
 *
 * Title:			Giftory
 * Description:		Gift Repository for iPad
 *						This header file contains the implementation for the
 *						application's editable table row item for data entities
 * Author:			Eric Crichlow
 * Version:			1.0
 * Copyright:		(c) 2011 Infusions of Grandeur. All rights reserved.
 ********************************************************************************
 *	08/15/11		*	EGC	*	File creation date
 *	01/17/12		*	EGC	*	Made changes to delegate to support row selection
 *	05/24/12		*	EGC	*	Made fix for crashing combo box
 *	05/02/18		*	EGC	*	Updated to use PopoverPresentationController
 *******************************************************************************/

#import "EditableTableDataRowItem.h"

@implementation EditableTableDataRowItem

@synthesize delegate;
@synthesize itemControlType;
@synthesize controlSelections;
@synthesize listKey;
@synthesize baseSize;
@synthesize resizeable;
@synthesize control;
@synthesize normalImage;
@synthesize selectedImage;
@synthesize originalBaseSize;

#pragma mark - Object lifecycle

// Full initializer allowing for one-step setup of the control
- (id)initWithRowItemControlType:(int)controlType selections:(NSArray *)selections selectionListKey:(NSString *)selectionListKey baseSize:(CGSize)size canResize:(BOOL)resize normalImage:(UIImage *)normalButtonImage selectedImage:(UIImage *)selectedButtonImage controlLabel:(NSString *)label buttonTarget:(id)target buttonAction:(SEL)action forViewController:(UIViewController *)controller
{

    self = [super init];
    if (self)
		{
		itemControlType = controlType;
		controlSelections = [selections retain];
		listKey = [selectionListKey retain];
		baseSize = size;
		originalBaseSize = size;
		resizeable = resize;
		normalImage = [normalButtonImage retain];
		selectedImage = [selectedButtonImage retain];
		optionPopoverController = nil;
		parentController = controller;
		if (controlType == ControlTypeTextField)
			{
			UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
			textField.delegate = self;
			textField.autocorrectionType = UITextAutocorrectionTypeNo;
			textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
			textField.font = [UIFont systemFontOfSize:DEFAULT_TEXTFIELD_FONT_SIZE];
			textField.borderStyle = UITextBorderStyleRoundedRect;
			textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
			[textField addTarget:self action:@selector(fieldTextDidUpdate:) forControlEvents:UIControlEventEditingDidEnd];
			[textField addTarget:self action:@selector(fieldTextDidStartEditing:) forControlEvents:UIControlEventEditingDidBegin];
			if (label && [label isKindOfClass:[NSString class]])
				{
				textField.text = label;
				}
			control = textField;
			}
		else if (controlType == ControlTypePopup || controlType == ControlTypeCombo)	// Popups and Combos are very similar
			{
			UIButton *popupField = nil;
			if (normalButtonImage)
				{
				popupField = [UIButton buttonWithType:UIButtonTypeCustom];
				[popupField setBackgroundImage:normalButtonImage forState:UIControlStateNormal];
				if (selectedButtonImage)
					{
					[popupField setBackgroundImage:selectedButtonImage forState:UIControlStateSelected];
					}
				if (label)
					{
					[popupField setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
					[popupField setTitle:label forState:UIControlStateNormal];
					}
				}
			else
				{
				popupField = [UIButton buttonWithType:UIButtonTypeRoundedRect];
				popupField.titleLabel.textColor = [UIColor blackColor];
				popupField.titleLabel.text = label;
				}
			if (controlType == ControlTypePopup)
				{
				popupField.titleLabel.font = [UIFont systemFontOfSize:DEFAULT_POPUP_FONT_SIZE];
				}
			else if (controlType == ControlTypeCombo)
				{
				popupField.titleLabel.font = [UIFont systemFontOfSize:DEFAULT_COMBO_FONT_SIZE];
				}
			[popupField addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
			control = [popupField retain];
			}
		else if (controlType == ControlTypeButton)
			{
			UIButton *buttonField = nil;
			// This control type can either have an associated image or a text label
			if (normalButtonImage)
				{
				buttonField = [UIButton buttonWithType:UIButtonTypeCustom];
				[buttonField setBackgroundImage:normalButtonImage forState:UIControlStateNormal];
				if (selectedButtonImage)
					{
					[buttonField setBackgroundImage:selectedButtonImage forState:UIControlStateSelected];
					}
				if (label)
					{
					[buttonField setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
					[buttonField setTitle:label forState:UIControlStateNormal];
					}
				}
			else
				{
				buttonField = [UIButton buttonWithType:UIButtonTypeRoundedRect];
				buttonField.titleLabel.textColor = [UIColor blackColor];
				buttonField.titleLabel.text = label;
				}
			buttonField.titleLabel.font = [UIFont systemFontOfSize:DEFAULT_BUTTON_FONT_SIZE];
			[buttonField addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
			[buttonField addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
			control = [buttonField retain];
			}
		else if (controlType == ControlTypeToggleButton)
			{
			UIButton *toggleButtonField = [UIButton buttonWithType:UIButtonTypeCustom];
			if (normalButtonImage)
				{
				[toggleButtonField setImage:normalButtonImage forState:UIControlStateNormal];
				}
			[toggleButtonField addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
			control = [toggleButtonField retain];
			}
		}
    
    return (self);
}

// Basic initializer which requires caller to retrieve the created inner control and set it up manually
- (id)initWithRowItemControlType:(int)controlType canResize:(BOOL)resize forViewController:(UIViewController *)controller
{
	return ([self initWithRowItemControlType:controlType selections:nil selectionListKey:nil baseSize:CGSizeMake(0, 0) canResize:resize normalImage:nil selectedImage:nil controlLabel:nil buttonTarget:nil buttonAction:nil forViewController:controller]);
}

- (void)dealloc
{

	// Deconstruct the textfield so that no notifications or delegate methods are called on a released object
	if (itemControlType == ControlTypeTextField)
		{
		UITextField *textField = (UITextField *)control;
		[textField removeTarget:self action:@selector(fieldTextDidUpdate:) forControlEvents:UIControlEventEditingDidEnd];
		textField.delegate = nil;
		}
	[controlSelections release];
	[listKey release];
	[control release];
	[normalImage release];
	[selectedImage release];
	[super dealloc];
}

#pragma mark - Business Logic

- (IBAction)buttonPressed:(id)sender
{

	[delegate rowItemWasSelected:self];
	if (self.itemControlType == ControlTypeToggleButton)
		{
		UIButton *toggleButton = (UIButton *)sender;
		if ([toggleButton imageForState:UIControlStateNormal] == selectedImage)
			{
			[toggleButton setImage:normalImage forState:UIControlStateNormal];
			[delegate rowItem:self controlDidToggleToValue:NO];
			}
		else if ([toggleButton imageForState:UIControlStateNormal] == normalImage)
			{
			[toggleButton setImage:selectedImage forState:UIControlStateNormal];
			[delegate rowItem:self controlDidToggleToValue:YES];
			}
		}
	else if (self.itemControlType == ControlTypePopup)
		{
		UITableViewController *popoverTable = [[[UITableViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
		popoverTable.tableView.dataSource = self;
		popoverTable.tableView.delegate = self;
		popoverTable.modalPresentationStyle = UIModalPresentationPopover;
		popoverTable.preferredContentSize = CGSizeMake(DEFAULT_POPOVER_WIDTH, [self.controlSelections count] * DEFAULT_TABLEVIEW_ROW_HEIGHT);
		[parentController presentViewController:popoverTable animated:NO completion:nil];
		UIPopoverPresentationController *popoverController = popoverTable.popoverPresentationController;
		popoverController.delegate = self;
		popoverController.sourceView = control.superview;
		popoverController.sourceRect = control.frame;
		popoverController.permittedArrowDirections = UIPopoverArrowDirectionAny;
		optionPopoverController = popoverController;
		}
	else if (self.itemControlType == ControlTypeCombo)
		{
		UITableViewController *popoverTable = [[[UITableViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
		UIToolbar *toolbar = [[[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, DEFAULT_POPOVER_WIDTH, DEFAULT_TOOLBAR_HEIGHT)] autorelease];
		UIView *containerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, DEFAULT_POPOVER_WIDTH, ([self.controlSelections count] * DEFAULT_TABLEVIEW_ROW_HEIGHT) + DEFAULT_TOOLBAR_HEIGHT)] autorelease];
		UIViewController *containerViewController = [[[UIViewController alloc] init] autorelease];
		UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(DEFAULT_COMBO_TEXTFIELD_MARGIN, (DEFAULT_TOOLBAR_HEIGHT - DEFAULT_COMBO_TEXTFIELD_HEIGHT) / 2, DEFAULT_POPOVER_WIDTH - (DEFAULT_COMBO_TEXTFIELD_MARGIN * 2), DEFAULT_COMBO_TEXTFIELD_HEIGHT)];
		textField.delegate = self;
		textField.autocorrectionType = UITextAutocorrectionTypeNo;
		textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
		textField.font = [UIFont systemFontOfSize:DEFAULT_COMBO_FONT_SIZE];
		textField.borderStyle = UITextBorderStyleRoundedRect;
		textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		[textField addTarget:self action:@selector(fieldTextDidUpdate:) forControlEvents:UIControlEventEditingDidEnd];
		popoverTable.tableView.dataSource = self;
		popoverTable.tableView.delegate = self;
		popoverTable.tableView.frame = CGRectMake(0, DEFAULT_TOOLBAR_HEIGHT, DEFAULT_POPOVER_WIDTH, [self.controlSelections count] * DEFAULT_TABLEVIEW_ROW_HEIGHT);
		[toolbar addSubview:textField];
		[containerView addSubview:toolbar];
		[containerView addSubview:popoverTable.tableView];
		containerViewController.view = containerView;
		containerViewController.modalPresentationStyle = UIModalPresentationPopover;
		containerViewController.preferredContentSize = CGSizeMake(DEFAULT_POPOVER_WIDTH, ([self.controlSelections count] * DEFAULT_TABLEVIEW_ROW_HEIGHT) + DEFAULT_TOOLBAR_HEIGHT);
		[parentController presentViewController:containerViewController animated:NO completion:nil];
		UIPopoverPresentationController *popoverController = containerViewController.popoverPresentationController;
		popoverController.delegate = self;
		popoverController.sourceView = control.superview;
		popoverController.sourceRect = control.frame;
		optionPopoverController = popoverController;
		// If there's currently an object that's first responder, make it resign that status
		for (UIView *subview in self.control.superview.subviews)
			{
			if ([subview isKindOfClass:[UITextField class]])
				{
				if ([subview isFirstResponder])
					{
					[subview resignFirstResponder];
					[[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
					}
				}
			}
		[textField becomeFirstResponder];
		}
	else if (self.itemControlType == ControlTypeButton)
		{
		// Don't need to do anything here. Caller passed in target and action. But in order to trigger delegate rowItemWasSelected this control type was added here.
		}

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return ([self.controlSelections count]);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	
    static NSString *CellIdentifier = @"plainCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	id controlOption = [self.controlSelections objectAtIndex:indexPath.row];
	NSString *option = nil;

    if (cell == nil)
		{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		}

	if ([controlOption isKindOfClass:[NSString class]])
		{
		option = (NSString *)controlOption;
		cell.textLabel.text = option;
		}
	else if ([controlOption isKindOfClass:[NSDictionary class]])
		{
		NSDictionary *optionDict = (NSDictionary *)controlOption;
		option = [optionDict valueForKey:self.listKey];
		cell.textLabel.text = option;
		}
	else if ([controlOption isKindOfClass:[NSManagedObject class]])
		{
		NSManagedObject *optionData = (NSManagedObject *)controlOption;
		option = [optionData valueForKey:self.listKey];
		cell.textLabel.text = option;
		}
	
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

	// Deconstruct the popover and its components so that no notifications or delegate methods are called on a released object
	if (optionPopoverController)
		{
		if (itemControlType == ControlTypeCombo)
			{
			for (UIView *nextView in optionPopoverController.presentedViewController.view.subviews)
				{
				if ([nextView isKindOfClass:[UIToolbar class]])
					{
					for (UIView *toolbarSubView in nextView.subviews)
						{
						if ([toolbarSubView isKindOfClass:[UITextField class]])
							{
							UITextField *textField = (UITextField *)toolbarSubView;
							[textField removeTarget:self action:@selector(fieldTextDidUpdate:) forControlEvents:UIControlEventEditingDidEnd];
							textField.delegate = nil;
							}
						}
					}
				else if ([nextView isKindOfClass:[UITableView class]])
					{
					UITableView *tableView = (UITableView *)nextView;
					tableView.dataSource = nil;
					tableView.delegate = nil;
					}
				}
			}
		[parentController dismissViewControllerAnimated:NO completion:nil];
		optionPopoverController.delegate = nil;
		optionPopoverController = nil;
		}
	[delegate rowItem:self controlDidSelectItem:[self.controlSelections objectAtIndex:indexPath.row]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return (DEFAULT_TABLEVIEW_ROW_HEIGHT);
}

#pragma mark - UIPopoverPresentationControllerDelegate delegate methods

- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController
{

	// Deconstruct the popover and its components so that no notifications or delegate methods are called on a released object
	if (optionPopoverController == popoverPresentationController)
		{
		if (itemControlType == ControlTypeCombo)
			{
			for (UIView *nextView in optionPopoverController.presentedViewController.view.subviews)
				{
				if ([nextView isKindOfClass:[UIToolbar class]])
					{
					for (UIView *toolbarSubView in nextView.subviews)
						{
						if ([toolbarSubView isKindOfClass:[UITextField class]])
							{
							UITextField *textField = (UITextField *)toolbarSubView;
							[textField removeTarget:self action:@selector(fieldTextDidUpdate:) forControlEvents:UIControlEventEditingDidEnd];
							textField.delegate = nil;
							}
						}
					}
				else if ([nextView isKindOfClass:[UITableView class]])
					{
					UITableView *tableView = (UITableView *)nextView;
					tableView.dataSource = nil;
					tableView.delegate = nil;
					}
				}
			}
		optionPopoverController.delegate = nil;
		optionPopoverController = nil;
		}
}

#pragma mark - Notifications

- (void)fieldTextDidUpdate:(id)sender
{
	
	UITextField *field = (UITextField *)sender;

	if ([field.text length])
		{
		if (optionPopoverController)
			{
			optionPopoverController.delegate = nil;
			optionPopoverController = nil;
			[parentController dismissViewControllerAnimated:NO completion:nil];
			field.delegate = nil;				// textFieldShouldReturn was still getting called on the released textField before the popover was deconstructed
			}
		[delegate rowItem:self controlDidSetValue:field.text];
		}
}

- (void)fieldTextDidStartEditing:(id)sender
{
	[delegate rowItemWasSelected:self];
}

#pragma mark - Text field delegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{

	[textField resignFirstResponder];
	return NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{

	if ([textField isFirstResponder])
		{
		[textField resignFirstResponder];
		}
}

@end
