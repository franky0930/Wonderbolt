//
//  WBInfoViewController.m
//  wonderbolt
//
//  Created by Peter Kazazes on 11/9/13.
//  Copyright (c) 2013 Josh Koerpel. All rights reserved.
//

#import "WBMeasureViewController.h"

@interface WBMeasureViewController () {
    
    IBOutlet UIImageView *rulerImageView;
    IBOutlet UIButton *backButton;
    IBOutlet UIButton *metricButton;
    IBOutlet UIButton *standardButton;
    bool standardSelected;
}

@end

@implementation WBMeasureViewController

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	if (self) {
		// Custom initialization
	}
	return self;
}

- (IBAction)buttonPushed:(id)sender {
    if (sender == metricButton) {
        if (standardSelected) {
            rulerImageView.image = [UIImage imageNamed:@"Ruler-metric"];
            metricButton.imageView.image = [UIImage imageNamed:@"Ruler-metric-selected-button"];
            standardButton.imageView.image = [UIImage imageNamed:@"Ruler-standard-button"];
            standardSelected = NO;
        }
    } else if (sender == standardButton) {
        if (!standardSelected) {
            rulerImageView.image = [UIImage imageNamed:@"Standard-ruler"];
            metricButton.imageView.image = [UIImage imageNamed:@"Ruler-metric-button"];
            standardButton.imageView.image = [UIImage imageNamed:@"Ruler-standard-selected-button"];
            standardSelected = YES;
        }
    } else if (sender == backButton) {
        [self setTabBarVisible:YES animated:YES];
        
        [self.tabBarController setSelectedIndex:0];
    }
}



- (void)viewDidLoad {
	[super viewDidLoad];
	// Do any additional setup after loading the view.
    standardSelected = YES;
    [self setNeedsStatusBarAppearanceUpdate];
    metricButton.imageView.image = [UIImage imageNamed:@"Ruler-metric-button"];


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

- (void)viewDidAppear:(BOOL)animated {
        [self setTabBarVisible:NO animated:YES];
	NSLog(@"Info view appeared.");
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
