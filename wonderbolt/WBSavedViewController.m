//
//  WBSecondViewController.m
//  wonderbolt
//
//  Created by Peter Kazazes on 11/9/13.
//  Copyright (c) 2013 Josh Koerpel. All rights reserved.
//

#import "WBSavedViewController.h"
#import "WBDataManager.h"
#import "WBBoltDetailViewController.h"
#import "WBSavedViewBoltCell.h"

@interface WBSavedViewController () {
    NSFetchedResultsController *fetchedResultsController;
}

@end

@implementation WBSavedViewController

@synthesize savedBoltTableView;

- (void)viewDidLoad {
	[super viewDidLoad];
	[self setTitle:@"Saved"];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:15.0f/255.0f green:51.0f/255.0f blue:109.0f/255.0f alpha:1.0f];
	// Do any additional setup after loading the view, typically from a nib.
    
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithTitle:@"Refresh" style:UIBarButtonItemStylePlain target:self action:@selector(refresh:)];
    refreshButton.tintColor = [UIColor whiteColor];
    self.navigationController.navigationItem.rightBarButtonItem = refreshButton;
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    [self.savedBoltTableView addSubview:refreshControl];
    
    static NSString *CellIdentifier = @"savedBoltCell";
    [savedBoltTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
}

- (void)refresh:(UIRefreshControl *)refreshControl {
    [savedBoltTableView reloadData];
    [refreshControl endRefreshing];
}

- (void)viewWillAppear:(BOOL)animated {
    [savedBoltTableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
	NSLog(@"Saved view appeared.");
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

#pragma mark - UITableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [[[NSUserDefaults standardUserDefaults] objectForKey:@"savedBolts"] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *arrayForRow = [[[NSUserDefaults standardUserDefaults] objectForKey:@"savedBolts"] objectAtIndex:indexPath.row];
	
    WBSavedViewBoltCell *cell = [[WBSavedViewBoltCell alloc] initWithArray:arrayForRow];
    cell.tableView = self.savedBoltTableView;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    fetchedResultsController = nil;
    
    NSString *boltName = [[[[NSUserDefaults standardUserDefaults] objectForKey:@"savedBolts"] objectAtIndex:indexPath.row] objectAtIndex:0];
    
    NSNumber *tpi = [[[[NSUserDefaults standardUserDefaults] objectForKey:@"savedBolts"] objectAtIndex:indexPath.row] objectAtIndex:1];
    
    [self fetchObjectsWithName:boltName andTPI:tpi];
    
    Bolt *bolt = [[fetchedResultsController fetchedObjects] objectAtIndex:0];
    
    [self pushDetailOfBolt:bolt];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0f;
}

- (void)pushDetailOfBolt:(Bolt *)bolt {
    WBBoltDetailViewController *detailViewController = [[WBBoltDetailViewController alloc] init];
    [detailViewController setBolt:bolt];
    detailViewController.isProductOfSavedView = YES;
    [self.navigationController pushViewController:detailViewController animated:YES];
}

- (void)fetchObjectsWithName:(NSString *)name andTPI:(NSNumber *)tpi {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Bolt"];
    
	// Configure the request's entity, and optionally its predicate.
	//NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"stringTitle" ascending:YES];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"tapTitle" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[fetchRequest setSortDescriptors:sortDescriptors];
    
    NSPredicate *predicate;
    
    //predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"stringTitle == \"%@\" AND tpi == %@", name, [tpi stringValue]]];
    predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"tapTitle == \"%@\" AND tpi == %@", name, [tpi stringValue]]];
    
    [fetchRequest setPredicate:predicate];
    
    fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[[WBDataManager sharedInstance] managedObjectContext] sectionNameKeyPath:nil cacheName:@"BlankViewCache"];
    
	NSError *error;
	BOOL success = [fetchedResultsController performFetch:&error];
    
	if (!success)
		WBLOG1_INFO(@"Error fetching data.");
    
}

@end
