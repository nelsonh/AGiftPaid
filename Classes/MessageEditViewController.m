//
//  MessageEditViewController.m
//  AGiftPaid
//
//  Created by Nelson on 5/4/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import "MessageEditViewController.h"
#import "AGiftPaidAppDelegate.h"

@implementation MessageEditViewController

@synthesize DoneButton;
@synthesize editTextView;
@synthesize inputTextView;
@synthesize lastOrientation;
@synthesize borderImageView;

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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	[editTextView setEditable:YES];
	[editTextView.layer setCornerRadius:10.0f];
	[editTextView.layer setMasksToBounds:YES];
	
	[self.view setFrame:CGRectMake(0, 20, 320, 300)];
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
	
	self.DoneButton=nil;
	self.editTextView=nil;
	self.borderImageView=nil;
	
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(IBAction)DoneButtonPressed
{
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	[inputTextView setText:editTextView.text];
	
	[appDelegate doneEditMessage];
}

-(void)deviceDidRotate:(NSNotification*)notification
{
	UIDeviceOrientation orientation=[UIDevice currentDevice].orientation;
	
	if(orientation!=lastOrientation)
	{
		if(orientation==UIDeviceOrientationPortrait)
		{
			[[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
			
			[UIView beginAnimations:nil context:NULL];
			[UIView setAnimationDuration:0.3];
			self.view.transform=CGAffineTransformMakeRotation(0);
			[self.view setFrame:CGRectMake(0, 20, 320, 300)];
			[editTextView setFrame:CGRectMake(editTextView.frame.origin.x, editTextView.frame.origin.y, editTextView.frame.size.width, 171)];
			[borderImageView setFrame:CGRectMake(borderImageView.frame.origin.x, borderImageView.frame.origin.y, borderImageView.frame.size.width, 173)];
			
			
			[editTextView resignFirstResponder];
			[editTextView becomeFirstResponder];
			[UIView commitAnimations];
		}
		else if(orientation==UIDeviceOrientationLandscapeLeft)
		{
			[[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight];
			
			[UIView beginAnimations:nil context:NULL];
			[UIView setAnimationDuration:0.3];
			self.view.transform=CGAffineTransformMakeRotation(3.14159/2);
			[self.view setFrame:CGRectMake(320/2, 0, 320/2, 480)];
			[editTextView setFrame:CGRectMake(editTextView.frame.origin.x, editTextView.frame.origin.y, editTextView.frame.size.width, 84)];
			[borderImageView setFrame:CGRectMake(borderImageView.frame.origin.x, borderImageView.frame.origin.y, borderImageView.frame.size.width, 88)];
			
			
			[editTextView resignFirstResponder];
			[editTextView becomeFirstResponder];
			
			[UIView commitAnimations];
		}
		else if(orientation==UIDeviceOrientationLandscapeRight)
		{
			[[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeLeft];
			
			[UIView beginAnimations:nil context:NULL];
			[UIView setAnimationDuration:0.3];
			self.view.transform=CGAffineTransformMakeRotation(-3.14159/2);
			[self.view setFrame:CGRectMake(0, 0, 320/2, 480)];
			[editTextView setFrame:CGRectMake(editTextView.frame.origin.x, editTextView.frame.origin.y, editTextView.frame.size.width, 84)];
			[borderImageView setFrame:CGRectMake(borderImageView.frame.origin.x, borderImageView.frame.origin.y, borderImageView.frame.size.width, 88)];
			
			[editTextView resignFirstResponder];
			[editTextView becomeFirstResponder];
			[UIView commitAnimations];
		}

		
		if(orientation!=UIDeviceOrientationFaceUp && orientation!=UIDeviceOrientationFaceDown && orientation!=UIDeviceOrientationPortraitUpsideDown && orientation!=UIDeviceOrientationUnknown)
		{
			lastOrientation=orientation;
		}
	}

}

-(void)assignInputTextView:(UITextView*)inTextView
{
	self.inputTextView=inTextView;
	
	[editTextView setText:inputTextView.text];
}

-(void)viewDidAppear:(BOOL)animated
{

}

-(void)viewDidDisappear:(BOOL)animated
{

}


- (void)dealloc {
	
	[DoneButton release];
	[editTextView release];
	[borderImageView release];
	
    [super dealloc];
}


@end
