//
//  BeforeMessageView.m
//  AGiftPaid
//
//  Created by Nelson on 3/23/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import "BeforeMessageView.h"
#import "AGiftPaidAppDelegate.h"

@implementation BeforeMessageView

@synthesize beforeMessageTextView;



- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

-(void)WriteMessage
{
	/*
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	[appDelegate startEditMessage:beforeMessageTextView];
	 */
	
	[beforeMessageTextView becomeFirstResponder];
}

-(void)endWritting
{
	[beforeMessageTextView resignFirstResponder];
}

- (void)dealloc {
	
	[beforeMessageTextView release];
	
    [super dealloc];
}


@end
