//
//  WBPPIValue.m
//  wonderbolt
//
//  Created by Peter Kazazes on 11/14/13.
//  Copyright (c) 2013 Josh Koerpel. All rights reserved.
//

#import "PhysicalMeasurement.h"
#include <sys/sysctl.h>
#import <UIDevice-Hardware.h>

@interface PhysicalMeasurement () {
	NSDictionary *devicesPPI;
}

@end

@implementation PhysicalMeasurement

-(id) init
{
	self = [super init];
	if (self) {
		devicesPPI = [[NSMutableDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:WB_DEVICES_PPI ofType:WB_DEVICES_PPI_TYPE]];
		if (!devicesPPI) {
			devicesPPI = [NSMutableDictionary dictionary];
		}
		WBLOG1_INFO(@"DevicesPPI: %@", [devicesPPI description]);
	}
	
	return self;
}

- (double)PPIForDevice:(UIDevice *)device {
	NSString *modelIdentifier = [device modelIdentifier];
    NSNumber *ppi = [devicesPPI objectForKey:modelIdentifier];

	if (!ppi) {
		[NSException raise:@"UnknownDeviceException" format:[NSString stringWithFormat:@"%@", modelIdentifier], nil];
		return -1;
	} else {
		return [ppi integerValue];
	}
	
//	// hardcoded PPI values
//	// for new devices, check:
//	// http://blakespot.com/ios_device_specifications_grid.html
//    
//	if ([modelIdentifier isEqualToString:@"iPhone1,1"] || [modelIdentifier isEqualToString:@"iPhone1,2"] || [modelIdentifier isEqualToString:@"iPhone2,1"] ||
//	    [modelIdentifier isEqualToString:@"iPod1,1"] || [modelIdentifier isEqualToString:@"iPod2,1"] || [modelIdentifier isEqualToString:@"iPod3,1"] ||
//		[modelIdentifier isEqualToString:@"iPad2,5"] || [modelIdentifier isEqualToString:@"iPad2,6"] || [modelIdentifier isEqualToString:@"iPad2,7"] ||
//		[modelIdentifier isEqualToString:@"iPad4,4"] || [modelIdentifier isEqualToString:@"iPad4,5"])
//		return 163;
//	else if ([modelIdentifier isEqualToString:@"iPad1,1"] || [modelIdentifier isEqualToString:@"iPad2,1"] || [modelIdentifier isEqualToString:@"iPad2,2"] ||
//			 [modelIdentifier isEqualToString:@"iPad2,3"] || [modelIdentifier isEqualToString:@"iPad2,4"])
//		return 132;
//	else if ((modelIdentifier.length > 7) && ([modelIdentifier isEqualToString:@"iPhone3,1"] || [modelIdentifier isEqualToString:@"iPhone3,2"] ||
//											  [modelIdentifier isEqualToString:@"iPhone3,3"] || [modelIdentifier isEqualToString:@"iPod4,1"] ||
//											  [modelIdentifier isEqualToString:@"iPhone4,1"] || [modelIdentifier hasPrefix:@"iPhone5"] ||
//											  [modelIdentifier isEqualToString:@"iPod5,1"] || [modelIdentifier hasPrefix:@"iPhone6"]))
//		return 326;
//	else if ([modelIdentifier hasPrefix:@"iPad3"])
//		return 264;
//	else if ([modelIdentifier isEqualToString:@"i386"] || [modelIdentifier isEqualToString:@"x86_64"])
//		return 163;
    
}

- (double)pointsToScreenInches:(double)points {
	double devicePPI = [self PPIForDevice:[UIDevice currentDevice]];
	double scaledPPI = devicePPI / [[UIScreen mainScreen] scale];
    
	return points / scaledPPI;
}

- (double)pointsToScreenCentimeters:(double)points {
	return ([self pointsToScreenInches:points]) * 2.5400;
}

- (double)inchesToScreenPoints:(double)inches {
    double devicePPI = [self PPIForDevice:[UIDevice currentDevice]];
    double scale = [[UIScreen mainScreen] scale];
    double scaledPPI = devicePPI / scale;
    
    double points = scaledPPI * inches;
    
    return points;
}

- (NSString *)getSysInfoByName:(char *)typeSpecifier {
	size_t size;
	sysctlbyname(typeSpecifier, NULL, &size, NULL, 0);
    
	char *answer = malloc(size);
	sysctlbyname(typeSpecifier, answer, &size, NULL, 0);
    
	NSString *results = [NSString stringWithCString:answer encoding:NSUTF8StringEncoding];
    
	free(answer);
	return results;
}

- (NSString *)modelIdentifier {
	return [self getSysInfoByName:"hw.machine"];
}

@end
