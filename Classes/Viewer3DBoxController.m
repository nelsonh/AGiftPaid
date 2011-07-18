//
//  Viewer3DBox.m
//  AGiftPaid
//
//  Created by Nelson on 3/22/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import "Viewer3DBoxController.h"
#import "RenderingEngine.h"
#import "NSData+Base64.h"
#import "AGiftPaidAppDelegate.h"




@implementation Viewer3DBoxController

@synthesize openGLESReferenceView;
@synthesize closeButton;
@synthesize downloadingView;
@synthesize load3DView;
@synthesize modelRenderingEngine;
@synthesize boxNumber;
@synthesize giftBoxPrefix;
@synthesize materialName;
@synthesize hintButton;
@synthesize hintController;
@synthesize playVideoButton;
@synthesize videoURL;
@synthesize isDismissed;
@synthesize shouldReleaseEngine;


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
	
	self.giftBoxPrefix=@"GiftBox";
	
	[downloadingView.layer setCornerRadius:10.0f];
	[downloadingView.layer setMasksToBounds:YES];
	
	[load3DView.layer setCornerRadius:10.0f];
	[load3DView.layer setMasksToBounds:YES];
	
	//NSOperationQueue *opQueue=[[NSOperationQueue new] autorelease];
	AGiftWebService *service=[[AGiftWebService alloc] initAGiftWebService];
	[service setDelegate:self];
	[appDelegate.mainOpQueue addOperation:service];
	[service getGiftBoxVideoUrl:boxNumber];
	[service release];
	
	[playVideoButton setHidden:YES];
	
	self.isDismissed=NO;
	self.shouldReleaseEngine=NO;
	
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
	
	self.openGLESReferenceView=nil;
	self.closeButton=nil;
	self.downloadingView=nil;
	self.load3DView=nil;
	self.hintButton=nil;
	self.hintController=nil;
	self.playVideoButton=nil;
	
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark Method
-(void)initRenderingEngine
{
	if(isDismissed==NO)
	{
		NSString *giftBox3D=[giftBoxPrefix stringByAppendingString:boxNumber];
		
		if(modelRenderingEngine==nil)
		{
			RenderingEngine *engine=[[[RenderingEngine alloc] initRenderingEngineWithRenderingFrame:openGLESReferenceView.frame EnableDepthBuffer:YES Controller:self] autorelease];
			self.modelRenderingEngine=engine;
			[engine release];

			[modelRenderingEngine set3DObjectToShowForName:giftBox3D];
			[self.modelRenderingEngine startRender];
		}
		
		[self.load3DView setHidden:YES];
	}

}

-(void)disableHint
{
	[hintController closeButtonPress];
}

#pragma mark IBAction Method
-(IBAction)closeButtonPressed
{
	[self disableHint];
	
	//dismiss viewer
	[self dismissModalViewControllerAnimated:YES];
	
	self.isDismissed=YES;
	self.shouldReleaseEngine=YES;
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

-(IBAction)playVideoButtonPress
{
	if(videoURL)
	{
		NSURL *movieURL=[NSURL URLWithString:self.videoURL];
		
		MPMoviePlayerViewController *videoPlayer=[[[MPMoviePlayerViewController alloc] initWithContentURL:movieURL] autorelease];
		
		[self presentMoviePlayerViewControllerAnimated:videoPlayer];
	}

}

#pragma mark AGiftWebServiceDelegate
-(void)aGiftWebService:(AGiftWebService*)webService ReceiveGift3DBoxObjectArray:(NSArray*)respondData
{
	if(isDismissed==NO)
	{
		NSArray *domainPaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *docDirectory=[domainPaths objectAtIndex:0];
		
		NSDictionary *dic=[respondData objectAtIndex:0];
		
		self.materialName=[dic valueForKey:@"mtlName"];
		
		NSString *obj64Encoding=[dic valueForKey:@"obj"];
		NSString *mtl64Encoding=[dic valueForKey:@"mtl"];
		
		NSData *box3DObjData=[NSData dataWithBase64EncodedString:obj64Encoding];
		NSData *mtlData=[NSData dataWithBase64EncodedString:mtl64Encoding];
		
		NSString *objSaveName=[giftBoxPrefix stringByAppendingString:[boxNumber stringByAppendingString:@".obj"]];
		NSString *objSavePath=[docDirectory stringByAppendingPathComponent:objSaveName];
		
		NSString *mtlSavePath=[docDirectory stringByAppendingPathComponent:self.materialName];
		
		[box3DObjData writeToFile:objSavePath atomically:NO];
		[mtlData writeToFile:mtlSavePath atomically:NO];
		
		[self.downloadingView setHidden:YES];
		
		//init render engine
		[self.load3DView setHidden:NO];
		
		[self performSelector:@selector(initRenderingEngine) withObject:nil afterDelay:1];
	}
}

-(void)aGiftWebService:(AGiftWebService*)webService getGiftBoxVideoUrlString:(NSString*)respondData
{
	if(isDismissed==NO)
	{
		if(respondData)
		{
			self.videoURL=respondData;
			[playVideoButton setHidden:NO];
		}
	}

}

- (void)viewDidAppear:(BOOL)animated
{
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	if(modelRenderingEngine==nil)
	{
		NSArray *domainPaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *fileDirPath=[domainPaths objectAtIndex:0];
		
		//check if 3d model download already
		NSString *objFileName=[giftBoxPrefix stringByAppendingString:boxNumber];
		
		if([appDelegate hasFileInPath:fileDirPath FileName:objFileName FileFormat:@"obj"])
		{
			//file exist
			//init render engine
			[self.load3DView setHidden:NO];
			
			[self performSelector:@selector(initRenderingEngine) withObject:nil afterDelay:1];
		}
		else 
		{
			[self.downloadingView setHidden:NO];
			
			//file not exist download it first
			//NSOperationQueue *opQueue=[[NSOperationQueue new] autorelease];
			AGiftWebService *service=[[AGiftWebService alloc] initAGiftWebService];
			[service setDelegate:self];
			[appDelegate.mainOpQueue addOperation:service];
			[service ReceiveGift3DBoxObject:boxNumber];
			[service release];
		}
	}
	
	[self.view setFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height)];

}

-(void)viewWillAppear:(BOOL)animated
{
}

-(void)viewWillDisappear:(BOOL)animated
{
	/*
	if(modelRenderingEngine)
	{
		[modelRenderingEngine stopRender];
		self.modelRenderingEngine=nil;
	}
	 */

}

-(void)viewDidDisappear:(BOOL)animated
{
	if(shouldReleaseEngine)
	{
		if(modelRenderingEngine)
		{
			[modelRenderingEngine stopRender];
			self.modelRenderingEngine=nil;
		}
	}

}

- (void)dealloc {
	
	if(modelRenderingEngine)
	{
		[modelRenderingEngine stopRender];
		self.modelRenderingEngine=nil;
	}
	
	[openGLESReferenceView release];
	[closeButton release];
	[downloadingView release];
	[load3DView release];
	[boxNumber release];
	[giftBoxPrefix release];
	[materialName release];
	[hintButton release];
	[hintController release];
	[playVideoButton release];
	[videoURL release];
	
    [super dealloc];
}


@end
