//
//  WBChartViewController.m
//  wonderbolt
//
//  Created by Peter Kazazes on 12/25/13.
//  Copyright (c) 2013 Josh Koerpel. All rights reserved.
//

#import "WBSearchViewController.h"
#import "WBAppDelegate.h"
#import "WBDataManager.h"
#import "WBBoltDetailViewController.h"
#import "WBBlankMeasureViewController.h"

@interface WBSearchViewController () {
    NSMutableArray *bolts;
    IBOutlet UIPickerView *pickerView;
}
@end

@implementation WBSearchViewController

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
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (screenSize.height <= 480.0f) {
            [self setTabBarVisible:YES animated:YES];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated {
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (screenSize.height <= 480.0f) {
            [self setTabBarVisible:NO animated:YES];
        }
    }
}

- (void)fetchObjects {
	NSManagedObjectContext *context = [[WBDataManager sharedInstance] managedObjectContext];
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Bolt"];
    
	// Configure the request's entity, and optionally its predicate.
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"stringTitle" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[fetchRequest setSortDescriptors:sortDescriptors];
	//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name >= 0"];
	//    [fetchRequest setPredicate:predicate];
    
	fetchedController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:context sectionNameKeyPath:nil cacheName:@"ChartViewCache"];
    
	NSError *error;
	BOOL success = [fetchedController performFetch:&error];
    
	if (!success)
		NSLog(@"Error fetching data.");
    
    [self removeSimilarBolts];
}

- (void)removeSimilarBolts {
    bolts = [[fetchedController fetchedObjects] mutableCopy];
    
    for (int i = 0; i < [bolts count]; i++) {
        Bolt *a = [bolts objectAtIndex:i];
        for (int j = 0; j < [bolts count]; j++) {
            Bolt *b = [bolts objectAtIndex:j];
            if ([a.stringTitle isEqualToString:b.stringTitle] && ![a.tpi isEqualToNumber:b.tpi]) {
//                NSLog(@"Ref: %@, %@ Removing: %@ %@", a.stringTitle, a.tpi, b.stringTitle, b.tpi);
                [bolts removeObjectAtIndex:j];
                j--;
            }
        }
    }
    
    [pickerView reloadAllComponents];
    [pickerView selectRow:[bolts count] / 2 inComponent:0 animated:YES];
}

- (void)viewDidLoad {

    
    [super viewDidLoad];
    
    CGAffineTransform t;
    CGAffineTransform s;
    CGAffineTransform u;
    
    t = CGAffineTransformMakeTranslation (0, pickerView.bounds.size.height);
    s = CGAffineTransformMakeScale (0.7, 0.7);
    u = CGAffineTransformMakeTranslation (0 ,pickerView.bounds.size.height);
    pickerView.transform = CGAffineTransformConcat (t, CGAffineTransformConcat(s,u));
    
	[self fetchObjects];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

#pragma mark - Picker view data source

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [bolts count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return ((Bolt *)[bolts objectAtIndex:row]).stringTitle;
}

- (IBAction)infoButtonPushed:(id)sender {
    WBBoltDetailViewController *detailView = [[WBBoltDetailViewController alloc] init];
    
    Bolt* bolt = [bolts objectAtIndex:[pickerView selectedRowInComponent:0]];
    
    [detailView setBolt:bolt];
    
    [self.navigationController pushViewController:detailView animated:YES];
}

- (IBAction)sizeButtonPushed:(id)sender {
    Bolt* bolt = [bolts objectAtIndex:[pickerView selectedRowInComponent:0]];
    WBBlankMeasureViewController *sizeBlank = [self.navigationController.storyboard instantiateViewControllerWithIdentifier:@"sizeBlank"];
    sizeBlank.sizeOnly = YES;
    [sizeBlank setBolt:bolt];
    [self.navigationController pushViewController:sizeBlank animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [[fetchedController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if ([[fetchedController sections] count] > 0) {
		id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedController sections] objectAtIndex:section];
		return [sectionInfo numberOfObjects];
	}
	else
		return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"defaultStyle"];
	NSManagedObject *managedObject = [fetchedController objectAtIndexPath:indexPath];
    
	[cell.textLabel setText:[NSString stringWithFormat:@"%@, %@, %@", ((Bolt *)managedObject).stringTitle,
	                         ((Bolt *)managedObject).threadType, ((Bolt *)managedObject).minorDiameterInInches]];
    
	return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if ([[fetchedController sections] count] > 0) {
		id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedController sections] objectAtIndex:section];
		return [sectionInfo name];
	}
	else
		return nil;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
	return [fetchedController sectionIndexTitles];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
	return [fetchedController sectionForSectionIndexTitle:title atIndex:index];
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation
 
 // In a story board-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 
 */

@end
