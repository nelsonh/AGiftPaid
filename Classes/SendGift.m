//
//  Class.m
//  AGiftPaid
//
//  Created by JamesC on 2011/7/14.
//  Copyright 2011年 aSQUARE. All rights reserved.
//

#import "SendGift.h"
#import "AGiftPaidAppDelegate.h"
#import "SendGiftSectionViewController.h"
#import "SendGiftInfo.h"
#import "NSData+Base64.h"


@implementation SendGift

@synthesize sendGiftButton;
@synthesize sendingGiftView;
@synthesize historyInfo;
@synthesize sendSuccessAlert;
@synthesize naviTitleView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
	[sendGiftButton release];
	[sendingGiftView release];
	[historyInfo release];
	[sendSuccessAlert release];
	[naviTitleView release];
	
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
	self.naviTitleView=[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iSend.png"]] autorelease];
	[self.navigationItem setTitleView:self.naviTitleView];
	
	[self setTitle:@"Friend"];
	
	[sendingGiftView.layer setCornerRadius:10.0f];
	[sendingGiftView.layer setMasksToBounds:YES];
	
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
	self.sendGiftButton=nil;
	self.sendingGiftView=nil;
	self.naviTitleView=nil;
	
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark IBOutlet methods
-(IBAction)sendGiftButtonPressed:(id)sender
{
	[self sendGiftOut];
}

#pragma mark methods
-(void)sendGiftOut
{
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];
	

	[sendingGiftView setHidden:NO];
	
	[self.view setUserInteractionEnabled:NO];
	[self.navigationController.view setUserInteractionEnabled:NO];
	
	SendGiftSectionViewController *rootNaviController=(SendGiftSectionViewController*)self.navigationController;
	SendGiftInfo *giftPackage=rootNaviController.giftInfoPackage;
	
	//send push to receiver
	//NSOperationQueue *opQueue=[NSOperationQueue new];
	AGiftWebService *pushService=[[AGiftWebService alloc] initAGiftWebService];
	[pushService setDelegate:self];
	[appDelegate.mainOpQueue addOperation:pushService];
	[pushService sendPushNotificationToReceiver:giftPackage.receiverID];
	[pushService release];
	
	//send gift
	//call send gift service
	//NSOperationQueue *opQueue=[NSOperationQueue new];
	AGiftWebService *service=[[AGiftWebService alloc] initAGiftWebService];
	[service setDelegate:self];
	[appDelegate.mainOpQueue addOperation:service];
	[service sendGift:giftPackage];
	[service release];
	
}

#pragma mark AGiftWebServiceDelegate
-(void)aGiftWebService:(AGiftWebService*)webService sendGiftGiftIDDectionary:(NSDictionary*)respondData
{
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	NSArray *domainPaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *fileDirPath=[domainPaths objectAtIndex:0];
	
	SendGiftSectionViewController *rootNaviController=(SendGiftSectionViewController*)self.navigationController;
	SendGiftInfo *package=rootNaviController.giftInfoPackage;
	
	if(respondData==nil)
	{
		NSString *msg=[NSString stringWithFormat:@"Send gift fail \n Reason:%@", @"Network not available. Please check internet"];
		
		UIAlertView *failAlert=[[UIAlertView alloc] initWithTitle:@"fail" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[failAlert show];
		[failAlert release];
		
		//tell rool navi controller to reset
		[rootNaviController reset];
		
		return;
	}
	
	NSNumber *success=[respondData valueForKey:@"resInt"];
	
	if([success intValue]==1)
	{
		
		NSString *sentGiftID=[respondData valueForKey:@"resString"];
		NSString *giftID=[NSString stringWithFormat:@"%@",sentGiftID];
		
		//save a temp history
		GiftHistoryInfo *history=[[GiftHistoryInfo alloc] init];
		self.historyInfo=history;
		[history release];
		
		[historyInfo setGiftID:giftID];//gift id
		[historyInfo setCanOpenTime:package.canOpenTime];//gift can open time
		[historyInfo setReceiverName:package.receiverName];// receiver name
		[historyInfo setReceiverPhotoURL:package.receiverPhotoUrl];//receiver photo url
		[historyInfo setReceiverPhoneNumber:package.receiverID];//receiver phone number
		
		[historyInfo setSendDate:[NSDate date]];//send time
		
		[historyInfo setGiftBoxImageUrl:package.giftBoxImageUrl];//gift box image
		[historyInfo setGiftImageUrl:package.giftImageUrl];// gift image
		
		if(package.giftPhoto64Encoding!=nil)
		{
			NSString *giftPhotoIndexTrackerPlistPath=[fileDirPath stringByAppendingPathComponent:@"PhotoIndexTracker.plist"];
			NSFileManager *fileManager=[NSFileManager defaultManager];
			NSData *photoData=[NSData dataWithBase64EncodedString:package.giftPhoto64Encoding];
			
			
			
			if([fileManager fileExistsAtPath:giftPhotoIndexTrackerPlistPath])
			{
				//file exist
				NSMutableArray *indexTracker=[NSMutableArray arrayWithContentsOfFile:giftPhotoIndexTrackerPlistPath];
				NSNumber *lastIndex=[indexTracker objectAtIndex:[indexTracker count]-1];
				NSUInteger newIndex=[lastIndex integerValue]+1;
				NSString *photoSavePath=[fileDirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%i.png", newIndex]];
				
				//save photo data
				[photoData writeToFile:photoSavePath atomically:NO];
				
				//write index to plist
				[indexTracker addObject:[NSNumber numberWithUnsignedInteger:newIndex]];
				[indexTracker writeToFile:giftPhotoIndexTrackerPlistPath atomically:NO];
				
				[historyInfo setGiftPhotoDataIndex:[NSString stringWithFormat:@"%i", newIndex]];//gift photo
			}
			else 
			{
				//file not exist
				NSMutableArray *indexTracker=[[NSMutableArray alloc] init];
				NSUInteger newIndex=1;
				NSString *photoSavePath=[fileDirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%i.png", newIndex]];
				
				//save photo data
				[photoData writeToFile:photoSavePath atomically:NO];
				
				//write index to plist
				[indexTracker addObject:[NSNumber numberWithUnsignedInteger:newIndex]];
				[indexTracker writeToFile:giftPhotoIndexTrackerPlistPath atomically:NO];
				
				[historyInfo setGiftPhotoDataIndex:[NSString stringWithFormat:@"%i", newIndex]];//gift photo
				
				[indexTracker release];
			}
		}
		
		
		[historyInfo setMusicName:package.musicName];//music name
		
		[historyInfo setBeforeMsg:package.beforeMsg];//before msg
		[historyInfo setAfterMsg:package.afterMsg];//after msg
		
		[appDelegate.dataManager saveGiftHistory:historyInfo];
		
		
		NSString *msg=@"Gift had been sent successful";
		UIAlertView *successAlert=[[[UIAlertView alloc] initWithTitle:@"Success" message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil] autorelease];
		self.sendSuccessAlert=successAlert;
		[successAlert show];
		
		
		
		[sendGiftButton setEnabled:YES];
		
		[sendingGiftView setHidden:YES];
		[self.navigationController.view setUserInteractionEnabled:YES];
		[self.view setUserInteractionEnabled:YES];
		
	}
	else 
	{
		NSString *errorMsg=[respondData valueForKey:@"errorMsg"];
		
		NSString *msg=[NSString stringWithFormat:@"Send gift fail \n Reason:%@", errorMsg];
		
		UIAlertView *failAlert=[[UIAlertView alloc] initWithTitle:@"fail" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[failAlert show];
		[failAlert release];
		

		[sendGiftButton setEnabled:YES];
		
		[sendingGiftView setHidden:YES];
		[self.navigationController.view setUserInteractionEnabled:YES];
		[self.view setUserInteractionEnabled:YES];
		
		//tell rool navi controller to reset
		[rootNaviController reset];
		
	}
	
	
	
}

#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	
	
	if(sendSuccessAlert==alertView)
	{
		AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];
		SendGiftSectionViewController *rootNaviController=(SendGiftSectionViewController*)self.navigationController;
		
		//tell tab bar go to history section
		[appDelegate.rootController setSelectedIndex:2];
		
		//tell rool navi controller to reset
		[rootNaviController reset];
		
		self.sendSuccessAlert=nil;
	}
	
}


@end
