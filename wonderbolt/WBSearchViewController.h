//
//  WBChartViewController.h
//  wonderbolt
//
//  Created by Peter Kazazes on 12/25/13.
//  Copyright (c) 2013 Josh Koerpel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface WBSearchViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate> {
	NSFetchedResultsController *fetchedController;
}

- (IBAction)infoButtonPushed:(id)sender;

@end
