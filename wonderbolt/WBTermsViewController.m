//
//  WBTermsViewController.m
//  wonderbolt
//
//  Created by Peter Kazazes on 7/12/14.
//  Copyright (c) 2014 Josh Koerpel. All rights reserved.
//

#import "WBTermsViewController.h"

@interface WBTermsViewController ()

@end

@implementation WBTermsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIAlertView *explaination = [[UIAlertView alloc] initWithTitle:@"The legal stuff:" message:@"Hey there fellow DIY'er!  Smart move choosing Wonderbolt for your projects!  Let's get some quick legal nuts and bolts out of the way with our terms and conditions.  Our lawyers want us to remind you that Wonderbolt just measures SIZE.  It in no way validates if your fastener is right for the job!" delegate:nil cancelButtonTitle:@"OK!" otherButtonTitles:nil, nil];
    [explaination show];
    
}

- (IBAction)declinePushed:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Terms and Conditions" message:@"You'll need to agree to the terms and conditions to use the app." delegate:nil cancelButtonTitle:@"Read Terms and Conditions" otherButtonTitles:nil];
    [alert show];
}

- (IBAction)acceptPushed:(id)sender {
    WB_USER_SET_B(@"hasAgreedToTerms", YES, YES);
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
