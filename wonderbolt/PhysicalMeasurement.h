//
//  WBPPIValue.h
//  wonderbolt
//
//  Created by Peter Kazazes on 11/14/13.
//  Copyright (c) 2013 Josh Koerpel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhysicalMeasurement : NSObject

- (double)PPIForDevice:(UIDevice *)device;
- (double)pointsToScreenInches:(double)points;
- (double)pointsToScreenCentimeters:(double)points;
- (double)inchesToScreenPoints:(double)inches;
- (NSString *)modelIdentifier;

@end
