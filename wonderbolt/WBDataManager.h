//
//  WBDataManager.h
//  wonderbolt
//
//  
//  Copyright (c) 2014 Josh Koerpel. All rights reserved.
//

#import "Bolt.h"
#import "DrillBit.h"
#import "Collection.h"

@interface WBDataManager : NSObject

@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+(WBDataManager *) sharedInstance;

-(void) setupDB;
-(NSError *) saveContext;

@end
