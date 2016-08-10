//
//  Collection.h
//  wonderbolt
//
//  Created by Peter Kazazes on 12/21/13.
//  Copyright (c) 2013 Josh Koerpel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Bolt;

@interface Collection : NSManagedObject

@property (nonatomic, strong) NSNumber *datasetId;
@property (nonatomic, strong) NSSet *bolts;
@end

@interface Collection (CoreDataGeneratedAccessors)

- (void)addBoltsObject:(Bolt *)value;
- (void)removeBoltsObject:(Bolt *)value;
- (void)addBolts:(NSSet *)values;
- (void)removeBolts:(NSSet *)values;

@end
