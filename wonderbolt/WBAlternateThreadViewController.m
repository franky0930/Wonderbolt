//
//  WBAlternateThreadViewController.m
//  wonderbolt
//
//  Created by Peter Kazazes on 3/23/14.
//  Copyright (c) 2014 Josh Koerpel. All rights reserved.
//

#import "WBAlternateThreadViewController.h"
#import "WBDataManager.h"
#import "WBBoltDetailViewController.h"
#import "WBAlternateThreadTableViewCell.h"
#import "PhysicalMeasurement.h"

@interface WBAlternateThreadViewController () {
    NSMutableArray *alternateThreads;
    NSFetchedResultsController *fetchedResultsController;

    int numberOfAlternateThreads;


}
@end

@implementation WBAlternateThreadViewController

@synthesize currentBolt;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    alternateBoltTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    alternateBoltTableView.backgroundColor = [UIColor clearColor];
    numberOfAlternateThreads = 0;
    [super viewDidLoad];
    [boltTitle setFont:[UIFont fontWithName:@"Rockwell" size:30]];
    if ([currentBolt.unitType isEqualToString:@"S"]) {
        metricImage.hidden = YES;
    } else if ([currentBolt.unitType isEqualToString:@"M"]) {
        standardImage.hidden = YES;
    }
    boltTitle.text = currentBolt.stringTitle;
    
    [self getAlternateThreadCounts];
}

- (void)setCurrentBolt:(Bolt *)newBolt {
    currentBolt = newBolt;
}

- (void)getAlternateThreadCounts {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Bolt"];
    
	// Configure the request's entity, and optionally its predicate.
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sizeInInches" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[fetchRequest setSortDescriptors:sortDescriptors];
    
    NSPredicate *predicate;
    
    predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"stringTitle == \"%@\"", currentBolt.stringTitle]];
    
    
    //    WBLOG1_INFO(@"Using predicate: %@", predicate.predicateFormat);
    [fetchRequest setPredicate:predicate];
    
    
    fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[[WBDataManager sharedInstance] managedObjectContext] sectionNameKeyPath:nil cacheName:nil];
    
	NSError *error;
	BOOL success = [fetchedResultsController performFetch:&error];
    
	if (!success)
		WBLOG1_INFO(@"Error fetching data.");
    
    [self updateDisplayedThreads];
}

- (void)updateDisplayedThreads {
    if ([[fetchedResultsController sections] count] > 0) {
		id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:0];
		numberOfAlternateThreads = [sectionInfo numberOfObjects];
	}
    
    [alternateBoltTableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return numberOfAlternateThreads;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WBAlternateThreadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WBAlternateThreadTableViewCell"];
    if (cell == nil) {
        // Load the top-level objects from the custom cell XIB.
        NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"WBAlternateThreadTableViewCell" owner:self options:nil];
        // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
        cell = [topLevelObjects objectAtIndex:0];
    }

    
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:0];
    cell.boltOfRow = ((Bolt *) [[sectionInfo objects] objectAtIndex:indexPath.row]);
    cell.threadTypeLabel.text = cell.boltOfRow.threadType;
    
    PhysicalMeasurement *measurement = [[PhysicalMeasurement alloc] init];
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
    
    NSString *sizeStringForImage = cell.boltOfRow.stringTitle;
    sizeStringForImage = [sizeStringForImage stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    sizeStringForImage = [sizeStringForImage stringByReplacingOccurrencesOfString:@" mm" withString:@""];
    sizeStringForImage = [sizeStringForImage stringByReplacingOccurrencesOfString:@" in" withString:@""];
    
    NSString *imageString;
    
    if ([cell.boltOfRow.unitType isEqualToString:@"M"]) {
        imageString = [NSString stringWithFormat:@"%@_M%@x%@.png", device, sizeStringForImage, [cell.boltOfRow.tpi stringValue]];
    } else {
        imageString = [NSString stringWithFormat:@"%@_%@x%@.png", device, sizeStringForImage, [cell.boltOfRow.tpi stringValue]];
    }
    
    
    if ((cell.threadImageLeft.image = [UIImage imageNamed:imageString])) {
        cell.threadImageRight.image = [UIImage imageNamed:imageString];
        
        NSLog(@"%@ found.", imageString);
    } else {
        NSLog(@"%@ not found.", imageString);
    }
    
    NSLog(@"Alternate thread: %@, %@ TPI", cell.boltOfRow.threadType, [cell.boltOfRow.tpi stringValue]);
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:0];
    Bolt *bolt = ((Bolt *) [[sectionInfo objects] objectAtIndex:indexPath.row]);
    
    WBBoltDetailViewController *detailViewController = [[WBBoltDetailViewController alloc] init];
    [detailViewController setBolt:bolt];
    [self.navigationController pushViewController:detailViewController animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
