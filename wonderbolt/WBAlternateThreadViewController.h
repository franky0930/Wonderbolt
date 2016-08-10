//
//  WBAlternateThreadViewController.h
//  wonderbolt
//
//  Created by Peter Kazazes on 3/23/14.
//  Copyright (c) 2014 Josh Koerpel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bolt.h"

@interface WBAlternateThreadViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    Bolt *currentBolt;
    IBOutlet UITableView *alternateBoltTableView;
    
    IBOutlet UIImageView *metricImage;
    IBOutlet UILabel *boltTitle;
    IBOutlet UIImageView *standardImage;
}

@property (nonatomic, strong) Bolt *currentBolt;

@end
