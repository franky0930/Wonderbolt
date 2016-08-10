//
//  wonderboltTests.m
//  wonderboltTests
//
//  Created by Peter Kazazes on 11/9/13.
//  Copyright (c) 2013 Josh Koerpel. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PhysicalMeasurement.h"

#define kVerySmallValue     (0.000001)
#define ARC4RANDOM_MAX      0x100000000

@interface wonderboltTests : XCTestCase

@property (nonatomic) PhysicalMeasurement *measurement;

- (void)testInchesToPoints;
- (void)testPointsToInches;

@end

@implementation wonderboltTests
@synthesize measurement;

- (void)setUp
{
    [super setUp];
    measurement = [[PhysicalMeasurement alloc] init];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInchesToPoints
{
    for (double i = 0; i < 150; i += 1) {
        double rand = [self randomDouble:100];
        double points = [measurement inchesToScreenPoints:rand];
        double reference = rand * [measurement PPIForDevice:[UIDevice currentDevice]] / [[UIScreen mainScreen] scale];
        XCTAssertTrue(fabs(points - reference) < kVerySmallValue);
    }
}

- (void)testPointsToInches
{
    for (double i = 0; i < 150; i += 1) {
        double points = [self randomDouble:1000];
        double inches = [measurement pointsToScreenInches:points];
        
        double reference = [measurement inchesToScreenPoints:inches];
        
        if (fabs(reference - points) > kVerySmallValue) {
            NSLog(@"Off by: %f", reference - points);
            XCTAssertTrue(FALSE);
        }
    }
}

- (double)randomDouble:(double)maxSize {
    double d = ((double)arc4random() / ARC4RANDOM_MAX) * maxSize;
    return d;
}

@end
