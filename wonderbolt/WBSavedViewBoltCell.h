//
//  WBSavedViewBoltCell.h
//  wonderbolt
//
//  Created by Peter Kazazes on 6/24/14.
//  Copyright (c) 2014 Josh Koerpel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WBSavedViewBoltCell : UITableViewCell <UITextFieldDelegate> {
    NSArray *savedArray;
}

@property (nonatomic, strong) NSArray *savedArray;
@property (weak, nonatomic) UITableView *tableView;

- (id) initWithArray:(NSArray *)array;

@end
