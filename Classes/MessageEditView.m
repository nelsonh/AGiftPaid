//
//  MessageEditView.m
//  AGiftPaid
//
//  Created by Nelson on 3/23/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import "MessageEditView.h"
#import "AGiftPaidAppDelegate.h"

@implementation MessageEditView

@synthesize DoneButton;
@synthesize editTextView;
@synthesize inputTextView;

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

-(IBAction)DoneButtonPressed
{
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	[inputTextView setText:editTextView.text];
	
	[appDelegate doneEditMessage];
}

-(void)assignInputTextView:(UITextView*)inTextView
{
	self.inputTextView=inTextView;

	[editTextView setText:inputTextView.text];
}

- (void)dealloc {
	
	[DoneButton release];
	[editTextView release];
	
    [super dealloc];
}


@end
