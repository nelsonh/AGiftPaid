    //
//  PhotoSelectionHintController.m
//  AGiftPaid
//
//  Created by Nelson on 5/24/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import "PhotoSelectionHintController.h"


@implementation PhotoSelectionHintController

@synthesize closeButton;
@synthesize photoCameraHintButton;
@synthesize photoLibraryHintButton;
@synthesize photoCameraHintTextView;
@synthesize photoLibraryHintTextView;
@synthesize photoExpHintButton;
@synthesize photoExpHintTextView;

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
	self.photoCameraHintButton=nil;
	self.photoLibraryHintButton=nil;
	self.photoCameraHintTextView=nil;
	self.photoLibraryHintTextView=nil;
	self.photoExpHintButton=nil;
	self.photoExpHintTextView=nil;
	
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

-(IBAction)photoCameraHintButtonPress
{
	[self reset];
	
	[photoCameraHintTextView setHidden:NO];
	[photoCameraHintButton setImage:[UIImage imageNamed:@"Question2.png"] forState:UIControlStateNormal];
}

-(IBAction)photoLibraryHintButtonPress
{
	[self reset];
	
	[photoLibraryHintTextView setHidden:NO];
	[photoLibraryHintButton setImage:[UIImage imageNamed:@"Question2.png"] forState:UIControlStateNormal];
}

-(IBAction)photoExpHintButtonPress
{
	[self reset];
	
	[photoExpHintTextView setHidden:NO];
	[photoExpHintButton setImage:[UIImage imageNamed:@"Question2.png"] forState:UIControlStateNormal];
}

-(void)reset
{
	[photoCameraHintTextView setHidden:YES];
	[photoLibraryHintTextView setHidden:YES];
	[photoExpHintTextView setHidden:YES];
	[photoCameraHintButton setImage:[UIImage imageNamed:@"Question.png"] forState:UIControlStateNormal];
	[photoLibraryHintButton setImage:[UIImage imageNamed:@"Question.png"] forState:UIControlStateNormal];
	[photoExpHintButton setImage:[UIImage imageNamed:@"Question.png"] forState:UIControlStateNormal];
}


- (void)dealloc {
	
	[closeButton release];
	[photoCameraHintButton release];
	[photoLibraryHintButton release];
	[photoCameraHintTextView release];
	[photoLibraryHintTextView release];
	[photoExpHintButton release];
	[photoExpHintTextView release];
	
	
    [super dealloc];
}


@end
