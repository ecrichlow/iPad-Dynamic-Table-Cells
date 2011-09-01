/*******************************************************************************
 * DemoTableViewController.h
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
 *******************************************************************************/

#import <UIKit/UIKit.h>
#import "MockDataManager.h"
#import "EditableTableDataRow.h"

#define DEFAULT_ROW_ITEM_PADDING						36

#define TABLE_COLUMN_YEAR								0
#define TABLE_COLUMN_MAKE								1
#define TABLE_COLUMN_MODEL								2
#define TABLE_COLUMN_COLOR								3
#define TABLE_COLUMN_MILEAGE							4
#define TABLE_COLUMN_TITLED								5
#define TABLE_COLUMN_IMAGE								6

#define YEAR_COLUMN_RELATIVE_WIDTH						45
#define MAKE_COLUMN_RELATIVE_WIDTH						100
#define MODEL_COLUMN_RELATIVE_WIDTH						100
#define COLOR_COLUMN_RELATIVE_WIDTH						80
#define MILEAGE_COLUMN_RELATIVE_WIDTH					80
#define TITLED_COLUMN_RELATIVE_WIDTH					30
#define IMAGE_COLUMN_RELATIVE_WIDTH						40
#define NUMBER_OF_DATA_FIELDS							7

#define DEFAULT_POPOVER_WIDTH							320
#define DEFAULT_POPUP_HEIGHT							21
#define DEFAULT_COMBO_HEIGHT							24
#define DEFAULT_TEXTFIELD_HEIGHT						24

#define TABLE_HEADER_LABEL_PORTRAIT						@"         Year             Make                        Model                       Color                   Mileage             Titled?     Image"
#define TABLE_HEADER_LABEL_LANDSCAPE					@"         Year            Make                                 Model                       Color                          Mileage                    Titled?     Image"


@interface DemoTableViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, EditableTableDataRowDelegate>
{

	UITableView					*autoTableView;
	UILabel						*tableHeader;

	MockDataManager				*dataManager;
}
@property (nonatomic, retain) IBOutlet UITableView *autoTableView;
@property (nonatomic, retain) IBOutlet UILabel *tableHeader;
- (IBAction)addAuto:(id)sender;
@end
