//
//  HistoryTableCell.m
//  AGiftPaid
//
//  Created by Nelson on 3/28/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import "HistoryTableCell.h"


@implementation HistoryTableCell

@synthesize receiverNameLabel;
@synthesize sendDateLabel;
@synthesize giftStatusImageView;
@synthesize canOpenTimeStatusImageView;
@synthesize cancelGiftButton;
@synthesize deleteGiftButton;
@synthesize historyInfo;
@synthesize updatingIndicator;
@synthesize index;


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

- (void)prepareForReuse
{

	[receiverNameLabel setText:@""];
	[sendDateLabel setText:@""];
	[giftStatusImageView setImage:nil];
	[canOpenTimeStatusImageView setImage:nil];
	[cancelGiftButton setHidden:YES];
}

-(IBAction)cancelGiftButtonPressed
{
	[historyInfo cancelGift:index];
}

-(IBAction)deleteGiftButtonPressed
{
	[historyInfo deleteGiftWithCell:self];
}

- (void)dealloc {
	
	[receiverNameLabel release];
	[sendDateLabel release];
	[giftStatusImageView release];
	[canOpenTimeStatusImageView release];
	[cancelGiftButton release];
	[updatingIndicator release];
	[deleteGiftButton release];
	
    [super dealloc];
}


@end
