//
//  WBBoltDetailViewController.h
//  wonderbolt
//
//  Created by Peter Kazazes on 2/21/14.
//  Copyright (c) 2014 Josh Koerpel. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Bolt.h"

@interface WBBoltDetailViewController : UIViewController {
    Bolt *currentBolt;
    BOOL isProductOfSavedView;
}

@property (nonatomic) Bolt *currentBolt;
@property BOOL isProductOfSavedView;

- (void)setBolt:(Bolt *)bolt;

@end
