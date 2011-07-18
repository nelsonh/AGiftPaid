    //
//  HistoryHintController.m
//  AGiftPaid
//
//  Created by Nelson on 5/24/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import "HistoryHintController.h"


@implementation HistoryHintController

@synthesize closeButton;
@synthesize updateHintButton;
@synthesize historyHintButton;
@synthesize updateHintTextView;
@synthesize historyHintTextView;
@synthesize iconExpHintView;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	[iconExpHintView.layer setCornerRadius:3.0f];
	[iconExpHintView.layer setMasksToBounds:YES];

	
    [super viewDidLoad];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
	
	self.closeButton=nil;
	self.updateHintButton=nil;
	self.historyHintButton=nil;
	self.updateHintTextView=nil;
	self.historyHintTextView=nil;
	self.iconExpHintView=nil;
	
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(IBAction)closeButtonPress
{
	[self reset];
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlUp forView:self.view.superview cache:YES];
	[UIView setAnimationDuration:1.0];
	
	[self.view removeFromSuperview];
	
	[UIView commitAnimations];
}

-(IBAction)updateHintButtonPress
{
	[self reset];
	
	[updateHintTextView setHidden:NO];
	[updateHintButton setImage:[UIImage imageNamed:@"Question2.png"] forState:UIControlStateNormal];
}

-(IBAction)historyHintButtonPress
{
	[self reset];
	
	[historyHintTextView setHidden:NO];
	[iconExpHintView setHidden:NO];
	[historyHintButton setImage:[UIImage imageNamed:@"Question2.png"] forState:UIControlStateNormal];
}

-(void)reset
{
	[updateHintTextView setHidden:YES];
	[historyHintTextView setHidden:YES];
	[iconExpHintView setHidden:YES];
	[updateHintButton setImage:[UIImage imageNamed:@"Question.png"] forState:UIControlStateNormal];
	[historyHintButton setImage:[UIImage imageNamed:@"Question.png"] forState:UIControlStateNormal];
}



- (void)dealloc {
	
	[closeButton release];
	[updateHintButton release];
	[historyHintButton release];
	[updateHintTextView release];
	[historyHintTextView release];
	[iconExpHintView release];
	
    [super dealloc];
}


@end
