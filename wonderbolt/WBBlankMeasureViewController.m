//
// WBBlankMeasureViewController.m
// wonderbolt
//
// Created by Peter Kazazes on 11/13/13.
// Copyright (c) 2013 Josh Koerpel. All rights reserved.
//

#import "WBBlankMeasureViewController.h"

#import <UIDevice-Hardware.h>

#import "PhysicalMeasurement.h"
#import "WBDataManager.h"

#import "WBBoltDetailViewController.h"

#define SEEK_DECIMALS 20
#define MODIFIER 163.00000


@interface WBBlankMeasureViewController ()

@end

@implementation WBBlankMeasureViewController

@synthesize blankPreviewView;
@synthesize blankSizeSlider;
@synthesize errorLabel;
@synthesize inchValue, centiValue, pointsValue;
@synthesize matchedBoltsView, fetchedResultsController;
@synthesize standardButton, metricButton, bothButton;
@synthesize seekButtonLeft, seekButtonRight;
@synthesize standardIdentifier, metricIdentifier;
@synthesize currentBoltTitle, currentBoltTitleSecondary, currentBoltTitleTertiary;
@synthesize noDataset;
@synthesize sizeOnly;
@synthesize matchedBolt;
@synthesize referenceSet;
@synthesize drillBitSize;

int matchedIndex;
int devicePPI;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
// a param to describe the state change, and an animated flag
// optionally add a completion block which matches UIView animation
- (void)setTabBarVisible:(BOOL)visible animated:(BOOL)animated {
    
    // bail if the current state matches the desired state
    if ([self tabBarIsVisible] == visible) return;
    
    // get a frame calculation ready
    CGRect frame = self.tabBarController.tabBar.frame;
    CGFloat height = frame.size.height;
    CGFloat offsetY = (visible)? -height : height;
    

    // zero duration means no animation
    CGFloat duration = (animated)? 0.15 : 0.0;
    
    [UIView animateWithDuration:duration animations:^{
        self.tabBarController.tabBar.frame = CGRectOffset(frame, 0, offsetY);
    }];
}

// know the current state
- (BOOL)tabBarIsVisible {
    return self.tabBarController.tabBar.frame.origin.y < CGRectGetMaxY(self.view.frame);
}

- (void)viewWillDisappear:(BOOL)animated {
    [self setTabBarVisible:YES animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    currentBoltTitle.font = [UIFont fontWithName:@"Rockwell" size:30.0f];
    currentBoltTitleSecondary.font = [UIFont fontWithName:@"Rockwell" size:30.0f];
    currentBoltTitleTertiary.font = [UIFont fontWithName:@"Rockwell" size:30.0f];
    
    if (!sizeOnly) {
        blankSizeSlider.minimumTrackTintColor = [UIColor whiteColor];
        blankSizeSlider.maximumTrackTintColor = [UIColor colorWithRed:12/255 green:41/255 blue:86/255 alpha:1];
        currentBoltTitle.text = @"---";
        
        measurement = [[PhysicalMeasurement alloc] init];
        
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            if (screenSize.height <= 480.0f) {
                [self setTabBarVisible:NO animated:YES];
            }
        }
        
        if (noDataset) {
            currentBoltTitleSecondary.text = @"---";
            [self setDisplayToSlider:NO];
        } else {
            standardIdentifier.alpha = 0.25f;
            metricIdentifier.alpha = 0.25f;
            
            [self buttonSelected:standardButton];
            [self loadReferenceSet];
        }
    }
}

- (void)setBolt:(Bolt *)bolt {
    matchedBolt = bolt;
}

- (void)viewDidAppear:(BOOL)animated {
    debugMode = WB_USER_GET_B(@"debug_mode");
    centiValue.hidden = !debugMode;
    inchValue.hidden = !debugMode;
    pointsValue.hidden = !debugMode;
    matchedBoltsView.hidden = !debugMode;
    
    
    if (sizeOnly) {
        
        
        if (drillBitSize) {
            [self setTitle:@"Drill Bit"];
            CGPoint initialCenter = CGPointMake(blankPreviewView.center.x, blankPreviewView.center.y);
            PhysicalMeasurement *measure = [[PhysicalMeasurement alloc] init];
            
            float points = (float)[measure inchesToScreenPoints:[drillBitSize floatValue]];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                blankPreviewView.frame = CGRectMake(
                                                    blankPreviewView.frame.origin.x,
                                                    blankPreviewView.frame.origin.y,
                                                    blankPreviewView.frame.size.width,
                                                    [[[PhysicalMeasurement alloc] init] inchesToScreenPoints:[drillBitSize doubleValue]]);
                blankPreviewView.center = initialCenter;
            });
            
            UIView *circleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, points, points)];
            circleView.layer.cornerRadius = points / 2.0f;
            circleView.backgroundColor = [UIColor colorWithWhite:.35 alpha:.5];
            //[circleView setCenter:CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height * .75f)];
            [circleView setCenter:CGPointMake(self.view.frame.size.width / 2, blankPreviewView.center.y)];
            [self.view addSubview:circleView];
            
            currentBoltTitleSecondary.text = [NSString stringWithFormat:@"%.3f in", [drillBitSize doubleValue]];
            currentBoltTitleTertiary.text = [NSString stringWithFormat:@"%.1f mm", [drillBitSize doubleValue] * 25.4f];
        } else {
            CGPoint initialCenter = CGPointMake(blankPreviewView.center.x, blankPreviewView.center.y);
            dispatch_async(dispatch_get_main_queue(), ^{
                blankPreviewView.frame = CGRectMake(
                                                    blankPreviewView.frame.origin.x,
                                                    blankPreviewView.frame.origin.y,
                                                    blankPreviewView.frame.size.width,
                                                    [[[PhysicalMeasurement alloc] init] inchesToScreenPoints:[matchedBolt.sizeInInches doubleValue]]);
                blankPreviewView.center = initialCenter;
            });
            
            currentBoltTitle.text = matchedBolt.stringTitle;
            
            currentBoltTitleSecondary.text = [NSString stringWithFormat:@"%.3f in", [matchedBolt.sizeInInches doubleValue]];
            currentBoltTitleTertiary.text = [NSString stringWithFormat:@"%.1f mm", [matchedBolt.sizeInMillimeters doubleValue]];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    if (!sizeOnly) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            if (screenSize.height <= 480.0f) {
                
                [self setTabBarVisible:NO animated:YES];
            }
        }
        [self setDisplayToSlider:NO];
    }
}

#pragma mark - Fetched bolts
- (void)loadReferenceSet {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Bolt"];
    
    // Configure the request's entity, and optionally its predicate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sizeInInches" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"objectType == \"B\""]];
    
    [fetchRequest setPredicate:predicate];
    
    fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[[WBDataManager sharedInstance] managedObjectContext] sectionNameKeyPath:nil cacheName:@"BlankViewCache"];
    
    NSError *error;
    BOOL success = [fetchedResultsController performFetch:&error];
    
    if (!success) {
        WBLOG1_INFO(@"Error fetching data.");
    } else {
        referenceSet = [[fetchedResultsController fetchedObjects] mutableCopy];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[fetchedResultsController sections] count];
}

- (IBAction)buttonSelected:(id)sender {
    if (sender == metricButton) {
        [metricButton setAlpha:1];
        [bothButton setAlpha:0.5];
        [standardButton setAlpha:0.5];
    } else if (sender == bothButton) {
        [metricButton setAlpha:0.5];
        [bothButton setAlpha:1];
        [standardButton setAlpha:0.5];
    } else if (sender == standardButton) {
        [metricButton setAlpha:0.5];
        [bothButton setAlpha:0.5];
        [standardButton setAlpha:1];
    }
}

#pragma mark - Seek

- (IBAction)seekArrowPushed:(id)sender {
    if (sender == seekButtonLeft) {
        if (matchedIndex >= [referenceSet count]) {
            matchedIndex = (int)[referenceSet count] - 1;
        }
        Bolt *tempBolt = [referenceSet objectAtIndex:matchedIndex];
        if (bothButton.alpha == 1) {
            while (matchedIndex > 0 && [matchedBolt.stringTitle isEqualToString:tempBolt.stringTitle]) {
                matchedIndex--;
                tempBolt = [referenceSet objectAtIndex:matchedIndex];
            }
        } else if (standardButton.alpha == 1) {
            while (matchedIndex > 0 && ([matchedBolt.stringTitle isEqualToString:tempBolt.stringTitle] || ![tempBolt.unitType isEqualToString:@"S"])) {
                matchedIndex--;
                tempBolt = [referenceSet objectAtIndex:matchedIndex];
            }
        } else if (metricButton.alpha == 1) {
            while (matchedIndex > 0 && ([matchedBolt.stringTitle isEqualToString:tempBolt.stringTitle] || ![tempBolt.unitType isEqualToString:@"M"])) {
                matchedIndex--;
                tempBolt = [referenceSet objectAtIndex:matchedIndex];
            }
        }
    } else if (sender == seekButtonRight) {
        int backup = matchedIndex;
        if (matchedIndex < [referenceSet count] - 2) {
            matchedIndex = [self nextBoltOfDifferentSizeFromIndex:matchedIndex];
            if (standardButton.alpha == 1) {
                while (![((Bolt *)[referenceSet objectAtIndex:matchedIndex]).unitType isEqualToString:@"S"] && matchedIndex < [referenceSet count] - 1)
                    matchedIndex = [self nextBoltOfDifferentSizeFromIndex:matchedIndex];
            } else if (metricButton.alpha == 1) {
                while (![((Bolt *)[referenceSet objectAtIndex:matchedIndex]).unitType isEqualToString:@"M"] && matchedIndex < [referenceSet count] - 1)
                    matchedIndex = [self nextBoltOfDifferentSizeFromIndex:matchedIndex];
            }
            
            if (matchedIndex == [referenceSet count] - 2) {
                matchedIndex = backup;
            }
        }
    }
    
    [self syncBoltToIndex];
    [self setSliderToSizeInInches:[matchedBolt.sizeInInches doubleValue] andOuter:YES];
    [self sliderDidChangeState:sender];
    
}

- (void)syncBoltToIndex {
    NSString *type;
    
    if (bothButton.alpha == 1) {
        type = @"Both";
    } else if (metricButton.alpha == 1) {
        type = @"M";
    } else if (standardButton.alpha == 1) {
        type = @"S";
    }
    
    Bolt *potentialMatch = [referenceSet objectAtIndex:matchedIndex];
    
    
    if (matchedIndex >= 0 && matchedIndex < [referenceSet count] &&
        ([type isEqualToString:@"Both"] || [potentialMatch.unitType isEqualToString:type])) {
        if (abs([self currentHeightInInches] - 1) < .1 || ![potentialMatch.stringTitle isEqualToString:@"1 in"]) {
            [self willChangeValueForKey:@"matchedBolt"];
            matchedBolt = [referenceSet objectAtIndex:matchedIndex];
            [self didChangeValueForKey:@"matchedBolt"];
            
            self.currentBoltTitle.text = matchedBolt.stringTitle;
            if ([matchedBolt.unitType isEqualToString:@"S"]) {
                standardIdentifier.alpha = 1.0f;
                metricIdentifier.alpha = 0.5;
            } else {
                metricIdentifier.alpha = 1.0f;
                standardIdentifier.alpha = 0.2f;
            }
        }
    }
}

- (void)setSliderToSizeInInches:(double)inches andOuter:(BOOL)outter {
    double newValue = [measurement inchesToScreenPoints:inches - [((Bolt *)[referenceSet objectAtIndex:0]).sizeInInches doubleValue]];
    
    newValue = (newValue / MODIFIER);
    if (newValue > 1.0)
        newValue = 1.0;
    
    
    [blankSizeSlider setValue:newValue animated:YES];
    [blankSizeSlider setNeedsDisplay];
    
    // [self setDisplayToSlider:NO];
}

#pragma mark - Info View actions

- (IBAction)infoPushed:(id)sender {
    if (![currentBoltTitle.text isEqualToString:@"---"]) {
        [self pushDetailOfCurrentBolt];
    }
}

- (void)pushDetailOfCurrentBolt {
    if ([matchedBolt.unitType isEqualToString:@"S"] && ![matchedBolt.threadType isEqualToString:@"UNC"]) {
        for (Bolt *a in referenceSet) {
            if ([a.stringTitle isEqualToString:matchedBolt.stringTitle] && [a.threadType isEqualToString:@"UNC"]) {
                matchedBolt = a;
            }
        }
    } else if ([matchedBolt.unitType isEqualToString:@"M"]) {
        for (Bolt *a in referenceSet) {
            if ([a.stringTitle isEqualToString:matchedBolt.stringTitle] && [a.threadType isEqualToString:@"COARSE"]) {
                matchedBolt = a;
            }
        }
    }
    [self pushDetailOfBolt:matchedBolt];
}

- (void)pushDetailOfBolt:(Bolt *)bolt {
    WBBoltDetailViewController *detailViewController = [[WBBoltDetailViewController alloc] init];
    [detailViewController setBolt:bolt];
    [self.navigationController pushViewController:detailViewController animated:YES];
}

#pragma mark - Measurement

- (IBAction)sliderDidChangeState:(id)sender {
    CGPoint initialCenter = CGPointMake(blankPreviewView.center.x, blankPreviewView.center.y);
    
    if (sender == blankSizeSlider) {
        // change the blank view to match the slider value
        dispatch_async(dispatch_get_main_queue(), ^{
            blankPreviewView.frame = CGRectMake(
                                                blankPreviewView.frame.origin.x,
                                                blankPreviewView.frame.origin.y,
                                                blankPreviewView.frame.size.width,
                                                blankSizeSlider.value * MODIFIER + [[[PhysicalMeasurement alloc] init] inchesToScreenPoints:[((Bolt *)[referenceSet objectAtIndex:0]).sizeInInches doubleValue]]);
            // WBLOG1_INFO(@"FRAME: %@", NSStringFromCGRect(blankSizeSlider.frame));
            blankPreviewView.center = initialCenter;
            [self setDisplayToSlider:NO];
        });
    } else if (sender == seekButtonLeft || sender == seekButtonRight) {
        // change the blank view to match the slider value
        dispatch_async(dispatch_get_main_queue(), ^{
            blankPreviewView.frame = CGRectMake(
                                                blankPreviewView.frame.origin.x,
                                                blankPreviewView.frame.origin.y,
                                                blankPreviewView.frame.size.width,
                                                blankSizeSlider.value * MODIFIER + [[[PhysicalMeasurement alloc] init] inchesToScreenPoints:[((Bolt *)[referenceSet objectAtIndex:0]).sizeInInches doubleValue]]);
            // WBLOG1_INFO(@"FRAME: %@", NSStringFromCGRect(blankSizeSlider.frame));
            blankPreviewView.center = initialCenter;
        });
    }
}

- (void)setDisplayToSlider:(BOOL)updateSlider {
    if (!noDataset) {
        int originalIndex = matchedIndex;
        matchedIndex = 0;
        
        double height = [self currentHeightInInches];
        Bolt *leftBolt = [referenceSet objectAtIndex:matchedIndex];
        Bolt *rightBolt = [referenceSet objectAtIndex:[self nextBoltOfDifferentSizeFromIndex:matchedIndex]];
        
        matchedIndex = [self nextBoltOfDifferentSizeFromIndex:matchedIndex];
        if (height < [((Bolt *)[referenceSet objectAtIndex:[self nextBoltOfDifferentSizeFromIndex:0]]).sizeInInches doubleValue]) {
            matchedIndex = 0;
        } else {
            while (!([leftBolt.sizeInInches doubleValue] < height && [rightBolt.sizeInInches doubleValue] > height) && matchedIndex < [referenceSet count] - 1) {
                matchedIndex = [self nextBoltOfDifferentSizeFromIndex:matchedIndex];
                leftBolt = [referenceSet objectAtIndex:matchedIndex - 1];
                rightBolt = [referenceSet objectAtIndex:matchedIndex];
                // NSLog(@"Seeking %f, Current %@, Off by %f (%@, %@)", height, leftBolt.sizeInInches, height - [leftBolt.sizeInInches doubleValue], leftBolt.sizeInInches, rightBolt.sizeInInches);
                // NSLog(@"%@ and %@", [NSString stringWithFormat:@"*%@*", rightBolt.stringTitle], [NSString stringWithFormat:@"*%@*", leftBolt.stringTitle]);
            }
            
            if (abs([leftBolt.sizeInInches floatValue] - height) < abs([rightBolt.sizeInInches floatValue] - height)) {
                matchedIndex--;
            }
        }
        
        Bolt *tentativeMatchedBolt = [referenceSet objectAtIndex:matchedIndex];
        if (ABS([tentativeMatchedBolt.sizeInInches doubleValue] - [self currentHeightInInches]) < .1) {
            [self syncBoltToIndex];
            
            self.currentBoltTitle.text = matchedBolt.stringTitle;
            
            if (updateSlider) {
                [self setSliderToSizeInInches:[matchedBolt.sizeInInches doubleValue] andOuter:YES];
            }
        }
    } else if (noDataset) {
        
        currentBoltTitle.text = [NSString stringWithFormat:@"%.2f in", [self currentHeightInInches]];
        currentBoltTitleSecondary.text = [NSString stringWithFormat:@"%.2f cm", [self currentHeightInCentimeters]];
    }
}

- (int)nextBoltOfDifferentSizeFromIndex:(int)index {
    if (index < [referenceSet count] - 1) {
        Bolt *ref = [referenceSet objectAtIndex:index];
        Bolt *comp = [referenceSet objectAtIndex:index + 1];
        
        while ([ref.stringTitle isEqualToString:comp.stringTitle] && index < [referenceSet count] - 2) {
            index++;
            comp = [referenceSet objectAtIndex:index + 1];
        }
    }
    if (index < [referenceSet count] - 2)
        return index + 1;
    else
        return [referenceSet count] - 1;
    
}

- (CGFloat)getScaleOfScreen:(UIScreen *)screen {
    if ([screen respondsToSelector:@selector(scale)])
        return [screen scale];
    else
        return 1;
}

- (double)currentHeightInInches {
    @try {
        return [measurement pointsToScreenInches:blankPreviewView.frame.size.height];
    }
    @catch (NSException *exception)
    {
        WBLOG1_INFO(@"UNKNOWN DEVICE EXCEPTION %@", [measurement modelIdentifier]);
        blankSizeSlider.enabled = FALSE;
        
        errorLabel.text = WB_UNKNOWN_DEVICE_ERROR_LABEL;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:WB_UNKNOWN_DEVICE_ALERT_TITLE message:WB_UNKNOWN_DEVICE_ALERT_TEXT delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    @finally
    {
        
    }
}

- (NSString *)doubleToString:(double)number {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setMaximumFractionDigits:SEEK_DECIMALS];
    
    return [formatter stringFromNumber:[NSNumber numberWithDouble:number]];
    
}

- (double)currentHeightInCentimeters {
    @try {
        return [measurement pointsToScreenCentimeters:blankPreviewView.frame.size.height];
    }
    @catch (NSException *exception)
    {
        WBLOG1_INFO(@"UNKNOWN DEVICE EXCEPTION %@", [measurement modelIdentifier]);
        blankSizeSlider.enabled = FALSE;
        
        errorLabel.text = WB_UNKNOWN_DEVICE_ERROR_LABEL;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:WB_UNKNOWN_DEVICE_ALERT_TITLE message:WB_UNKNOWN_DEVICE_ALERT_TEXT delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    @finally
    {
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end