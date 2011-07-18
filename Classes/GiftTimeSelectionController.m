//
//  GiftTimeSelectionController.m
//  AGiftPaid
//
//  Created by Nelson on 3/22/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import "GiftTimeSelectionController.h"
#import "GiftSelectionController.h"
#import "SendGiftSectionViewController.h"

@implementation GiftTimeSelectionController

@synthesize openTimeSwitch;
@synthesize openDatePicker;
@synthesize naviTitleView;
@synthesize hintButton;
@synthesize hintController;

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
	
	self.naviTitleView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iTime.png"]];
	[self.navigationItem setTitleView:self.naviTitleView];
	
	
	[self setTitle:@"Time"];
	
	[openDatePicker setMinimumDate:[NSDate date]];
	[openDatePicker setDate:[NSDate date]];
	
	//custom navi right button
	UIImageView *nextButton=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"GiftBla.png"]];
	[nextButton setUserInteractionEnabled:YES];
	UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nextView)];
	[tapGesture setNumberOfTapsRequired:1];
	[nextButton addGestureRecognizer:tapGesture];
	[tapGesture release];
	
	UIBarButtonItem *nextButtonItem=[[UIBarButtonItem alloc] initWithCustomView:nextButton];
	
	[self.navigationItem setRightBarButtonItem:nextButtonItem];
	[nextButtonItem release];
	
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
	
	self.openTimeSwitch=nil;
	self.openDatePicker=nil;
	self.naviTitleView=nil;
	self.hintButton=nil;
	self.hintController=nil;
	
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark methods
-(void)nextView
{
	[self assignInfoToPackage];
	
	[self disableHint];
	
	GiftSelectionController *giftController=[[GiftSelectionController alloc] initWithNibName:@"GiftSelectionController" bundle:nil];
	[self.navigationController pushViewController:giftController animated:YES];
	[giftController release];
}

-(void)toggleDateTimePicker:(BOOL)onOff
{
	[openDatePicker setHidden:!onOff];
}

-(void)assignInfoToPackage
{
	SendGiftSectionViewController *rootNaviController=(SendGiftSectionViewController*)self.navigationController;
	SendGiftInfo *package=rootNaviController.giftInfoPackage;
	
	if([openTimeSwitch isOn])
	{
		NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"yyyy/MM/dd/HH/mm/ss"];
		[dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
		NSString *openTime=[dateFormatter stringFromDate:[openDatePicker date]];
		
		NSLog(@"%@", [openDatePicker date]);
		
		[package setCanOpenTime:openTime];
	}

}

-(void)disableHint
{
	[hintController closeButtonPress];
}

#pragma mark IBAction methods
-(IBAction)openTimeSwitchChange:(id)sender
{
	UISwitch *timeSwitcher=sender;
	
	[self toggleDateTimePicker:timeSwitcher.on];
}

-(IBAction)confirmButtonPressed:(id)sender
{
	
	UIView *senderView=(UIView*)sender;
	
	//anim effect
	CABasicAnimation *expandAnim=[CABasicAnimation animationWithKeyPath:@"transform"];
	[expandAnim setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	[expandAnim setDuration:0.15];
	[expandAnim setRepeatCount:1];
	[expandAnim setAutoreverses:YES];
	[expandAnim setRemovedOnCompletion:YES];
	[expandAnim setToValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(2.0, 2.0, 1.0)]];
	[senderView.layer addAnimation:expandAnim forKey:nil];
	
	[self assignInfoToPackage];
	
	GiftSelectionController *giftController=[[GiftSelectionController alloc] initWithNibName:@"GiftSelectionController" bundle:nil];
	[self.navigationController pushViewController:giftController animated:YES];
	[giftController release];
}

-(IBAction)hintButtonPress
{
	
	
	if(hintController)
	{
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.view cache:YES];
		[UIView setAnimationDuration:1.0];
		
		[self.view addSubview:hintController.view];
		
		[UIView commitAnimations];
	}
	
}

- (void)dealloc {
	
	[openTimeSwitch release];
	[openDatePicker release];
	[naviTitleView release];
	[hintButton release];
	[hintController release];
	
    [super dealloc];
}


@end
