//
//  GiftBoxSelectionController.m
//  AGiftPaid
//
//  Created by Nelson on 3/21/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import "GiftBoxSelectionController.h"
#import "AGiftPaidAppDelegate.h"
#import "Viewer3DBoxController.h"
#import "GiftTimeSelectionController.h"
#import "SendGiftSectionViewController.h"
#import "GiftBoxThumbnailImageView.h"


@implementation GiftBoxSelectionController

@synthesize boxGalleryScrollView;
@synthesize scrollviewSouceData;
@synthesize naviTitleView;
@synthesize hintButton;
@synthesize hintController;
@synthesize shouldReload;

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
	
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	self.naviTitleView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iBox.png"]];
	[self.navigationItem setTitleView:self.naviTitleView];
	
	[self setTitle:@"Box"];
	
	self.shouldReload=NO;
	
	//NSOperationQueue *opQueue=[[NSOperationQueue new] autorelease];
	AGiftWebService *service=[[AGiftWebService alloc] initAGiftWebService];
	[service setDelegate:self]; 
	[appDelegate.mainOpQueue addOperation:service];
	[service ReceiveGiftBoxPickerList];
	[service release];
	

	//custom navi right button
	UIImageView *nextButton=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"TimeBla.png"]];
	[nextButton setUserInteractionEnabled:YES];
	UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nextView)];
	[tapGesture setNumberOfTapsRequired:1];
	[nextButton addGestureRecognizer:tapGesture];
	[tapGesture release];
	
	UIBarButtonItem *nextButtonItem=[[UIBarButtonItem alloc] initWithCustomView:nextButton];
	
	[self.navigationItem setRightBarButtonItem:nextButtonItem];
	[nextButtonItem release];
	

	
	[appDelegate refreshTabbarTitle:@"Gift" index:1];
	
	
	
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
	
	self.boxGalleryScrollView=nil;
	self.naviTitleView=nil;
	self.naviTitleView=nil;
	self.hintButton=nil;
	self.hintController=nil;
	
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark IBAction Method
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
	
	if(boxGalleryScrollView.lastSelectedIcon==nil)
	{
		NSString *msg=@"You have to pick at least one gift box in order to send a gift";
		UIAlertView *pickOneAlert=[[UIAlertView alloc] initWithTitle:@"Alert" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[pickOneAlert show];
		[pickOneAlert release];
	}
	else 
	{
		[self assignInfoToPackage];
		
		GiftTimeSelectionController *timeController=[[GiftTimeSelectionController alloc] initWithNibName:@"GiftTimeSelectionController" bundle:nil];
		[self.navigationController pushViewController:timeController animated:YES];
		[timeController release];
	}

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

#pragma mark Method
-(void)nextView
{
	if(boxGalleryScrollView.lastSelectedIcon==nil)
	{
		NSString *msg=@"You have to pick at least one gift box in order to send a gift";
		UIAlertView *pickOneAlert=[[UIAlertView alloc] initWithTitle:@"Alert" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[pickOneAlert show];
		[pickOneAlert release];
	}
	else 
	{
		[self assignInfoToPackage];
		
		[self disableHint];
		
		GiftTimeSelectionController *timeController=[[GiftTimeSelectionController alloc] initWithNibName:@"GiftTimeSelectionController" bundle:nil];
		[self.navigationController pushViewController:timeController animated:YES];
		[timeController release];
	}
}

-(void)assignInfoToPackage
{
	SendGiftSectionViewController *rootNaviController=(SendGiftSectionViewController*)self.navigationController;
	SendGiftInfo *package=rootNaviController.giftInfoPackage;
	
	NSString *boxID=boxGalleryScrollView.lastSelectedIcon.number;
	
	[package setGiftBoxImageUrl:boxGalleryScrollView.lastSelectedIcon.thumbnailImageURL];
	[package setGiftBoxVideoID:boxID];
	[package setGiftBox3DObjID:boxID];
}

-(void)disableHint
{
	[hintController closeButtonPressed];
}

#pragma mark AGiftWebServiceDelegate
-(void)aGiftWebService:(AGiftWebService*)webService ReceiveGiftBoxPickerListArray:(NSArray*)respondData
{
	if(respondData==nil)
	{
		self.shouldReload=YES;
		return;
	}
		
	self.scrollviewSouceData=respondData;
	
	//init scrollview
	[boxGalleryScrollView initialize];
}

#pragma mark GiftBoxGalleryScrollViewDelegate
-(void)GalleryScrollView:(GiftBoxGalleryScrollView*)giftGalleryScrollView didSelectItemWithNumber:(NSString*)number
{
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	//present 3d box viewer
	Viewer3DBoxController *viewerController=[[Viewer3DBoxController alloc] initWithNibName:@"Viewer3DBoxController" bundle:nil];
	[viewerController setBoxNumber:number];
	[appDelegate presentNewController:viewerController animated:YES];
	
	
}

#pragma mark GiftBoxGalleryScrollViewSourceDataDelegate
-(NSUInteger)numberOfItemInContentWithGiftGalleryScrollView:(GiftBoxGalleryScrollView*)giftGalleryScrollView
{
	return [scrollviewSouceData count];
}

-(NSString*)GalleryScrollView:(GiftBoxGalleryScrollView*)giftGalleryScrollView giftImageURLForIndex:(NSUInteger)index
{
	NSDictionary *dic=[scrollviewSouceData objectAtIndex:index];
	
	return [dic valueForKey:@"Uri"];
}

-(NSUInteger)GalleryScrollView:(GiftBoxGalleryScrollView*)giftGalleryScrollView giftBoxIconNumberForIndex:(NSUInteger)index
{
	NSDictionary *dic=[scrollviewSouceData objectAtIndex:index];
	
	NSNumber *number=[dic valueForKey:@"ID"];
	
	return [number integerValue];
}

-(void)viewWillAppear:(BOOL)animated
{
	if(self.shouldReload)
	{
		self.shouldReload=NO;
		[self viewDidLoad];
	}
}

- (void)dealloc {
	
	[boxGalleryScrollView release];
	[naviTitleView release];
	[scrollviewSouceData release];
	[naviTitleView release];
	[hintButton release];
	[hintController release];
	
    [super dealloc];
}


@end
