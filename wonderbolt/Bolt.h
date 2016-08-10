//
//  Bolt.h
//  wonderbolt
//
//  Created by Peter Kazazes on 2/17/14.
//  Copyright (c) 2014 Josh Koerpel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Collection;

@interface Bolt : NSManagedObject

@property (nonatomic, retain) NSString * objectType;
@property (nonatomic, retain) NSString * unitType;
@property (nonatomic, retain) NSNumber * dataset;
@property (nonatomic, retain) NSString * diameter;
@property (nonatomic, retain) NSNumber * sizeInInches;
@property (nonatomic, retain) NSNumber * sizeInMillimeters;
@property (nonatomic, retain) NSString * stringTitle;
@property (nonatomic, retain) NSNumber * tpi;
@property (nonatomic, retain) NSString * threadType;
@property (nonatomic, retain) NSNumber * minorDiameterInInches;
@property (nonatomic, retain) NSNumber * minorDiameterInMillimeters;
@property (nonatomic, retain) NSString * sizeEquivalent;
@property (nonatomic, retain) NSString * largerOrSmaller;
@property (nonatomic, retain) NSString * allenWrenchSize;
@property (nonatomic, retain) NSString * allenWrenchLikelySubstitute;
@property (nonatomic, retain) NSString * socketWrenchSize;
@property (nonatomic, retain) NSString * socketWrenchLikelySubstitute;
@property (nonatomic, retain) NSString * normalFit;
@property (nonatomic, retain) NSNumber * normalFitDecimalEquivalent;
@property (nonatomic, retain) NSString * normalFitClosestEquivalent;
@property (nonatomic, retain) NSString * tightFit;
@property (nonatomic, retain) NSNumber * tightFitDecimalEquivalent;
@property (nonatomic, retain) NSString * tightFitClosestEquivalent;
@property (nonatomic, retain) NSString * threeQuarterThreadAluminumDrillSize;
@property (nonatomic, retain) NSNumber * threeQuarterThreadAluminumDrillSizeDecimalEquivalent;
@property (nonatomic, retain) NSString * halfThreadSteelDrillSize;
@property (nonatomic, retain) NSNumber * halfThreadSteelDrillSizeDecimalEquivalent;
@property (nonatomic, retain) NSString * tapTitle;
@property (nonatomic, retain) Collection *collection;

@end
