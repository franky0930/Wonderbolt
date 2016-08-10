//
//  WBSavedViewBoltCell.m
//  wonderbolt
//
//  Created by Peter Kazazes on 6/24/14.
//  Copyright (c) 2014 Josh Koerpel. All rights reserved.
//

#import "WBSavedViewBoltCell.h"

@implementation WBSavedViewBoltCell {
    IBOutlet UILabel *boltTPILabel;
    IBOutlet UILabel *boltNameLabel;
    IBOutlet UIButton *noteButton;
    // JSK addition -----------------------------------------------
    // IBOutlet UILabel *boltTypeLabel;
    // ------------------------------------------------------------
}

@synthesize savedArray;

- (id) initWithArray:(NSArray *)array {
    // Load the top-level objects from the custom cell XIB.
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"WBSavedViewBoltCell" owner:self options:nil];
    // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).
    self = [topLevelObjects objectAtIndex:0];
    
    if (self) {
        self.savedArray = array;
        noteButton = [[UIButton alloc] initWithFrame:CGRectMake(282, 7, 30, 40)];
        [noteButton addTarget:self action:@selector(noteButtonPushed:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:noteButton];
        [self setupRow];
    }
    
    return self;
}

- (void)setupRow {
    [boltNameLabel setText:[savedArray objectAtIndex:0]];
    
    // JSK addition ------------------------------------------------------
    // [boltTPILabel setText:[savedArray objectAtIndex:2]];
    // NSString *type = [NSString stringWithFormat:@"%@" , [[savedArray objectAtIndex:2] stringValue]];
    
    if ([[savedArray objectAtIndex:0] rangeOfString:@"M"].location != NSNotFound) {
    
        [boltTPILabel setText:[NSString stringWithFormat:@"%@ Pitch" , [[savedArray objectAtIndex:1] stringValue]]];
    } else {
        [boltTPILabel setText:[NSString stringWithFormat:@"%@ TPI" , [[savedArray objectAtIndex:1] stringValue]]];
    }
    // --------------------------------------------------------------------
    if ([savedArray count] == 3) {
        UIImage *noteImage = [UIImage imageNamed:@"noteSaved"];
        [noteButton setImage:noteImage forState:UIControlStateNormal];
    } else {
        UIImage *noNoteImage = [UIImage imageNamed:@"noNote"];
        [noteButton setImage:noNoteImage forState:UIControlStateNormal];
    }
}

- (IBAction)noteButtonPushed:(id)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@ Notes", [savedArray objectAtIndex:0]] message:nil delegate:self cancelButtonTitle:@"Save" otherButtonTitles:nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    
    if ([savedArray count] == 3) {
        [[alert textFieldAtIndex:0] setText:[savedArray objectAtIndex:2]];
    }
    
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSMutableArray *defaultsArray = [WB_USER_GET(@"savedBolts") mutableCopy];
    NSMutableArray *newInsertion = [savedArray mutableCopy];
    
    if ([[[alertView textFieldAtIndex:0] text] length] > 0) {
        if ([newInsertion count] == 3)
            [newInsertion replaceObjectAtIndex:2 withObject:[[alertView textFieldAtIndex:0] text]];
        else
            [newInsertion insertObject:[[alertView textFieldAtIndex:0] text] atIndex:2];
    } else {
        //[newInsertion removeObjectAtIndex:2];
        if ([newInsertion count] > 2) {
             [newInsertion removeObjectAtIndex:2];
            }
    }
    
    [defaultsArray replaceObjectAtIndex:[[self.tableView indexPathForCell: self] row] withObject:newInsertion];
    WB_USER_SET(@"savedBolts", defaultsArray, YES);
    
    [self.tableView reloadData];
}

@end