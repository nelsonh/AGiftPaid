    //
//  GiftViewerHintController.m
//  AGiftPaid
//
//  Created by Nelson on 5/26/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import "GiftViewerHintController.h"


@implementation GiftViewerHintController

@synthesize closeButton;
@synthesize gestureHintButton;
@synthesize gestureHintTextView;
@synthesize zoomInOutImageView;
@synthesize panImageView;
@synthesize previewVideoButton;
@synthesize previewVideoTextView;

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
	self.gestureHintButton=nil;
	self.gestureHintTextView=nil;
	self.zoomInOutImageView=nil;
	self.panImageView=nil;
	self.previewVideoButton=nil;
	self.previewVideoTextView=nil;
	
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

-(IBAction)gestureHintButtonPress
{
	[self reset];
	
	[gestureHintTextView setHidden:NO];
	[zoomInOutImageView setHidden:NO];
	[panImageView setHidden:NO];
	[gestureHintButton setImage:[UIImage imageNamed:@"Question2.png"] forState:UIControlStateNormal];
}

-(IBAction)previewVideoButtonPress
{
	[self reset];
	
	[previewVideoTextView setHidden:NO];
	[previewVideoButton setImage:[UIImage imageNamed:@"Question2.png"] forState:UIControlStateNormal];
}

-(void)reset
{
	[gestureHintTextView setHidden:YES];
	[zoomInOutImageView setHidden:YES];
	[panImageView setHidden:YES];
	[previewVideoTextView setHidden:YES];
	[gestureHintButton setImage:[UIImage imageNamed:@"Question.png"] forState:UIControlStateNormal];
	[previewVideoButton setImage:[UIImage imageNamed:@"Question.png"] forState:UIControlStateNormal];
}


- (void)dealloc {
	
	[closeButton release];
	[gestureHintButton release];
	[gestureHintTextView release];
	[zoomInOutImageView release];
	[panImageView release];
	[previewVideoButton release];
	[previewVideoTextView release];
	
    [super dealloc];
}


@end
