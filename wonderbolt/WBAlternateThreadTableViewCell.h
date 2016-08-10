//
//  WBAlternateThreadTableViewCell.h
//  wonderbolt
//
//  Created by Peter Kazazes on 3/23/14.
//  Copyright (c) 2014 Josh Koerpel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bolt.h"

@interface WBAlternateThreadTableViewCell : UITableViewCell {
    IBOutlet UIImageView *threadImageLeft;
    IBOutlet UIImageView *threadImageRight;
    
    IBOutlet UILabel *threadTypeLabel;
    
    Bolt *boltOfRow;
}

@property (nonatomic) IBOutlet UIImageView *threadImageLeft;
@property (nonatomic) IBOutlet UIImageView *threadImageRight;
@property (nonatomic) IBOutlet UILabel *threadTypeLabel;
@property (nonatomic) Bolt *boltOfRow;


@end
