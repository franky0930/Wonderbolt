//
// WBFirstViewController.m
// wonderbolt
//
// Created by Peter Kazazes on 11/9/13.
// Copyright (c) 2013 Josh Koerpel. All rights reserved.
//

#import "WBHomeViewController.h"
#import "KASlideShow.h"
#import "WBTermsViewController.h"
#import "Appirater.h"

@interface WBHomeViewController () {
    KASlideShow *slideshow;
    UIButton *rightButton;
    UIButton *leftButton;
    UIButton *cancelButton;
    UIImageView *tutbar;
}

@end

@implementation WBHomeViewController

@synthesize navController;

+ (void) initialize{
    
    NSDictionary *defaults = [NSDictionary
                              dictionaryWithObject:[NSNumber numberWithInt:0]
                              forKey:@"AgreedToLeaveFeedbackOrRate"];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
    
    NSDictionary *defaults2 = [NSDictionary
                               dictionaryWithObject:[NSNumber numberWithInt:0]
                               forKey:@"feedbackCount"];
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaults2];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    // JSK Addition ---------------------------
    // [self showTutorial];
    // JSK Addition -----------------------------
    if (!WB_USER_GET_B(@"hasAgreedToTerms")) {
        [self showTerms];
    }
    
    if (!WB_USER_GET_B(@"shownTutorial")) {
        [self showTutorial];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    NSLog(@"Measure view appeared.");

    
// JSK additions --------------------------------------------
    NSInteger feedbackCount = [[NSUserDefaults standardUserDefaults]integerForKey:@"feedbackCount"];
    NSLog(@"Feedback Count:%ld",(long)feedbackCount);
    
    feedbackCount++;
    if (feedbackCount==5) {
        [[NSUserDefaults standardUserDefaults]setInteger:0 forKey:@"feedbackCount"];
        [self feedbackAlert];
    }
    else {
        [[NSUserDefaults standardUserDefaults]setInteger:feedbackCount forKey:@"feedbackCount"];
    }

    
//    if (!WB_USER_GET_B(@"shownTutorial")) {
//        while (WB_USER_GET_B(@"hasAgreedToTerms")) {
//        [self showTutorial];
//        }
//    }
    
}

-(void)feedbackAlert {
    
    if ([[NSUserDefaults standardUserDefaults]boolForKey:@"AgreedToLeaveFeedbackOrRate"]==NO) {
        NSLog(@"Hasn't Agreed Yet");
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Building MORE and swearing LESS??" message:@"If you enjoy using Wonderbolt, would you mind taking a moment to rate it? It won't take more than a minute. Thanks for your support!" delegate:self cancelButtonTitle:@"No, thanks" otherButtonTitles:@"Rate Wonderbolt!",@"I promise to rate it later!", nil];
        [alert show];
    }
    else {
    NSLog(@"Feedback Alert Skipped, HAS agreed or said NO!");
    }
}

-(void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the OK/Cancel buttons
    switch (buttonIndex) {
        case 0:
        {
            NSLog(@"case 0");
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"AgreedToLeaveFeedbackOrRate"];
            break;
        }
        case 1:
        {
            NSLog(@"Case 1");
            [Appirater rateApp];
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"AgreedToLeaveFeedbackOrRate"];
            break;
        }
        case 2:
        {
            NSLog(@"Case 2");
            break;
        }
            
    }
}

// end JSK Additions -------------------------------


- (void)showTerms {
    WBTermsViewController *termsController = [[WBTermsViewController alloc] init];
    
    [self presentViewController:termsController animated:YES completion:nil];
    
//    if (WB_USER_GET_B(@"hasAgreedToTerms")) {
//    [self showTutorial];
//    }
}

- (void)showTutorial {
    
//    if (WB_USER_GET_B(@"hasAgreedToTerms")) {
        
    
//    UIAlertView *tutPopup = [[UIAlertView alloc] initWithTitle:@"Quick Measurement Tututorial" message:@"Wonderbolt just measures SIZE.  It does NOT warrant the fitness of referenced fasteners for any particular application!" delegate:nil cancelButtonTitle:@"OK!" otherButtonTitles:nil, nil];
//    [tutPopup show];
    
    
    [self setTabBarVisible:NO animated:NO];
    tutbar = [[UIImageView alloc] init];
    tutbar.frame = CGRectMake(0, self.view.frame.size.height - 50, 100, 200);
    tutbar.contentMode = UIViewContentModeScaleAspectFit;
    [tutbar setImage:[UIImage imageNamed:@"tut-bar.png"]];
    [tutbar sizeToFit];
    
    leftButton = [[UIButton alloc] initWithFrame:CGRectMake(320 - 90, self.view.frame.size.height - 42, 33, 33)];
    [leftButton setImage:[UIImage imageNamed:@"arrow-left.png"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setTitle:@"" forState:UIControlStateNormal];
    [self.view addSubview:leftButton];
    
    rightButton = [[UIButton alloc] initWithFrame:CGRectMake(320 - 47, self.view.frame.size.height - 42, 33, 33)];
    [rightButton setImage:[UIImage imageNamed:@"arrow-right.png"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setTitle:@"" forState:UIControlStateNormal];
    [self.view addSubview:rightButton];
    
    cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(320 - 150, self.view.frame.size.height - 42, 33, 33)];
    [cancelButton setImage:[UIImage imageNamed:@"arrow-exit.png"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonTouched:) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setTitle:@"" forState:UIControlStateNormal];
    [self.view addSubview:cancelButton];
    
    
    homeControl.hidden = YES;
    slideshow = [[KASlideShow alloc] initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, self.view.frame.size.height - 70)];
    slideshow.delegate = self;
    [slideshow setDelay:100];
    [slideshow setTransitionDuration:.3];
    [slideshow setTransitionType:KASlideShowTransitionSlide];
    [slideshow setImagesContentMode:UIViewContentModeScaleAspectFit];
    for (int i = 1; i <= 8; i++) {
        [slideshow addImage:[UIImage imageNamed:[NSString stringWithFormat:@"tut-%d.png", i]]];
    }
    [self setTabBarVisible:NO animated:NO];
    [self.view addSubview:slideshow];
    [slideshow addGesture:KASlideShowGestureSwipe];
    [slideshow start];
    
    [self.view bringSubviewToFront:slideshow];
    [self.view addSubview:tutbar];
    [self.view bringSubviewToFront:leftButton];
    [self.view bringSubviewToFront:rightButton];
    [self.view bringSubviewToFront:cancelButton];
    
}
// }

- (void)leftButtonTouched:(id)sender {
    if ([slideshow getCurrentIndex] >= 1)
        [slideshow previous];
}

- (void)rightButtonTouched:(id)sender {
       [slideshow next];
    
}

- (void)cancelButtonTouched:(id)sender {
    [tutbar removeFromSuperview];
    [slideshow removeFromSuperview];
    [rightButton removeFromSuperview];
    [leftButton removeFromSuperview];
    [cancelButton removeFromSuperview];
    [self setTabBarVisible:YES animated:YES];
    homeControl.hidden = NO;
    [slideshow stop];
    slideshow = nil;
    
    WB_USER_SET_B(@"shownTutorial", YES, YES);
}

- (void) kaSlideShowWillShowNext:(KASlideShow *) slideShow {
    [self setTabBarVisible:NO animated:NO];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end