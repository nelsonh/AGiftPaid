//
//  GiftSelectionController.m
//  AGiftPaid
//
//  Created by Nelson on 3/22/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import "GiftSelectionController.h"
#import "GiftInfo.h"
#import "Viewer3DGiftController.h"
#import "AGiftPaidAppDelegate.h"
#import "PhotoSelectionController.h"
#import "SendGiftSectionViewController.h"

@implementation GiftSelectionController

@synthesize giftGalleryScrollView;
@synthesize categoryMenu;
@synthesize categorySelectedButton;
@synthesize confirmButton;
@synthesize scrollviewSouceData;
@synthesize currentCategory;
@synthesize naviTitleView;
@synthesize tempService;
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
	
	self.naviTitleView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iGift.png"]];
	[self.navigationItem setTitleView:self.naviTitleView];
	
	[self setTitle:@"Gift"];
	
	self.currentCategory=0;
	
	//self.scrollviewSouceData=[[NSMutableDictionary alloc] init];
	self.scrollviewSouceData=[[NSMutableArray alloc] init];
	
	categoryMenuPresentXPos=categoryMenu.frame.origin.x;
	
	[categorySelectedButton setUserInteractionEnabled:NO];
	
	self.shouldReload=NO;
	
	
	//NSOperationQueue *opQueue=[[NSOperationQueue new] autorelease];
	AGiftWebService *service=[[AGiftWebService alloc] initAGiftWebService];
	[service setDelegate:self];
	[appDelegate.mainOpQueue addOperation:service];
	[service ReceiveGiftPickerList];
	tempService=service;
	[service release];
	
	//custom navi right button
	UIImageView *nextButton=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PhotoBla.png"]];
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
	
	self.giftGalleryScrollView=nil;
	self.categoryMenu=nil;
	self.categorySelectedButton=nil;
	self.confirmButton=nil;
	self.naviTitleView=nil;
	self.hintButton=nil;
	self.hintController=nil;
	
	if(tempService)
	{
		tempService.delegate=nil;
	}
	
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark  IBAction Method
-(IBAction)categorySelectedButtonPressed
{
	//bring up category menu
	[self.view bringSubviewToFront:categoryMenu];
	[self.categoryMenu setHidden:NO];
	
	[categoryMenu setFrame:CGRectMake(CategoryMenuStartX, categoryMenu.frame.origin.y, categoryMenu.frame.size.width, categoryMenu.frame.size.height)];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	[categoryMenu setFrame:CGRectMake(categoryMenuPresentXPos, categoryMenu.frame.origin.y, categoryMenu.frame.size.width, categoryMenu.frame.size.height)];
	[UIView commitAnimations];
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
	
	if(giftGalleryScrollView.lastSelectedIcon==nil)
	{
		NSString *msg=@"You have to pick at least one gift in order to send a gift";
		UIAlertView *pickOneAlert=[[UIAlertView alloc] initWithTitle:@"Alert" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[pickOneAlert show];
		[pickOneAlert release];
	}
	else 
	{
		[self assignInfoToPackage];
		
		PhotoSelectionController *photoController=[[PhotoSelectionController alloc] initWithNibName:@"PhotoSelectionController" bundle:nil];
		[self.navigationController pushViewController:photoController animated:YES];
		[photoController release];
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
	if(giftGalleryScrollView.lastSelectedIcon==nil)
	{
		NSString *msg=@"You have to pick at least one gift in order to send a gift";
		UIAlertView *pickOneAlert=[[UIAlertView alloc] initWithTitle:@"Alert" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[pickOneAlert show];
		[pickOneAlert release];
	}
	else 
	{
		[self assignInfoToPackage];
		
		[self disableHint];
		
		PhotoSelectionController *photoController=[[PhotoSelectionController alloc] initWithNibName:@"PhotoSelectionController" bundle:nil];
		[self.navigationController pushViewController:photoController animated:YES];
		[photoController release];
	}
}

-(void)changeCategoryWithIndex:(NSUInteger)index
{
	
	/*
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationDidStopSelector:@selector(categoryMenuAnimationDidStop)];
	[categoryMenu setFrame:CGRectMake(CategoryMenuEndX, categoryMenu.frame.origin.y, categoryMenu.frame.size.width, categoryMenu.frame.size.height)];
	[UIView commitAnimations];
	
	if(self.currentCategory!=index)
	{
		//change current category
		self.currentCategory=index;
		
		//button text
		NSArray *allCategory=[scrollviewSouceData allKeys];
		NSString *categoryName=[allCategory objectAtIndex:self.currentCategory];
		[categorySelectedButton setTitle:categoryName forState:UIControlStateNormal];
		
		//reset giftgalleryscrollview
		[giftGalleryScrollView reset];
	}
	 */

}

-(void)categoryMenuAnimationDidStop
{
	[self.categoryMenu setHidden:YES];
}

-(void)assignInfoToPackage
{
	SendGiftSectionViewController *rootNaviController=(SendGiftSectionViewController*)self.navigationController;
	SendGiftInfo *package=rootNaviController.giftInfoPackage;
	
	NSString *giftID=giftGalleryScrollView.lastSelectedIcon.number;
	
	GiftInfo *giftInfo=[scrollviewSouceData objectAtIndex:giftGalleryScrollView.lastSelectedIcon.index];
	NSString *giftImageUrl=giftInfo.thumbnailImageURL;
	
	[package setGiftImageUrl:giftImageUrl];
	[package setGiftVideoID:giftID];
	[package setGift3DObjID:giftID];
}

-(void)disableHint
{
	[hintController closeButtonPress];
}

-(void)backToRoot
{
	SendGiftSectionViewController *rootNaviController=(SendGiftSectionViewController*)self.navigationController;
	
	//tell rool navi controller to reset
	[rootNaviController reset];
}

#pragma mark AGiftWebServiceDelegate
-(void)aGiftWebService:(AGiftWebService*)webService ReceiveGiftPickerListArray:(NSArray*)respondData
{
	/*
	for(int i=0; i<[respondData count]; i++)
	{
		NSDictionary *dic=[respondData objectAtIndex:i];
		NSNumber *giftID=[dic valueForKey:@"ID"];
		NSString *giftIconURL=[dic valueForKey:@"Uri"];
		NSString *group=[dic valueForKey:@"Group"];
		
		//check category is existed
		if([scrollviewSouceData objectForKey:group])
		{
			//category existed
			GiftInfo *newGiftInfo=[[GiftInfo alloc] init];
			NSMutableArray *giftInfoList=[scrollviewSouceData objectForKey:group];
			
			[newGiftInfo assignNumber:[giftID integerValue]];
			[newGiftInfo setThumbnailImageURL:giftIconURL];
			[newGiftInfo.giftIconPresenter setOwner:self.giftGalleryScrollView];
			
			[giftInfoList addObject:newGiftInfo];
			
			[newGiftInfo release];
		}
		else 
		{
			//category not existed
			GiftInfo *newGiftInfo=[[GiftInfo alloc] init];
			NSMutableArray *giftInfoList=[[NSMutableArray alloc] init];
			
			[newGiftInfo assignNumber:[giftID integerValue]];
			[newGiftInfo setThumbnailImageURL:giftIconURL];
			[newGiftInfo.giftIconPresenter setOwner:self.giftGalleryScrollView];
			
			[giftInfoList addObject:newGiftInfo];
			
			[scrollviewSouceData setValue:giftInfoList forKey:group];
			
			[newGiftInfo release];
			[giftInfoList release];
		}

	}
	 */
	
	if(respondData==nil)
	{
		self.shouldReload=YES;
		return;
	}
	
	for(int i=0; i<[respondData count]; i++)
	{
		NSDictionary *dic=[respondData objectAtIndex:i];
		NSNumber *giftID=[dic valueForKey:@"ID"];
		NSString *giftIconURL=[dic valueForKey:@"Uri"];
		
		GiftInfo *newGiftInfo=[[[GiftInfo alloc] init] autorelease];
		
		[newGiftInfo assignNumber:[giftID integerValue]];
		[newGiftInfo setThumbnailImageURL:giftIconURL];
		[newGiftInfo.giftIconPresenter setOwner:self.giftGalleryScrollView];
		
		[scrollviewSouceData addObject:newGiftInfo];
		
	}
	
	//NSArray *allCategory=[scrollviewSouceData allKeys];
	//NSString *categoryName=[allCategory objectAtIndex:self.currentCategory];
	//[categorySelectedButton setTitle:categoryName forState:UIControlStateNormal];
	
	//[categoryMenu initialize];
	[giftGalleryScrollView initialize];
	
	//[categorySelectedButton setUserInteractionEnabled:YES];
	
	self.tempService=nil;
}

#pragma mark GiftGalleryScrollView delegate
-(void)GalleryScrollView:(GiftGalleryScrollView*)giftGalleryScrollView didSelectItemWithNumber:(NSString*)number
{
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	//present gift 3d  viewer
	Viewer3DGiftController *viewerController=[[Viewer3DGiftController alloc] initWithNibName:@"Viewer3DGiftController" bundle:nil];
	[viewerController setGiftNumber:number];
	[appDelegate presentNewController:viewerController animated:YES];
}

#pragma mark GiftGalleryScrollView source delegate
-(NSUInteger)numberOfItemInContentWithGiftGalleryScrollView:(GiftGalleryScrollView*)giftGalleryScrollView
{
	/*
	NSArray *allCategory=[scrollviewSouceData allKeys];
	NSString *categoryKey=[allCategory objectAtIndex:self.currentCategory];
	NSArray *giftIconList=[scrollviewSouceData valueForKey:categoryKey];
	
	return [giftIconList count];
	 */
	
	return [scrollviewSouceData count];
}

-(GiftThumbnailImageView*)GalleryScrollView:(GiftGalleryScrollView*)giftGalleryScrollView giftIconViewForIndex:(NSUInteger)index;
{
	/*
	NSArray *allCategory=[scrollviewSouceData allKeys];
	NSString *categoryKey=[allCategory objectAtIndex:self.currentCategory];
	NSArray *giftIconList=[scrollviewSouceData valueForKey:categoryKey];
	
	GiftInfo *giftInfo=[giftIconList objectAtIndex:index];
	
	[giftInfo loadImage];
	
	return giftInfo.giftIconPresenter;
	 */
	
	GiftInfo *giftInfo=[scrollviewSouceData objectAtIndex:index];
	[giftInfo loadImage];
	
	return giftInfo.giftIconPresenter;
}

#pragma mark MENU CategoryScrollViewDelegate
-(void)CategoryScrollView:(CategoryMenuView*)categoryGalleryScrollView didSelectItemWithNumber:(NSString*)number
{
	
}

#pragma mark MENU CategoryScrollViewSourceDataDelegate
-(NSUInteger)numberOfItemInContentWithCategoryScrollView:(CategoryMenuView*)categoryGalleryScrollView
{
	/*
	NSArray *numberOfCategory=[scrollviewSouceData allKeys];
	
	return [numberOfCategory count];
	 */
	
	return 0;
}

-(NSString*)CategoryScrollView:(CategoryMenuView*)categoryGalleryScrollView categoryNameForIndex:(NSUInteger)index
{
	/*
	NSArray *numberOfCategory=[scrollviewSouceData allKeys];
	
	return [numberOfCategory objectAtIndex:index];
	 */
	
	return @"";
}

-(void)viewWillAppear:(BOOL)animated
{
	if(shouldReload)
	{
		[self viewDidLoad];
		self.shouldReload=NO;
	}
}

- (void)dealloc {
	
	[giftGalleryScrollView release];
	[categoryMenu release];
	[categorySelectedButton release];
	[confirmButton release];
	[scrollviewSouceData release];
	[naviTitleView release];
	[hintButton release];
	[hintController release];
	
    [super dealloc];
}


@end
