/*******************************************************************************
 * MockDataManager.m
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

#import "MockDataManager.h"

@implementation MockDataManager

@synthesize autoCollection;
@synthesize makerList;
@synthesize modelList;
@synthesize colorList;

#pragma mark - Business Logic

- (void)addAutoCollectionObject:(NSDictionary *)object
{
	[autoCollection addObject:object];
}

#pragma mark - Object lifecycle

- (id)init
{
	
	self = [super init];
	if (self)
		{
		NSMutableDictionary *car1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"1963", @"year", @"Ford", @"make", @"Mustang", @"model", @"Red", @"color", @"67,042", @"mileage", [NSNumber numberWithBool:YES], @"titled", nil];
		NSMutableDictionary *car2 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"1975", @"year", @"Chevrolet", @"make", @"Corvette", @"model", @"Black", @"color", @"24,316", @"mileage", [NSNumber numberWithBool:YES], @"titled", nil];
		NSMutableDictionary *car3 = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"1988", @"year", @"Honda", @"make", @"Prelude", @"model", @"Green", @"color", @"92,624", @"mileage", [NSNumber numberWithBool:NO], @"titled", nil];
		NSArray *acuraModels = [NSArray arrayWithObjects:@"RL", @"TL", @"TSX", nil];
		NSArray *audiModels = [NSArray arrayWithObjects:@"A5", @"R8", @"S5", @"TT", nil];
		NSArray *BMWModels = [NSArray arrayWithObjects:@"5 Series", @"6 Series", @"7 Series", nil];
		NSArray *cadillacModels = [NSArray arrayWithObjects:@"DTS", @"Escalade", @"SRS", @"STX", nil];
		NSArray *chevroletModels = [NSArray arrayWithObjects:@"Impala", @"Malibu", @"Camaro", @"Corvette", nil];
		NSArray *chryslerModels = [NSArray arrayWithObjects:@"300", @"Sebring", nil];
		NSArray *dodgeModels = [NSArray arrayWithObjects:@"Challenger", @"Viper", @"Charger", nil];
		NSArray *ferrariModels = [NSArray arrayWithObjects:@"Italia", @"Fiorano", nil];
		NSArray *fordModels = [NSArray arrayWithObjects:@"Mustang", @"Focus", @"Taurus", nil];
		NSArray *hondaModels = [NSArray arrayWithObjects:@"Accord", @"Civic", @"Prelude", nil];
		NSArray *jaguarModels = [NSArray arrayWithObjects:@"XF", @"XJ Series", @"XK Series", nil];
		NSArray *lexusModels = [NSArray arrayWithObjects:@"GS", @"LS", @"LX", nil];
		NSArray *mercedesModels = [NSArray arrayWithObjects:@"E-Class", @"SL-Class", @"SLS-Class", nil];
		NSArray *porscheModels = [NSArray arrayWithObjects:@"911", @"Turbo Carrera", nil];
		NSArray *toyotaModels = [NSArray arrayWithObjects:@"Camry", @"Corolla", @"Solara", nil];
		NSArray *volkswagenModels = [NSArray arrayWithObjects:@"Golf", @"GTI", @"Jetta", @"Passat", nil];
		NSArray *volvoModels = [NSArray arrayWithObjects:@"S80", @"S60", @"S40", nil];
		autoCollection = [[NSMutableArray arrayWithObjects:car1, car2, car3, nil] retain];
		makerList = [[NSArray arrayWithObjects:@"Acura", @"Audi", @"BMW", @"Cadillac", @"Chevrolet", @"Chrysler", @"Dodge", @"Ferrari", @"Ford", @"Honda", @"Jaguar", @"Lexus", @"Mercedes-Benz", @"Porsche", @"Toyota", @"Volkswagen", @"Volvo", nil] retain];
		modelList = [[NSDictionary dictionaryWithObjectsAndKeys:acuraModels, @"Acura", audiModels, @"Audi", BMWModels, @"BMW", cadillacModels, @"Cadillac", chevroletModels, @"Chevrolet", chryslerModels, @"Chrysler", dodgeModels, @"Dodge", ferrariModels, @"Ferrari", fordModels, @"Ford", hondaModels, @"Honda", jaguarModels, @"Jaguar", lexusModels, @"Lexus", mercedesModels, @"Mercedes-Benz", porscheModels, @"Porsche", toyotaModels, @"Toyota", volkswagenModels, @"Volkswagen", volvoModels, @"Volvo", nil] retain];
		colorList = [[NSArray arrayWithObjects:@"Black", @"Red", @"Silver", @"Blue", @"Green", @"Yellow", @"Purple", @"Other", nil] retain];
		}
	return self;
}

- (void)dealloc
{

	[autoCollection release];
	[makerList release];
	[modelList release];
	[colorList release];
	[super dealloc];
}

@end
