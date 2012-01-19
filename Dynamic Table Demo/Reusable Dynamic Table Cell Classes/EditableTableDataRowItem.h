/*******************************************************************************
 * EditableTableDataRowItem.h
 *
 * Title:			Giftory
 * Description:		Gift Repository for iPad
 *						This header file contains the template for the
 *						application's editable table row item for data entities
 * Author:			Eric Crichlow
 * Version:			1.0
 * Copyright:		(c) 2011 Infusions of Grandeur. All rights reserved.
 ********************************************************************************
 *	08/15/11		*	EGC	*	File creation date
 *	01/17/12		*	EGC	*	Made changes to delegate to support row selection
 *******************************************************************************/

#import <Foundation/Foundation.h>

#define DEFAULT_POPOVER_WIDTH			320
#define DEFAULT_TOOLBAR_HEIGHT			44
#define DEFAULT_COMBO_TEXTFIELD_HEIGHT	36
#define DEFAULT_COMBO_TEXTFIELD_MARGIN	4
#define DEFAULT_TEXTFIELD_FONT_SIZE		12
#define DEFAULT_POPUP_FONT_SIZE			12
#define DEFAULT_COMBO_FONT_SIZE			14
#define DEFAULT_BUTTON_FONT_SIZE		12

typedef enum
{
	ControlTypeTextField,
	ControlTypePopup,
	ControlTypeCombo,
	ControlTypeButton,
	ControlTypeToggleButton
} RowItemControlType;

@protocol EditableTableDataRowItemDelegate;

@interface EditableTableDataRowItem : NSObject <UITableViewDataSource, UITableViewDelegate, UIPopoverControllerDelegate, UITextFieldDelegate>
{

	id<EditableTableDataRowItemDelegate> delegate;

	RowItemControlType			itemControlType;		// So named to denote that this does not correspond to a UIControl
	NSArray						*controlSelections;		// List of items to display for popup control type
	NSString					*listKey;				// If controlSelections array contains NSManagedObjects or NSDictionaries, the key to use to get a string to represent the item
	CGSize						baseSize;				// Default size of the control, with width relative to other items on the row
	BOOL						resizeable;				// Determines whether item can be resized based on row width
	UIControl					*control;				// Standard control particular to the type of row item
	UIImage						*normalImage;			// Used to customize the appearance of any button-based control type
	UIImage						*selectedImage;			// Used to customize the appearance of any button-based control type

	CGSize						originalBaseSize;
	int							state;
	int							selectedIndex;
	UIPopoverController			*optionPopoverController;
}
@property(assign) id<EditableTableDataRowItemDelegate> delegate;
@property(nonatomic, assign, readonly) RowItemControlType itemControlType;
@property(nonatomic, retain) NSArray *controlSelections;
@property(nonatomic, retain) NSString *listKey;
@property(nonatomic, assign) CGSize baseSize;
@property(nonatomic, assign, readonly) BOOL resizeable;
@property(nonatomic, retain) UIControl *control;
@property(nonatomic, retain) UIImage *normalImage;
@property(nonatomic, retain) UIImage *selectedImage;
@property(nonatomic, assign) CGSize originalBaseSize;
- (id)initWithRowItemControlType:(int)controlType selections:(NSArray *)selections selectionListKey:(NSString *)selectionListKey baseSize:(CGSize)size canResize:(BOOL)resize normalImage:(UIImage *)normalImage selectedImage:(UIImage *)selectedImage controlLabel:(NSString *)label buttonTarget:(id)target buttonAction:(SEL)action;
- (id)initWithRowItemControlType:(int)controlType canResize:(BOOL)resize;
@end

@protocol EditableTableDataRowItemDelegate
- (void)rowItem:(EditableTableDataRowItem *)rowItem controlDidSelectItem:(id)selection;					// Used for popup and comboBox type controls
- (void)rowItem:(EditableTableDataRowItem *)rowItem controlDidSetValue:(NSString *)newValue;			// Used for text field and comboBox type controls
- (void)rowItem:(EditableTableDataRowItem *)rowItem controlDidToggleToValue:(BOOL)newToggleValue;		// Used for toggle button control type
- (void)rowItemWasSelected:(EditableTableDataRowItem *)rowItem;											// Used for highlighting the control's row
@end

