//
//  WBSecondViewController.h
//  wonderbolt
//
//  Created by Peter Kazazes on 11/9/13.
//  Copyright (c) 2013 Josh Koerpel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WBSavedViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	IBOutlet UITableView *savedBoltTableView;
    
}

@property (nonatomic) IBOutlet UITableView *savedBoltTableView;

@end
