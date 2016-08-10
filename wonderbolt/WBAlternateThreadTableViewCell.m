//
//  WBAlternateThreadTableViewCell.m
//  wonderbolt
//
//  Created by Peter Kazazes on 3/23/14.
//  Copyright (c) 2014 Josh Koerpel. All rights reserved.
//

#import "WBAlternateThreadTableViewCell.h"

@implementation WBAlternateThreadTableViewCell

@synthesize threadTypeLabel;
@synthesize boltOfRow;
@synthesize threadImageRight, threadImageLeft;

- (void)awakeFromNib
{
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    


}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
