
//
// WBBoltDetailViewController.m
// wonderbolt
//
// Created by Peter Kazazes on 2/21/14.
// Copyright (c) 2014 Josh Koerpel. All rights reserved.
//

#import "WBBoltDetailViewController.h"
#import "PhysicalMeasurement.h"
#import "WBAlternateThreadViewController.h"
#import "WBSavedViewController.h"
#import "WBBlankMeasureViewController.h"

@interface WBBoltDetailViewController ()

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (strong, nonatomic) IBOutlet UIImageView *skeletonImage;
@property (strong, nonatomic) IBOutlet UILabel *boltTitle;
@property (strong, nonatomic) IBOutlet UILabel *boltName;
@property (strong, nonatomic) IBOutlet UIImageView *usImage;
@property (strong, nonatomic) IBOutlet UIImageView *metricImage;
@property (strong, nonatomic) IBOutlet UILabel *majorInches;
@property (strong, nonatomic) IBOutlet UILabel *majorMillimeters;
@property (strong, nonatomic) IBOutlet UILabel *tpi;
@property (strong, nonatomic) IBOutlet UILabel *minorInches;
@property (strong, nonatomic) IBOutlet UILabel *minorMillimeters;
@property (strong, nonatomic) IBOutlet UILabel *closestEquivalent;
@property (strong, nonatomic) IBOutlet UILabel *closestEquivalentDirection;
@property (strong, nonatomic) IBOutlet UILabel *socketSize;
@property (strong, nonatomic) IBOutlet UILabel *socketSubstitute;
@property (strong, nonatomic) IBOutlet UILabel *allenWrench;
@property (strong, nonatomic) IBOutlet UILabel *allenWrenchSubstitute;
@property (strong, nonatomic) IBOutlet UILabel *normalFitDrillSize;
@property (strong, nonatomic) IBOutlet UILabel *normalFitDrillSizeInches;
@property (strong, nonatomic) IBOutlet UILabel *normalFitDrillSizeMillimeters;
@property (strong, nonatomic) IBOutlet UILabel *tightFitDrillSize;
@property (strong, nonatomic) IBOutlet UILabel *tightFitDrillSizeInches;
@property (strong, nonatomic) IBOutlet UILabel *tightFitDrillSizeMillimeters;
@property (strong, nonatomic) IBOutlet UILabel *softThreadEngagement;
@property (strong, nonatomic) IBOutlet UILabel *hardThreadEngagement;
@property (strong, nonatomic) IBOutlet UILabel *softThreadEngagementDrillSize;
@property (strong, nonatomic) IBOutlet UILabel *softThreadEngagementInInches;
@property (strong, nonatomic) IBOutlet UILabel *softThreadEngagementInMillimeters;
@property (strong, nonatomic) IBOutlet UILabel *hardThreadEngagementDrillSize;
@property (strong, nonatomic) IBOutlet UILabel *hardThreadEngagementInInches;
@property (strong, nonatomic) IBOutlet UILabel *hardThreadEngagementInMillimeters;
@property (strong, nonatomic) IBOutlet UIImageView *threadViewLeft;
@property (strong, nonatomic) IBOutlet UIImageView *threadViewRight;


@end

@implementation WBBoltDetailViewController

@synthesize currentBolt, isProductOfSavedView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIBarButtonItem *saveItem = [self getSaveButton];
    self.navigationItem.rightBarButtonItem = saveItem;
}

- (void)fillInDetails {
    NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
    [decimalFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [decimalFormatter setMaximumFractionDigits:3];
    
    NSNumberFormatter *decimalFormatter2 = [[NSNumberFormatter alloc] init];
    [decimalFormatter2 setNumberStyle:NSNumberFormatterDecimalStyle];
    [decimalFormatter2 setMaximumFractionDigits:1];

    PhysicalMeasurement *measurement = [[PhysicalMeasurement alloc] init];
    
    if ([currentBolt.unitType isEqualToString:@"S"]) {
        _metricImage.hidden = YES;
    } else if ([currentBolt.unitType isEqualToString:@"M"]) {
        _usImage.hidden = YES;
        self.skeletonImage.image = [UIImage imageNamed:@"skeleton-metric.png"];
    }
    
    _boltTitle.text = currentBolt.stringTitle;
    _boltName.text = currentBolt.tapTitle;
    _majorInches.text = [decimalFormatter stringFromNumber:currentBolt.sizeInInches];
    _majorMillimeters.text = [decimalFormatter2 stringFromNumber:currentBolt.sizeInMillimeters];
    _tpi.text = [currentBolt.tpi stringValue];
    
    _minorInches.text = [decimalFormatter stringFromNumber:currentBolt.minorDiameterInInches];
    _minorMillimeters.text = [decimalFormatter2 stringFromNumber:currentBolt.minorDiameterInMillimeters];
    _closestEquivalent.text = currentBolt.sizeEquivalent;
    _closestEquivalentDirection.text = @"---";
    
    _socketSize.text = currentBolt.socketWrenchSize;
    _socketSubstitute.text = currentBolt.socketWrenchLikelySubstitute;
    _allenWrench.text = currentBolt.allenWrenchSize;
    _allenWrenchSubstitute.text = currentBolt.allenWrenchLikelySubstitute;
    
    _normalFitDrillSize.text = currentBolt.normalFit;
    _normalFitDrillSizeInches.text = [decimalFormatter stringFromNumber:currentBolt.normalFitDecimalEquivalent];
    _normalFitDrillSizeMillimeters.text = currentBolt.normalFitClosestEquivalent;
    
    _tightFitDrillSize.text = currentBolt.tightFit;
    _tightFitDrillSizeInches.text = [decimalFormatter stringFromNumber:currentBolt.tightFitDecimalEquivalent];
    _tightFitDrillSizeMillimeters.text = currentBolt.tightFitClosestEquivalent;
    
    _softThreadEngagement.text = @"75%";
    _softThreadEngagementDrillSize.text = currentBolt.threeQuarterThreadAluminumDrillSize;
    _softThreadEngagementInInches.text = [decimalFormatter stringFromNumber:currentBolt.threeQuarterThreadAluminumDrillSizeDecimalEquivalent];
    _softThreadEngagementInMillimeters.text = [decimalFormatter2 stringFromNumber:[NSNumber numberWithDouble:[currentBolt.threeQuarterThreadAluminumDrillSizeDecimalEquivalent doubleValue] * 25.4]];
    
    _hardThreadEngagement.text = @"50%";
    _hardThreadEngagementDrillSize.text = currentBolt.halfThreadSteelDrillSize;
    _hardThreadEngagementInInches.text = [decimalFormatter stringFromNumber:currentBolt.halfThreadSteelDrillSizeDecimalEquivalent];
    _hardThreadEngagementInMillimeters.text = [decimalFormatter2 stringFromNumber:[NSNumber numberWithDouble:[currentBolt.halfThreadSteelDrillSizeDecimalEquivalent doubleValue] * 25.4]];
    
    
    if ([currentBolt.largerOrSmaller isEqualToString:@"L"]) {
        _closestEquivalentDirection.text = @"LARGER";
    } else if ([currentBolt.largerOrSmaller isEqualToString:@"S"]) {
        _closestEquivalentDirection.text = @"SMALLER";
    }
    
    // JSK ADDITION --------------------------------------------------------------------------------------
    
    if ([_softThreadEngagementInMillimeters.text isEqualToString:@"0"]) {
        _softThreadEngagementInMillimeters.text = @"";
    }
    
    if ([_hardThreadEngagementInMillimeters.text isEqualToString:@"0"]) {
        _hardThreadEngagementInMillimeters.text = @"";
    }
    
    // JSK ADDITION --------------------------------------------------------------------------------------
    
    NSString *device = [measurement modelIdentifier];
    if ([device rangeOfString:@"iPhone"].location != NSNotFound) {
        device = @"iPhone";
    } else if ([device rangeOfString:@"iPad2,5"].location != NSNotFound ||
               [device rangeOfString:@"iPad2,6"].location != NSNotFound) {
        device = @"iPadMini";
    } else if ([device rangeOfString:@"iPad"].location != NSNotFound) {
        device = @"iPad";
    } else {
        NSLog(@"%@", [NSString stringWithFormat:@"Couldn't find photo for device type %@, choosing iPhone.", device]);
        device = @"iPhone";
    }
    
    NSString *sizeStringForImage = currentBolt.stringTitle;
    sizeStringForImage = [sizeStringForImage stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    sizeStringForImage = [sizeStringForImage stringByReplacingOccurrencesOfString:@" mm" withString:@""];
    sizeStringForImage = [sizeStringForImage stringByReplacingOccurrencesOfString:@" in" withString:@""];
    
    NSString *imageString;
    
    if ([currentBolt.unitType isEqualToString:@"M"])
        imageString = [NSString stringWithFormat:@"%@_M%@x%@.png", device, sizeStringForImage, [currentBolt.tpi stringValue]];
    else
        imageString = [NSString stringWithFormat:@"%@_%@x%@.png", device, sizeStringForImage, [currentBolt.tpi stringValue]];
    
    
    
    if (_threadViewLeft.image = [UIImage imageNamed:imageString]) {
        _threadViewRight.image = [UIImage imageNamed:imageString];
        
        NSLog(@"%@ found.", imageString);
    } else {
        NSLog(@"%@ not found.", imageString);
    }
    
}

- (IBAction)sizeButtonPushed:(id)sender {
    WBBlankMeasureViewController *sizeBlank = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:@"sizeBlank"];
    
        sizeBlank.sizeOnly = YES;
    
    
    
    switch (((UIButton *)sender).tag) {
        case 1: {
            sizeBlank.drillBitSize = currentBolt.normalFitDecimalEquivalent;
            NSLog(@"Normal fit show size.");
            break;
        } case 2: {
            sizeBlank.drillBitSize = currentBolt.tightFitDecimalEquivalent;
            NSLog(@"Tight fit show size.");
            break;
        } case 3: {
            sizeBlank.drillBitSize = currentBolt.threeQuarterThreadAluminumDrillSizeDecimalEquivalent;
            NSLog(@"Soft fit show size.");
            break;
        } case 4: {
            sizeBlank.drillBitSize = currentBolt.halfThreadSteelDrillSizeDecimalEquivalent;
            NSLog(@"Hard fit show size.");
            break;
        } default:
            break;
    }
    
    [self.navigationController pushViewController:sizeBlank animated:YES];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.scrollView layoutIfNeeded];
    
    self.scrollView.contentSize = CGSizeMake(320, 1552);
    self.scrollView.frame = self.view.frame;
    self.backgroundImage.frame = CGRectMake(0, 0, 320, 1552);
    self.skeletonImage.frame = CGRectMake(21, 71, 278, 1467);
    
    [self fillInDetails];
}

- (IBAction)differentThreadButtonPushed:(id)sender {
    WBAlternateThreadViewController *alternateThreadController = [[WBAlternateThreadViewController alloc] init];
    [alternateThreadController setCurrentBolt:currentBolt];
    [self.navigationController pushViewController:alternateThreadController animated:YES];
    
}

- (UIBarButtonItem *)getSaveButton
{
    UIBarButtonItem *saveItem;
    if (![self boltIsSaved]) {
        saveItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveCurrentBolt)];
    } else {
        saveItem = [[UIBarButtonItem alloc] initWithTitle:@"Unsave" style:UIBarButtonItemStylePlain target:self action:@selector(unsaveCurrentBolt)];
    }
    return saveItem;
}

- (void)viewDidLoad
{
#define WB_LABEL_TITLE_SIZE 30
    
    _threadViewLeft.contentMode = UIViewContentModeScaleAspectFit;
    _threadViewRight.contentMode = UIViewContentModeScaleAspectFit;
    
    _threadViewRight.backgroundColor = [UIColor clearColor];
    _threadViewLeft.backgroundColor = [UIColor clearColor];
    
    [super viewDidLoad];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.scrollView.bounces = NO;
    [_boltTitle setFont:[UIFont fontWithName:@"Rockwell" size:WB_LABEL_TITLE_SIZE]];
}

- (BOOL)boltIsSaved {
    NSMutableArray *savedBolts = [[NSUserDefaults standardUserDefaults] objectForKey:@"savedBolts"];
    
    NSMutableArray *boltToSave = [[NSMutableArray alloc] init];
    //[boltToSave addObject:currentBolt.stringTitle];
    [boltToSave addObject:currentBolt.tapTitle];
    [boltToSave addObject:currentBolt.tpi];
    
    
    // JSK addition ------------------------------------------------
    [boltToSave addObject:currentBolt.unitType];
    
    for (NSArray *a in savedBolts) {
        if ([[a objectAtIndex:0] isEqualToString:[boltToSave objectAtIndex:0]] &&
            [[a objectAtIndex:1] isEqualToNumber:[boltToSave objectAtIndex:1]] ) {
            return YES;
        }
    }
    // -------------------------------------------------------------
    return NO;
}

- (void)unsaveCurrentBolt {
    NSMutableArray *savedBolts = [[NSUserDefaults standardUserDefaults] objectForKey:@"savedBolts"];
    savedBolts = [savedBolts mutableCopy];
    
    NSMutableArray *boltToUnsave = [[NSMutableArray alloc] init];
    //[boltToUnsave addObject:currentBolt.stringTitle];
    [boltToUnsave addObject:currentBolt.tapTitle];
    [boltToUnsave addObject:currentBolt.tpi];
    
    // JSK addition ------------------------------------------------
    // [boltToUnsave addObject:currentBolt.unitType];
    
    for (int i = 0; i < [savedBolts count]; i++) {
        NSMutableArray *a = [[savedBolts objectAtIndex:i] mutableCopy];
        
        if ([[a objectAtIndex:0] isEqualToString:[boltToUnsave objectAtIndex:0]] &&
            [[a objectAtIndex:1] isEqualToNumber:[boltToUnsave objectAtIndex:1]]) {
            [savedBolts removeObjectAtIndex:i];
            [[NSUserDefaults standardUserDefaults] setObject:savedBolts forKey:@"savedBolts"];
        }
    }
    // -------------------------------------------------------------
    if (isProductOfSavedView) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    UIBarButtonItem *saveItem = [self getSaveButton];
    self.navigationItem.rightBarButtonItem = saveItem;
    
}

- (void)saveCurrentBolt {
    NSMutableArray *savedBolts = [[NSUserDefaults standardUserDefaults] objectForKey:@"savedBolts"];
    savedBolts = [savedBolts mutableCopy];
    if (!savedBolts) {
        savedBolts = [[NSMutableArray alloc] init];
    }
    
    NSMutableArray *boltToSave = [[NSMutableArray alloc] init];
    //[boltToSave addObject:currentBolt.stringTitle];
    [boltToSave addObject:currentBolt.tapTitle];
    [boltToSave addObject:currentBolt.tpi];
    
    // JSK addition ------------------------------------------------
    // [boltToSave addObject:currentBolt.unitType];
    // -------------------------------------------------------------
    
    if (![self boltIsSaved]) {
        [savedBolts addObject:boltToSave];
        [[NSUserDefaults standardUserDefaults] setObject:savedBolts forKey:@"savedBolts"];
    }
    
    UIBarButtonItem *saveItem = [self getSaveButton];
    self.navigationItem.rightBarButtonItem = saveItem;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setBolt:(Bolt *)newBolt {
    currentBolt = newBolt;
}


@end