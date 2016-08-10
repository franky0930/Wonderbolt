//
// WBSettingsViewController.m
// wonderbolt
//
// Created by Peter Kazazes on 11/9/13.
// Copyright (c) 2013 Josh Koerpel. All rights reserved.
//

#import "WBAppInfoViewController.h"
#import "WBAppDelegate.h"
#import "WBHomeViewController.h"

@interface WBAppInfoViewController ()

@end

@implementation WBAppInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)buttonPushed:(id)sender {
    UIButton *button = (UIButton *)sender;
    if (button.tag == 0) {
        //TODO: get AppID from ITC
        // #define YOUR_APP_STORE_ID 873989562 //Change this one to your ID
        
        static NSString *const iOS7AppStoreURLFormat = @"itms-apps://itunes.apple.com/app/id%d";
        static NSString *const iOSAppStoreURLFormat = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%d";
        
        NSString* url = [NSString stringWithFormat:([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f)? iOS7AppStoreURLFormat: iOSAppStoreURLFormat, WB_APP_ITUNES_ID];
        
        [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
        // NSLog(@"Url is %@",url);
    } else if (button.tag == 1) {
        WB_USER_SET_B(@"shownTutorial", NO, YES);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tabBarController setSelectedIndex:0];
            [(UINavigationController *)[self.tabBarController selectedViewController] popToRootViewControllerAnimated:YES];
            [(WBHomeViewController *)[[((UINavigationController *)[self.tabBarController selectedViewController]) viewControllers] objectAtIndex:0] showTutorial];
            [self setTabBarVisible:NO animated:YES];
        });
    } else if (button.tag == 2) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://bryteworkapps.com/wonderbolt-terms-and-conditions/"]];
    } else if (button.tag == 3) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.bryteworkapps.com"]];
        //NSLog(@"Button Pressed!");

    }
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

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"Settings view appeared.");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end