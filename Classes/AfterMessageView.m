//
//  AfterMessageView.m
//  AGiftPaid
//
//  Created by Nelson on 3/23/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import "AfterMessageView.h"
#import "AGiftPaidAppDelegate.h"

@implementation AfterMessageView

@synthesize afterMessageTextView;


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
	
	[appDelegate startEditMessage:afterMessageTextView];
	 */
	
	[afterMessageTextView becomeFirstResponder];
}

-(void)endWritting
{
	[afterMessageTextView resignFirstResponder];
}

- (void)dealloc {
	
	[afterMessageTextView release];
	
    [super dealloc];
}


@end
