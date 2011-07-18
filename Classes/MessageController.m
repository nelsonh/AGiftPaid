//
//  MessageController.m
//  AGiftPaid
//
//  Created by Nelson on 3/23/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import "MessageController.h"
#import "AGiftPaidAppDelegate.h"
#import "FriendController.h"
#import "SendGiftSectionViewController.h"

@implementation MessageController

@synthesize anonymousSwitcher;
@synthesize onBoxButton;
@synthesize onGiftButton;
@synthesize beforeMsgView;
@synthesize afterMsgView;
@synthesize naviTitleView;
@synthesize segmentedControl;
@synthesize viewContainer;
@synthesize currentView;
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
	
	
	
	self.naviTitleView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iMessage.png"]];
	[self.navigationItem setTitleView:self.naviTitleView];
	
	[self setTitle:@"Message"];
	
	[afterMsgView setBackgroundColor:[UIColor clearColor]];
	[afterMsgView.afterMessageTextView.layer setCornerRadius:10.0f];
	[afterMsgView.afterMessageTextView.layer setMasksToBounds:YES];
	
	[beforeMsgView setBackgroundColor:[UIColor clearColor]];
	[beforeMsgView.beforeMessageTextView.layer setCornerRadius:10.0f];
	[beforeMsgView.beforeMessageTextView.layer setMasksToBounds:YES];
	
	/*
	UITapGestureRecognizer *tapGestureAfter=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(afterMsgTextViewTapped)];
	[tapGestureAfter setNumberOfTapsRequired:1];
	[afterMsgView.afterMessageTextView addGestureRecognizer:tapGestureAfter];
	[tapGestureAfter release];
	
	UITapGestureRecognizer *tapGestureBefore=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(beforeMsgTextViewTapped)];
	[tapGestureBefore setNumberOfTapsRequired:1];
	[beforeMsgView.beforeMessageTextView addGestureRecognizer:tapGestureBefore];
	[tapGestureBefore release];
	 */
	
	//add a tool bar on top of keyboard
	UIToolbar *keyboardToolBar=[[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
	[keyboardToolBar setTintColor:[UIColor colorWithRed:43.0f/255.0f green:13.0f/255.0f blue:9.0f/255.0f alpha:1.0f]];
	UIBarButtonItem *dismissKeyboardButton=[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(resignKeyBoard)];
	
	NSArray *toolBarItems=[[NSArray alloc] initWithObjects:dismissKeyboardButton, nil];
	[keyboardToolBar setItems:toolBarItems];
	
	[beforeMsgView.beforeMessageTextView setInputAccessoryView:keyboardToolBar];
	[afterMsgView.afterMessageTextView setInputAccessoryView:keyboardToolBar];
	
	[dismissKeyboardButton release];
	[toolBarItems release];
	[keyboardToolBar release];
	
	[afterMsgView setHidden:YES];
	//[beforeMsgView setHidden:YES];
	
	//custom navi right button
	UIImageView *nextButton=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"FriendBla.png"]];
	[nextButton setUserInteractionEnabled:YES];
	UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nextView)];
	[tapGesture setNumberOfTapsRequired:1];
	[nextButton addGestureRecognizer:tapGesture];
	[tapGesture release];
	
	UIBarButtonItem *nextButtonItem=[[UIBarButtonItem alloc] initWithCustomView:nextButton];
	
	[self.navigationItem setRightBarButtonItem:nextButtonItem];
	[nextButtonItem release];
	
	self.viewContainer=[NSArray arrayWithObjects:beforeMsgView, afterMsgView, nil];
	self.currentView=[viewContainer objectAtIndex:0];

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
	
	self.anonymousSwitcher=nil;
	self.onBoxButton=nil;
	self.onGiftButton=nil;
	self.beforeMsgView=nil;
	self.afterMsgView=nil;
	self.naviTitleView=nil;
	self.segmentedControl=nil;
	self.hintButton=nil;
	self.hintController=nil;
	
	
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark IBAction Method
-(IBAction)onBoxButtonPressed
{
	[self resignKeyBoard];
	
	[afterMsgView setHidden:YES];
	[beforeMsgView setHidden:NO];
	
	[onBoxButton setBackgroundImage:[UIImage imageNamed:@"Press_btn.png"] forState:UIControlStateNormal];
	[onBoxButton setEnabled:NO];
	
	[onGiftButton setBackgroundImage:[UIImage imageNamed:@"Btn.png"] forState:UIControlStateNormal];
	[onGiftButton setEnabled:YES];
	
	[self.view bringSubviewToFront:beforeMsgView];
	
}

-(IBAction)onGiftButtonPressed
{
	[self resignKeyBoard];
	
	[afterMsgView setHidden:NO];
	[beforeMsgView setHidden:YES];
	
	[onGiftButton setBackgroundImage:[UIImage imageNamed:@"Press_btn.png"] forState:UIControlStateNormal];
	[onGiftButton setEnabled:NO];
	
	[onBoxButton setBackgroundImage:[UIImage imageNamed:@"Btn.png"] forState:UIControlStateNormal];
	[onBoxButton setEnabled:YES];
	
	[self.view bringSubviewToFront:afterMsgView];
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
	
	FriendController *friendController=[[FriendController alloc] initWithNibName:@"FriendController" bundle:nil];
	[self.navigationController pushViewController:friendController animated:YES];
	[friendController release];
}

-(IBAction)segmentedControlChanged:(id)sender
{
	UISegmentedControl *controller=sender;
	NSUInteger currentIndex=controller.selectedSegmentIndex;
	
	UIView *selectedView=[viewContainer objectAtIndex:currentIndex];
	
	if(currentIndex==0)
	{
		[selectedView setFrame:CGRectMake(-selectedView.frame.size.width, selectedView.frame.origin.y, selectedView.frame.size.width, selectedView.frame.size.height)];
		[selectedView setHidden:NO];
		
		//anim in
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(slideAnimationDidFinish)];
		[selectedView setFrame:CGRectMake(20, selectedView.frame.origin.y, selectedView.frame.size.width, selectedView.frame.size.height)];
		[UIView commitAnimations];
		
		//anim out
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3];
		[UIView setAnimationDelegate:self];
		[currentView setFrame:CGRectMake(320+currentView.frame.size.width, currentView.frame.origin.y, currentView.frame.size.width, currentView.frame.size.height)];
		[UIView commitAnimations];
		
	}
	else if(currentIndex==1) 
	{
		[selectedView setFrame:CGRectMake(320+selectedView.frame.size.width, selectedView.frame.origin.y, selectedView.frame.size.width, selectedView.frame.size.height)];
		[selectedView setHidden:NO];
		
		//anim in
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(slideAnimationDidFinish)];
		[selectedView setFrame:CGRectMake(20, selectedView.frame.origin.y, selectedView.frame.size.width, selectedView.frame.size.height)];
		[UIView commitAnimations];
		
		//anim out
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3];
		[UIView setAnimationDelegate:self];
		[currentView setFrame:CGRectMake(-currentView.frame.size.width, currentView.frame.origin.y, currentView.frame.size.width, currentView.frame.size.height)];
		[UIView commitAnimations];
	}
	
	[segmentedControl setUserInteractionEnabled:NO];

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

#pragma mark  method
-(void)slideAnimationDidFinish
{
	[currentView setHidden:YES];
	
	NSUInteger currentIndex=segmentedControl.selectedSegmentIndex;
	self.currentView=[viewContainer objectAtIndex:currentIndex];
	
	[segmentedControl setUserInteractionEnabled:YES];
}

-(void)nextView
{
	[self assignInfoToPackage];
	
	[self disableHint];
	
	[self resignKeyBoard];
	
	FriendController *friendController=[[FriendController alloc] initWithNibName:@"FriendController" bundle:nil];
	[self.navigationController pushViewController:friendController animated:YES];
	[friendController release];
}

-(void)resignKeyBoard
{
	[afterMsgView.afterMessageTextView resignFirstResponder];
	[beforeMsgView.beforeMessageTextView resignFirstResponder];
}

-(void)assignInfoToPackage
{
	SendGiftSectionViewController *rootNaviController=(SendGiftSectionViewController*)self.navigationController;
	SendGiftInfo *package=rootNaviController.giftInfoPackage;
	
	NSString *anonymous;
	NSString *beforeMsg=beforeMsgView.beforeMessageTextView.text;
	NSString *afterMsg=afterMsgView.afterMessageTextView.text;
	
	if([anonymousSwitcher isOn])
	{
		anonymous=[NSString stringWithString:@"1"];
	}
	else 
	{
		anonymous=[NSString stringWithString:@"0"];
	}
	
	[package setAnonymous:anonymous];
	[package setBeforeMsg:beforeMsg];
	[package setAfterMsg:afterMsg];

}

-(void)disableHint
{
	[hintController closeButtonPress];
}

-(void)afterMsgTextViewTapped
{
	//[afterMsgView WriteMessage];
	//[self performSelector:@selector(moveViewUpAnim) withObject:nil afterDelay:1];
}

-(void)beforeMsgTextViewTapped
{
	//[beforeMsgView WriteMessage];
	//[self performSelector:@selector(moveViewUpAnim) withObject:nil afterDelay:1];
}

-(void)moveViewUpAnim
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	[self.view setFrame:CGRectMake(self.view.frame.origin.x, -185, self.view.frame.size.width, self.view.frame.size.height)];
	[UIView commitAnimations];
}

-(void)moveViewDownAnim
{
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.2];
	[self.view setFrame:CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height)];
	[UIView commitAnimations];
}

#pragma mark touch
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self resignKeyBoard];
}

#pragma mark UITextViewDelegate
-(void)textViewDidBeginEditing:(UITextView *)textView
{
	[self performSelector:@selector(moveViewUpAnim) withObject:nil afterDelay:0];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
	[textView resignFirstResponder];
	[self performSelector:@selector(moveViewDownAnim) withObject:nil afterDelay:0];
}


- (void)dealloc {
	
	[anonymousSwitcher release];
	[onBoxButton release];
	[onGiftButton release];
	[beforeMsgView release];
	[afterMsgView release];
	[naviTitleView release];
	[segmentedControl release];
	[viewContainer release];
	[hintButton release];
	[hintController release];
	
    [super dealloc];
}


@end
