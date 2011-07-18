    //
//  MusicSelectionHintController.m
//  AGiftPaid
//
//  Created by Nelson on 5/24/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import "MusicSelectionHintController.h"


@implementation MusicSelectionHintController

@synthesize closeButton;
@synthesize customSoundHintButton;
@synthesize soundControllerHintButton;
@synthesize buildinSoundHintButton;
@synthesize customSoundHintTextView;
@synthesize soundControllerHintTextView;
@synthesize buildinSoundHintTextView;

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
	self.customSoundHintButton=nil;
	self.soundControllerHintButton=nil;
	self.buildinSoundHintButton=nil;
	self.customSoundHintTextView=nil;
	self.soundControllerHintTextView=nil;
	self.buildinSoundHintTextView=nil;
	
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

-(IBAction)customSoundHintButtonPress
{
	[self reset];
	
	[customSoundHintTextView setHidden:NO];
	[customSoundHintButton setImage:[UIImage imageNamed:@"Question2.png"] forState:UIControlStateNormal];
}

-(IBAction)soundControllerHintButtonPress
{
	[self reset];
	
	[soundControllerHintTextView setHidden:NO];
	[soundControllerHintButton setImage:[UIImage imageNamed:@"Question2.png"] forState:UIControlStateNormal];
}

-(IBAction)buildinSoundHintButtonPress
{
	[self reset];
	
	[buildinSoundHintTextView setHidden:NO];
	[buildinSoundHintButton setImage:[UIImage imageNamed:@"Question2.png"] forState:UIControlStateNormal];
}

-(void)reset
{
	[customSoundHintTextView setHidden:YES];
	[soundControllerHintTextView setHidden:YES];
	[buildinSoundHintTextView setHidden:YES];
	[customSoundHintButton setImage:[UIImage imageNamed:@"Question.png"] forState:UIControlStateNormal];
	[soundControllerHintButton setImage:[UIImage imageNamed:@"Question.png"] forState:UIControlStateNormal];
	[buildinSoundHintButton setImage:[UIImage imageNamed:@"Question.png"] forState:UIControlStateNormal];
}


- (void)dealloc {
	
	[closeButton release];
	[customSoundHintButton release];
	[soundControllerHintButton release];
	[buildinSoundHintButton release];
	[customSoundHintTextView release];
	[soundControllerHintTextView release];
	[buildinSoundHintTextView release];
	
    [super dealloc];
}


@end
