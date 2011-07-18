//
//  MessageCell.m
//  AGiftPaid
//
//  Created by Nelson on 5/11/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import "MessageCell.h"


@implementation MessageCell

@synthesize onGiftBoxLabel;
@synthesize onGiftLabel;


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
	
	[onGiftBoxLabel release];
	[onGiftLabel release];
	
    [super dealloc];
}


@end
