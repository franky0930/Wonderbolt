//
//  DrillBit.h
//  wonderbolt
//
//  Created by Peter Kazazes on 12/21/13.
//  Copyright (c) 2013 Josh Koerpel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface DrillBit : NSManagedObject

@property (nonatomic, strong) NSString *size;
@property (nonatomic, strong) NSNumber *inches;
@property (nonatomic, strong) NSNumber *millimeters;
@property (nonatomic, strong) NSNumber *iphoneRetinaPoints;
@property (nonatomic, strong) NSNumber *iphoneNonRetinaPoints;
@property (nonatomic, strong) NSNumber *ipadNonRetinaPoints;
@property (nonatomic, strong) NSNumber *ipadRetinaPoints;
@property (nonatomic, strong) NSNumber *ipadMiniNonRetinaPoints;
@property (nonatomic, strong) NSNumber *ipadMiniRetinaPoints;

@end
