//
//  UpdateHistoryView.m
//  AGiftPaid
//
//  Created by Nelson on 3/31/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import "UpdateHistoryView.h"
#import "GiftHistorySection.h"

@implementation UpdateHistoryView

@synthesize updateButton;
@synthesize owner;


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
    }
    return self;
}

-(IBAction)updateButtonPressed
{
	[owner updateViewSlideOut];
	[owner reloadSourceData];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
	
	[updateButton release];
    [super dealloc];
}


@end
