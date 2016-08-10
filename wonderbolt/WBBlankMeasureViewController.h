//
// WBBlankMeasureViewController.h
// wonderbolt
//
// Created by Peter Kazazes on 11/13/13.
// Copyright (c) 2013 Josh Koerpel. All rights reserved.
//

#import "PhysicalMeasurement.h"
#import "Bolt.h"

@interface WBBlankMeasureViewController : UIViewController {
    NSNumber *drillBitSize;
    
    IBOutlet UISlider *blankSizeSlider;
    IBOutlet UIView *blankPreviewView;
    IBOutlet UILabel *errorLabel;
    IBOutlet UILabel *inchValue;
    IBOutlet UILabel *centiValue;
    IBOutlet UILabel *pointsValue;
    IBOutlet UILabel *currentBoltTitle;
    IBOutlet UILabel *currentBoltTitleSecondary;
    IBOutlet UILabel *currentBoltTitleTertiary;
    IBOutlet UILabel *standardIdentifier;
    IBOutlet UILabel *metricIdentifier;
    
    IBOutlet UIButton *metricButton;
    IBOutlet UIButton *standardButton;
    IBOutlet UIButton *bothButton;
    
    IBOutlet UIButton *seekButtonRight;
    IBOutlet UIButton *seekButtonLeft;
    
    IBOutlet UITableView *matchedBoltsView;
    NSFetchedResultsController *fetchedResultsController;
    
    PhysicalMeasurement *measurement;
    
    BOOL debugMode;
    BOOL noDataset;
    BOOL sizeOnly;
    
    Bolt *matchedBolt;
    
    NSMutableArray *referenceSet;
}

@property (nonatomic, strong) NSNumber *drillBitSize;

@property (nonatomic) BOOL noDataset;
@property (nonatomic) BOOL sizeOnly;
@property (strong, nonatomic) IBOutlet UILabel *currentBoltTitleTertiary;

@property (nonatomic) IBOutlet UISlider *blankSizeSlider;
@property (nonatomic) IBOutlet UIView *blankPreviewView;
@property (nonatomic) IBOutlet UILabel *errorLabel;
@property (nonatomic) IBOutlet UILabel *inchValue;
@property (nonatomic) IBOutlet UILabel *centiValue;
@property (nonatomic) IBOutlet UILabel *pointsValue;
@property (nonatomic) IBOutlet UILabel *currentBoltTitle;
@property (nonatomic) IBOutlet UILabel *currentBoltTitleSecondary;
@property (nonatomic) IBOutlet UITableView *matchedBoltsView;
@property (nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (nonatomic) IBOutlet UILabel *standardIdentifier;
@property (nonatomic) IBOutlet UILabel *metricIdentifier;

@property (nonatomic) IBOutlet UIButton *metricButton;
@property (nonatomic) IBOutlet UIButton *standardButton;
@property (nonatomic) IBOutlet UIButton *bothButton;

@property (nonatomic) IBOutlet UIButton *seekButtonRight;
@property (nonatomic) IBOutlet UIButton *seekButtonLeft;

@property (nonatomic) Bolt *matchedBolt;
@property (nonatomic) NSMutableArray *referenceSet;

- (IBAction)sliderDidChangeState:(id)sender;
- (IBAction)buttonSelected:(id)sender;
- (IBAction)seekArrowPushed:(id)sender;
- (IBAction)infoPushed:(id)sender;

- (void)setBolt:(Bolt *)bolt;

@end