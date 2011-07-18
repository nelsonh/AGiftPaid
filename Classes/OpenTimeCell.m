//
//  OpenTimeCell.m
//  AGiftPaid
//
//  Created by Nelson on 5/11/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import "OpenTimeCell.h"


@implementation OpenTimeCell

@synthesize openedDateLabel;
@synthesize openedTimeLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code.
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state.
}


- (void)dealloc {
	
	[openedDateLabel release];
	[openedTimeLabel release];
	
    [super dealloc];
}


@end
