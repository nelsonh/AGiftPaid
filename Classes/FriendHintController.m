    //
//  FriendHintController.m
//  AGiftPaid
//
//  Created by Nelson on 5/24/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import "FriendHintController.h"


@implementation FriendHintController

@synthesize closeButton;
@synthesize friendIDHintButton;
@synthesize addFriendHintButton;
@synthesize friendDisplayHintButton;
@synthesize removeFriendHintButton;
@synthesize sendGiftHintButton;
@synthesize friendIDHintTextView;
@synthesize addFriendHintTextView;
@synthesize friendDisplayHintTextView;
@synthesize removeFriendHintTextView;
@synthesize sendGiftHintTextView;


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

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

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
	self.friendIDHintButton=nil;
	self.addFriendHintButton=nil;
	self.friendDisplayHintButton=nil;
	self.removeFriendHintButton=nil;
	self.sendGiftHintButton=nil;
	self.friendIDHintTextView=nil;
	self.addFriendHintTextView=nil;
	self.friendDisplayHintTextView=nil;
	self.removeFriendHintTextView=nil;
	self.sendGiftHintTextView=nil;
	
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

-(IBAction)friendIDHintButtonPress
{
	[self reset];
	
	[friendIDHintTextView setHidden:NO];
	[friendIDHintButton setImage:[UIImage imageNamed:@"Question2.png"] forState:UIControlStateNormal];
}

-(IBAction)addFriendHintButtonPress
{
	[self reset];
	
	[addFriendHintTextView setHidden:NO];
	[addFriendHintButton setImage:[UIImage imageNamed:@"Question2.png"] forState:UIControlStateNormal];
}

-(IBAction)friendDisplayHintButtonPress
{
	[self reset];
	
	[friendDisplayHintTextView setHidden:NO];
	[friendDisplayHintButton setImage:[UIImage imageNamed:@"Question2.png"] forState:UIControlStateNormal];
}

-(IBAction)removeFriendHintButtonPress
{
	[self reset];
	
	[removeFriendHintTextView setHidden:NO];
	[removeFriendHintButton setImage:[UIImage imageNamed:@"Question2.png"] forState:UIControlStateNormal];
}

-(IBAction)sendGiftHintButtonPress
{
	[self reset];
	
	[sendGiftHintTextView setHidden:NO];
	[sendGiftHintButton setImage:[UIImage imageNamed:@"Question2.png"] forState:UIControlStateNormal];
}

-(void)reset
{
	[friendIDHintTextView setHidden:YES];
	[addFriendHintTextView setHidden:YES];
	[friendDisplayHintTextView setHidden:YES];
	[removeFriendHintTextView setHidden:YES];
	[sendGiftHintTextView setHidden:YES];
	[friendIDHintButton setImage:[UIImage imageNamed:@"Question.png"] forState:UIControlStateNormal];
	[addFriendHintButton setImage:[UIImage imageNamed:@"Question.png"] forState:UIControlStateNormal];
	[friendDisplayHintButton setImage:[UIImage imageNamed:@"Question.png"] forState:UIControlStateNormal];
	[removeFriendHintButton setImage:[UIImage imageNamed:@"Question.png"] forState:UIControlStateNormal];
	[sendGiftHintButton setImage:[UIImage imageNamed:@"Question.png"] forState:UIControlStateNormal];
}

- (void)dealloc {
	
	[closeButton release];
	[friendIDHintButton release];
	[addFriendHintButton release];
	[friendDisplayHintButton release];
	[removeFriendHintButton release];
	[sendGiftHintButton release];
	[friendIDHintTextView release];
	[addFriendHintTextView release];
	[friendDisplayHintTextView release];
	[removeFriendHintTextView release];
	[sendGiftHintTextView release];
	
    [super dealloc];
}


@end
