//
// WBFirstViewController.h
// wonderbolt
//
// Created by Peter Kazazes on 11/9/13.
// Copyright (c) 2013 Josh Koerpel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KASlideShow.h"

@interface WBHomeViewController : UIViewController <KASlideShowDelegate> {
    IBOutlet UINavigationController *navController;
    IBOutlet UIView *homeControl;
}

@property (nonatomic) UINavigationController *navController;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

- (void) kaSlideShowDidNext:(KASlideShow *) slideShow;
- (void) showTutorial;

@end