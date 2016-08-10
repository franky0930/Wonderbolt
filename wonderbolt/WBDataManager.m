//
//  WBDataManager.m
//  wonderbolt
//
//
//  Copyright (c) 2014 Josh Koerpel. All rights reserved.
//

#import "WBDataManager.h"

#import "CSVParser.h"

@interface WBDataManager () {
	BOOL forceResetDB;
}

@end

@implementation WBDataManager

#pragma mark - Setup

static dispatch_queue_t serialQueue;

+(WBDataManager *) sharedInstance
{
    static dispatch_once_t pred;
    static WBDataManager *sharedInstance = nil;
	
    dispatch_once(&pred, ^{
        sharedInstance = [[WBDataManager alloc] init];
    });
	
    return sharedInstance;
}

-(id) init
{
	if ((self=[super init])) {
	}
	
	return self;
}

-(void) setupDB
{
	[self managedObjectContext];
	[self purgeDB];
	[self loadDataFromCSVFiles];
	[self debugDataObjects:@"Bolt"];
	[self debugDataObjects:@"Collection"];
}

#pragma mark - Data import

-(void) loadDataFromCSVFiles
{
	NSArray *fieldNames = @[
							@"objectType", @"unitType", @"dataset", @"diameter", @"sizeInInches", @"sizeInMillimeters", @"stringTitle", @"tpi", @"threadType", @"minorDiameterInInches", @"minorDiameterInMillimeters", @"sizeEquivalent", @"largerOrSmaller", @"allenWrenchSize", @"allenWrenchLikelySubstitute", @"socketWrenchSize", @"socketWrenchLikelySubstitute", @"normalFit", @"normalFitDecimalEquivalent", @"normalFitClosestEquivalent", @"tightFit", @"tightFitDecimalEquivalent", @"tightFitClosestEquivalent", @"threeQuarterThreadAluminumDrillSize", @"threeQuarterThreadAluminumDrillSizeDecimalEquivalent", @"halfThreadSteelDrillSize", @"halfThreadSteelDrillSizeDecimalEquivalent", @"tapTitle"
							];
	
	CSVParser *parser = [[CSVParser alloc] initWithContentOfFile:[[NSBundle mainBundle] pathForResource:@"Bolts" ofType:@"csv"] separator:@"," hasHeader:YES fieldNames:fieldNames];
    
	NSArray *loadedData = [parser parseFile];
	
	NSFetchRequest *collectionFetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *collectoinEntityDescription = [NSEntityDescription entityForName:@"Collection" inManagedObjectContext:self.managedObjectContext];
	[collectionFetchRequest setEntity:collectoinEntityDescription];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"datasetId >= 0"];
	[collectionFetchRequest setPredicate:predicate];
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"datasetId" ascending:YES];
	[collectionFetchRequest setSortDescriptors:@[sortDescriptor]];
    
	NSError *error;
	NSMutableArray *collections = [[self.managedObjectContext executeFetchRequest:collectionFetchRequest error:&error] mutableCopy];
    NSMutableArray *bolts = [NSMutableArray array];
	
	if (collections == nil) {
		collections = [NSMutableArray array];
	}
    
    
	for (NSDictionary *dict in loadedData) {
        if ([[dict objectForKey:@"objectType"] isEqualToString:@"B"]) {
            Bolt *bolt = [NSEntityDescription insertNewObjectForEntityForName:@"Bolt" inManagedObjectContext:self.managedObjectContext];
            [bolts addObject:bolt];
            
            NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
            [decimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
            
            NSNumberFormatter *integerFormatter = [[NSNumberFormatter alloc] init];
            [integerFormatter setNumberStyle:NSNumberFormatterNoStyle];
            
            for (NSString *a in dict) {
                id value = [dict objectForKey:a];
                
                @try {
                    [bolt setValue:value forKey:a];
                }
                @catch (NSException *exception) {
                    value = [decimalFormatter numberFromString:value];
                }
                @finally {
                    [bolt setValue:value forKey:a];
                }
                
            }
            
            Collection *collection = [self collectionWithDatasetId:[integerFormatter numberFromString:[dict objectForKey:@"dataset"]] collections:collections];
            [collection addBoltsObject:bolt];
        }
    }
    
	NSError *saveError = [self saveContext];
	if (saveError) {
		//FIXME: do something
	}
}

-(Collection *) collectionWithDatasetId:(NSNumber *)datasetId collections:(NSMutableArray *)collections
{
	Collection *collection;
	
	for (Collection *c in collections) {
		if ([c.datasetId isEqualToNumber:datasetId]) {
			collection = c;
			break;
		}
	}
	
	if (!collection) {
		NSEntityDescription *collectoinEntityDescription = [NSEntityDescription entityForName:@"Collection" inManagedObjectContext:self.managedObjectContext];
		collection = [[Collection alloc] initWithEntity:collectoinEntityDescription insertIntoManagedObjectContext:self.managedObjectContext];
        
		collection.datasetId = datasetId;
		[collections insertObject:collection atIndex:0];
	}
	
	return collection;
}

#pragma mark - Data cleanup

- (void)purgeDB {
	[self deleteAllObjectsOfDescription:@"Bolt"];
	[self deleteAllObjectsOfDescription:@"DrillBit"];
	[self deleteAllObjectsOfDescription:@"Collection"];
}

- (void)deleteAllObjectsOfDescription:(NSString *)entityDescription {
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:entityDescription inManagedObjectContext:self.managedObjectContext];
	[fetchRequest setEntity:entity];
    
	NSError *error;
	NSArray *items = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
	int i = 0;
	for (NSManagedObject *managedObject in items) {
		[self.managedObjectContext deleteObject:managedObject];
		i++;
	}
    
	WBLOG1_INFO(@"%d %@ objects removed.", i, entityDescription);
	[self saveContext];
}

- (void)debugDataObjects:(NSString *)entityName {
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:self.managedObjectContext];
	[fetchRequest setEntity:entity];
    
	NSError *error;
	NSArray *items = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
	WBLOG1_INFO(@"%lu %@ objects found.", (unsigned long)[items count], entityName);
}


#pragma mark - Core Data

-(NSManagedObjectContext *) managedObjectContext
{
	if (_managedObjectContext != nil) {
		return _managedObjectContext;
	}
	
	NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
	
	if (coordinator != nil) {
		_managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
		[_managedObjectContext setPersistentStoreCoordinator:coordinator];
		[_managedObjectContext setMergePolicy:NSOverwriteMergePolicy];
	}
	
	return _managedObjectContext;
}

-(NSManagedObjectModel *) managedObjectModel
{
	if (_managedObjectModel != nil) {
		return _managedObjectModel;
	}
	
    NSURL *modelURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:WB_DATABASE ofType:WB_DATABASE_TYPE]];
    _managedObjectModel = [[[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL] mutableCopy];
	
	return _managedObjectModel;
}


-(NSPersistentStoreCoordinator *) persistentStoreCoordinator
{
	if (_persistentStoreCoordinator != nil) {
		return _persistentStoreCoordinator;
	}
	
	NSError __autoreleasing *error = nil;
	BOOL success = [self ensureDirectoryExistsAtPath:[self applicationDocumentsDirectory] error:&error];
	
	if (!success) {
		//FIXME: UI for FATAL error
		WBLOG1_INFO(@"Failed to create Application Data Directory at path '%@': %@", [self applicationDocumentsDirectory], error);
        //		[(AppDelegate *)[[UIApplication sharedApplication] delegate] showError:@"Error initializing data folder. Restart the application!"];
		return nil;
	}
	
	NSString *path = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:WB_DATABASE_NAME];
	
	if (forceResetDB || WB_USER_GET_I(WB_K_DATABASE_VERSION) != WB_DATABASE_VERSION) {
		forceResetDB = NO;
		
		// cleanup old db at startup
		if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
			[[NSFileManager defaultManager] removeItemAtPath:path error:&error];
			
			if (error) {
				WBLOG1_INFO(@"Failed to delete old database file at path '%@': %@", path, error);
                //				[(AppDelegate *)[[UIApplication sharedApplication] delegate] showError:@"Error deleting old database. Restart the application!"];
				return nil;
			}
		}
		WB_USER_SET_I(WB_K_DATABASE_VERSION, WB_DATABASE_VERSION, YES);
	}
	
	_persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
								   initWithManagedObjectModel:[self managedObjectModel]];
	
	[_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
											  configuration:nil
														URL:[NSURL fileURLWithPath:path]
													options:@{
															  NSMigratePersistentStoresAutomaticallyOption:@YES,
															  NSInferMappingModelAutomaticallyOption:@YES,
															  NSSQLitePragmasOption : @{@"journal_mode" : @"WAL"}
															  }
													  error:&error
	 ];
	
	if (error) {
		WBLOG1_INFO(@"Failed adding persistent store at path '%@': %@", path, error);
        //		[(AppDelegate *)[[UIApplication sharedApplication] delegate] showError:@"Error creating database. Restart the application!"];
		return nil;
	}
	
	WBLOG1_INFO(@"DATABASE PATH: %@", path);
	
	return _persistentStoreCoordinator;
}

-(NSError *) saveContext
{
	NSError __autoreleasing *error = nil;
	NSManagedObjectContext *context = self.managedObjectContext;
	
	[context processPendingChanges];
	if ([context hasChanges] && ![context save:&error]) {
		NSArray* detailedErrors = [[error userInfo] objectForKey:NSDetailedErrorsKey];
		
		if(detailedErrors != nil && [detailedErrors count] > 0) {
			for (NSError* detailedError in detailedErrors) {
				WBLOG1_INFO(@"  DetailedError: %@", [detailedError userInfo]);
			}
		} else {
			WBLOG1_INFO(@"  %@", [error userInfo]);
		}
	}
	
	return error;
}

-(void) resetContext
{
	_managedObjectContext = nil;
	_persistentStoreCoordinator = nil;
	_managedObjectModel = nil;
}

#pragma mark - File Utilities

-(BOOL) ensureDirectoryExistsAtPath:(NSString *)path error:(NSError **)error
{
    BOOL isDirectory;
    if ([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory]) {
        if (isDirectory) {
            // Exists at a path and is a directory, we're good
            if (error) *error = nil;
            return YES;
        }
    }
	
    // Create the directory and any intermediates
    NSError *errorReference = (error == nil) ? nil : *error;
    if (! [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&errorReference]) {
        WBLOG1_INFO(@"Failed to create requested directory at path '%@': %@", path, errorReference);
        return NO;
    }
	
    return YES;
}

-(NSString *) applicationDocumentsDirectory
{
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

@end
