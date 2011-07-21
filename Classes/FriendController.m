//
//  FriendController.m
//  AGiftPaid
//
//  Created by Nelson on 3/24/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import "FriendController.h"
#import "AGiftPaidAppDelegate.h"
#import "FriendInfo.h"
#import "FriendImageView.h"
#import "SendGiftSectionViewController.h"
#import "NSData+Base64.h"
#import "GiftBoxSelectionController.h"


@implementation FriendController

@synthesize friendGalleryScrollView;
@synthesize friendIDTextField;
@synthesize areaCodeTextField;
@synthesize addFriendButton;
@synthesize scrollViewSourceData;
@synthesize historyInfo;
@synthesize sendingGiftView;
@synthesize naviTitleView;
@synthesize animFriendInfo;
@synthesize deleteFriendButton;
@synthesize sendGiftButton;
@synthesize hintButton;
@synthesize hintController;
@synthesize sendSuccessAlert;
@synthesize deleteFriendAlert;
@synthesize updatingView;
@synthesize invitedPhoneNumber;
@synthesize shouldUpdateFriend;

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
	
	self.shouldUpdateFriend=YES;
	
	self.naviTitleView=[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iFriend.png"]] autorelease];
	[self.navigationItem setTitleView:self.naviTitleView];
	
	[self setTitle:@"Friend"];
	
	self.scrollViewSourceData=[appDelegate.dataManager retrieveFriendList];
	
	[sendingGiftView.layer setCornerRadius:10.0f];
	[sendingGiftView.layer setMasksToBounds:YES];
	
	[areaCodeTextField setDelegate:self];
	[friendIDTextField setDelegate:self];
	
	//add a tool bar on top of keyboard
	UIToolbar *keyboardToolBar=[[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
	[keyboardToolBar setTintColor:[UIColor colorWithRed:43.0f/255.0f green:13.0f/255.0f blue:9.0f/255.0f alpha:1.0f]];
	UIBarButtonItem *dismissKeyboardButton=[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(resignKeyboard)];
	
	NSArray *toolBarItems=[[NSArray alloc] initWithObjects:dismissKeyboardButton, nil];
	[keyboardToolBar setItems:toolBarItems];

	[areaCodeTextField setInputAccessoryView:keyboardToolBar];
	[friendIDTextField setInputAccessoryView:keyboardToolBar];
	
	[dismissKeyboardButton release];
	[toolBarItems release];
	[keyboardToolBar release];
	
	//custom navi right button
	UIImageView *nextButton=[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BoxNavi.png"]] autorelease];
	[nextButton setUserInteractionEnabled:YES];
	UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nextView)];
	[tapGesture setNumberOfTapsRequired:1];
	[nextButton addGestureRecognizer:tapGesture];
	[tapGesture release];
	
	UIBarButtonItem *nextButtonItem=[[UIBarButtonItem alloc] initWithCustomView:nextButton];
	
	[self.navigationItem setRightBarButtonItem:nextButtonItem];
	[nextButtonItem release];
	
	[appDelegate refreshTabbarTitle:@"Gift" index:1];
	
	[friendGalleryScrollView initialize];
	
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
	
	
	
	self.friendGalleryScrollView=nil;
	self.friendIDTextField=nil;
	self.addFriendButton=nil;
	self.sendingGiftView=nil;
	self.naviTitleView=nil;
	self.deleteFriendButton=nil;
	self.sendGiftButton=nil;
	self.areaCodeTextField=nil;
	self.hintButton=nil;
	self.hintController=nil;
	
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark IBAction Method
-(IBAction)doneWithFriendID
{
	[self resignKeyboard];
}

-(IBAction)addFriendButtonPressed
{
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	[self resignKeyboard];
	
	if([friendIDTextField.text isEqualToString:@""] || [areaCodeTextField.text isEqualToString:@""])
	{
		NSString *msg=@"Friend ID can not be blank";
		UIAlertView *blankAlert=[[UIAlertView alloc] initWithTitle:@"Blank" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[blankAlert show];
		[blankAlert release];
	}
	else 
	{
		/*
		if([friendIDTextField.text isEqualToString:appDelegate.userPhoneNumber])
		{
			NSString *msg=@"You can not add youself as friend";
			UIAlertView *addSelfAlert=[[UIAlertView alloc] initWithTitle:@"Add fail" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[addSelfAlert show];
			[addSelfAlert release];
		}
		 */
		
		NSString *friendPhoneNumber=[areaCodeTextField.text stringByAppendingFormat:@"-%@", friendIDTextField.text];
		
		if([appDelegate.dataManager isFriendExisted:friendPhoneNumber])
		{
			//friend existed
			NSString *msg=@"Friend ID is in your friend list already";
			UIAlertView *blankAlert=[[UIAlertView alloc] initWithTitle:@"Friend existed" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[blankAlert show];
			[blankAlert release];
		}
		else 
		{
			//call add friend service
			//NSOperationQueue *opQueue=[NSOperationQueue new];
			AGiftWebService *service=[[AGiftWebService alloc] initAGiftWebService];
			[service setDelegate:self];
			[appDelegate.mainOpQueue addOperation:service];
			[service addFriend:appDelegate.userPhoneNumber FriendID:friendPhoneNumber];
			[service release];
		}

	}
	
	[friendIDTextField setText:@""];
	[areaCodeTextField setText:@""];
}

-(IBAction)deleteFriendButtonPressed:(id)sender
{
	//tell main controller to delete friend
	[self deleteFriend];
}

-(IBAction)sendGiftButtonPressed:(id)sender
{
	[self sendGiftOut];
}

-(IBAction)hintButtonPress
{
	
	
	if(hintController)
	{
		[self resignKeyboard];
		
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.view cache:YES];
		[UIView setAnimationDuration:1.0];
		
		[self.view addSubview:hintController.view];
		
		[UIView commitAnimations];
	}
	
}

-(IBAction)inviteFriend
{
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	ABPeoplePickerNavigationController *peoplePicker=[[ABPeoplePickerNavigationController alloc] init];
	[peoplePicker setPeoplePickerDelegate:self];
	
	[appDelegate.rootController presentModalViewController:peoplePicker animated:YES];
	
	[peoplePicker release];
	
	self.shouldUpdateFriend=NO;
	
}

#pragma mark Method
-(void)resignKeyboard
{
	[friendIDTextField resignFirstResponder];
	[areaCodeTextField resignFirstResponder];
}

-(void)assignInfoToPackage
{
	SendGiftSectionViewController *rootNaviController=(SendGiftSectionViewController*)self.navigationController;
	SendGiftInfo *package=rootNaviController.giftInfoPackage;
	
	FriendInfo *friendInfo=[scrollViewSourceData objectAtIndex:friendGalleryScrollView.lastSelectedIcon.index];
	
	NSString *receiverID=[NSString stringWithFormat:@"%@", friendInfo.friendID];
	
	[package setReceiverID:receiverID];
	[package setReceiverName:friendGalleryScrollView.lastSelectedIcon.friendNameLabel.text];
	[package setReceiverPhotoUrl:friendInfo.friendPhotoURL];
}

-(void)sendGiftOut
{
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	if(friendGalleryScrollView.lastSelectedIcon==nil)
	{
		NSString *msg=@"You have to pick one friend from list";
		UIAlertView *pickOneAlert=[[UIAlertView alloc] initWithTitle:@"Pick one" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[pickOneAlert show];
		[pickOneAlert release];
	}
	else 
	{
		[sendingGiftView setHidden:NO];
		
		[self.view setUserInteractionEnabled:NO];
		[self.navigationController.view setUserInteractionEnabled:NO];
		
		SendGiftSectionViewController *rootNaviController=(SendGiftSectionViewController*)self.navigationController;
		SendGiftInfo *giftPackage=rootNaviController.giftInfoPackage;
		
		[deleteFriendButton setEnabled:NO];
		[sendGiftButton setEnabled:NO];
		
		[self assignInfoToPackage];
		
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

}

-(void)disableHint
{
	[hintController closeButtonPress];
}

-(void)nextView
{
	if(friendGalleryScrollView.lastSelectedIcon==nil)
	{
		NSString *msg=@"You have to pick one friend from list";
		UIAlertView *pickOneAlert=[[UIAlertView alloc] initWithTitle:@"Pick one" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[pickOneAlert show];
		[pickOneAlert release];
	}
	else 
	{
		[self assignInfoToPackage];
		
		[self disableHint];
		
		[self resignKeyboard];
		
		GiftBoxSelectionController *boxController=[[GiftBoxSelectionController alloc] initWithNibName:@"GiftBoxSelectionController" bundle:nil];
		[self.navigationController pushViewController:boxController animated:YES];
		[boxController release];
	}
}

-(void)inviteFriendMenu
{
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	UIActionSheet *inviteSheet=[[UIActionSheet alloc] initWithTitle:@"Invite a friend" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Invite a friend via E-mail", @"Invite a friend via SMS", nil];
	[inviteSheet showInView:appDelegate.rootController.view];
}

#pragma mark ABPeoplePickerNavigationControllerDelegate
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
	[peoplePicker dismissModalViewControllerAnimated:YES];
	
	self.shouldUpdateFriend=YES;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person
{
	NSString *pNumber;
	ABMultiValueRef pNumberRef;
	
	pNumberRef=ABRecordCopyValue(person, kABPersonPhoneProperty);
	pNumber=(NSString*)ABMultiValueCopyValueAtIndex(pNumberRef, 0);
	
	if(pNumber)
	{
		pNumber=[pNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
		pNumber=[pNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
		pNumber=[pNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
		pNumber=[pNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
		
		if([pNumber hasPrefix:@"+"])
		{
			pNumber=[pNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
			pNumber=[pNumber substringFromIndex:3];
		}
		
		self.invitedPhoneNumber=pNumber;
	}
	
	[self inviteFriendMenu];
	
	[peoplePicker dismissModalViewControllerAnimated:YES];
	
	return NO;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier
{
	return NO;
}


#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	self.shouldUpdateFriend=YES;
	
	if(buttonIndex==0)
	{
		NSURL *url=[NSURL URLWithString:@"mailto:test@gmail.com"];
		[[UIApplication sharedApplication] openURL:url];
	}
	else if(buttonIndex==1)
	{
		
		if([MFMessageComposeViewController canSendText] && self.invitedPhoneNumber)
		{
			AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];
			
			MFMessageComposeViewController *smsController=[[MFMessageComposeViewController alloc] init];
			
			smsController.body = @"msg test";
			smsController.recipients = [NSArray arrayWithObjects:self.invitedPhoneNumber, nil];
			smsController.messageComposeDelegate = self;
			[appDelegate.rootController presentModalViewController:smsController animated:YES];
			
			[smsController release];
		}
		else 
		{
			UIAlertView *smsAlert=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Unable to start SMS" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[smsAlert show];
			[smsAlert release];
		}
		
		

	}
}

#pragma mark MFMessageComposeViewControllerDelegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
	switch (result) {
		case MessageComposeResultCancelled:
			break;
		case MessageComposeResultFailed:
		{
			UIAlertView *failAlert = [[UIAlertView alloc] initWithTitle:@"SMS faild" message:@"Sent SMS faild"
														   delegate:nil	cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[failAlert show];
			[failAlert release];
			break;
		}
		case MessageComposeResultSent:
		{	
			UIAlertView *successAlert = [[UIAlertView alloc] initWithTitle:@"SMS success" message:@"SMS has been sent successful"
														   delegate:nil	cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[successAlert show];
			[successAlert release];
			break;
		}
		default:
			break;
	}
	
	[controller dismissModalViewControllerAnimated:YES];
}

#pragma mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	if(textField==areaCodeTextField)
	{
		NSUInteger textLength=[textField.text length]+[string length]-range.length;
		
		if(textLength>AreaCodeLimitation)
		{
			return NO;
		}
		else 
		{
			return YES;
		}
		
	}
	
	return YES;
}

#pragma mark AGiftWebServiceDelegate
-(void)aGiftWebService:(AGiftWebService*)webService addFriendDictionary:(NSDictionary*)respondData
{
	if(respondData)
	{
		
		FriendInfo *newFriendInfo=[[FriendInfo alloc] init];
		
		if([respondData valueForKey:@"FriendPhotoUri"]==[NSNull null])
		{
			[newFriendInfo setFriendPhotoURL:nil];
		}
		else
		{
			[newFriendInfo setFriendPhotoURL:[respondData valueForKey:@"FriendPhotoUri"]];
		}
		
		
		[newFriendInfo assignFriendName:[respondData valueForKey:@"FriendName"]];
		NSString *friendID=[respondData valueForKey:@"FindID"];
		[newFriendInfo setFriendID:friendID];
		
		//add to srouce data
		[scrollViewSourceData addObject:newFriendInfo];
		
		//download photo
		[newFriendInfo downloadFriendPhoto];
		
		//add a friend's view in scrollview
		[friendGalleryScrollView addfriendPhoto:newFriendInfo.friendIconPresenter];
		
		[newFriendInfo release];
	}
	else 
	{
		NSString *msg=@"The friend you added is not using this application";
		UIAlertView *blankAlert=[[UIAlertView alloc] initWithTitle:@"Not existed" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[blankAlert show];
		[blankAlert release];
	}

}

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
		

		
		[deleteFriendButton setEnabled:YES];
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
		
		[deleteFriendButton setEnabled:YES];
		[sendGiftButton setEnabled:YES];
		
		[sendingGiftView setHidden:YES];
		[self.navigationController.view setUserInteractionEnabled:YES];
		[self.view setUserInteractionEnabled:YES];
		
		//tell rool navi controller to reset
		[rootNaviController reset];
		
	}
	


}

#pragma mark FriendGalleryScrollViewDelegate;
-(void)GalleryScrollView:(FriendGalleryScrollView*)friendGalleryScrollView didSelectItemWithIndex:(NSUInteger)index
{	
}

-(void)GalleryScrollViewDidFinishInit:(FriendGalleryScrollView*)friendGalleryScrollView
{
	if(updating)
	{
		updateCount-=1;
		
		if(updateCount==0)
		{
			updating=NO;
			
			if(updatingView)
			{
				[self.updatingView dismissWithClickedButtonIndex:0 animated:YES];
				self.updatingView=nil;
			}
		}
	}
}

#pragma mark FriendGalleryScrollViewSourceDelegate
-(NSUInteger)numberOfItemInContentWithFriendGalleryScrollView:(FriendGalleryScrollView*)friendGalleryScrollView
{
	return [scrollViewSourceData count];
}

-(FriendImageView*)GalleryScrollView:(FriendGalleryScrollView*)friendGalleryScrollView friendIconViewForIndex:(NSUInteger)index
{
	FriendInfo *friendInfo=[scrollViewSourceData objectAtIndex:index];
	
	return friendInfo.friendIconPresenter;
}

#pragma mark method
-(void)deleteFriend;
{
	if(friendGalleryScrollView.lastSelectedIcon==nil)
	{
		NSString *msg=@"To delete friend you must pick one from your friend list";
		UIAlertView *pickOneAlert=[[UIAlertView alloc] initWithTitle:@"Pick one" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[pickOneAlert show];
		[pickOneAlert release];
	}
	else
	{
		FriendInfo *friendInfo=[scrollViewSourceData objectAtIndex:friendGalleryScrollView.lastSelectedIcon.index];
		NSString *phoneNumber=friendInfo.friendID;
		
		NSString *msg=[NSString stringWithFormat:@"Delete from friend list \n Friend:%@ \n Phone number:%@", friendInfo.friendName, phoneNumber];
		UIAlertView *deleteAlert=[[[UIAlertView alloc] initWithTitle:@"Delete alert" message:msg delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil] autorelease];
		self.deleteFriendAlert=deleteAlert;
		[deleteAlert show];
	}
}

-(void)doDeleteFriend
{
	
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	//prepare
	FriendInfo *friendInfo=[[scrollViewSourceData objectAtIndex:friendGalleryScrollView.lastSelectedIcon.index] retain];
	self.animFriendInfo=friendInfo;
	[animFriendInfo.friendIconPresenter deSelected];
	
	//remove friend frome core data
	[appDelegate.dataManager removeFriend:[NSString stringWithFormat:@"%@", friendInfo.friendID]];
	
	//remove frome surce data
	[scrollViewSourceData removeObjectAtIndex:friendGalleryScrollView.lastSelectedIcon.index];
	
	[friendGalleryScrollView setLastSelectedIcon:nil];
	
	//reset scrollview
	[friendGalleryScrollView reset];
	
	//anim effect
	UIView *targetView=(UIView*)deleteFriendButton;
	CGPoint startPoint=[self.view convertPoint:animFriendInfo.friendIconPresenter.frame.origin fromView:friendGalleryScrollView];
	
	[animFriendInfo.friendIconPresenter setFrame:CGRectMake(startPoint.x, startPoint.y, animFriendInfo.friendIconPresenter.frame.size.width, animFriendInfo.friendIconPresenter.frame.size.height)];
	[self.view addSubview:animFriendInfo.friendIconPresenter];
	
	UIBezierPath *movePath = [UIBezierPath bezierPath];
	[movePath moveToPoint:animFriendInfo.friendIconPresenter.center];
	[movePath addQuadCurveToPoint:targetView.center
					 controlPoint:CGPointMake(targetView.center.x, animFriendInfo.friendIconPresenter.center.y)];
	
	CAKeyframeAnimation *moveAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
	[moveAnim setPath:movePath.CGPath];
	[moveAnim setRemovedOnCompletion:YES];
	
	CABasicAnimation *scaleAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
	[scaleAnim setFromValue:[NSValue valueWithCATransform3D:CATransform3DIdentity]];
	[scaleAnim setToValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)]];
	[scaleAnim setRemovedOnCompletion:YES];

	CAAnimationGroup *animGroup = [CAAnimationGroup animation];
	[animGroup setAnimations:[NSArray arrayWithObjects:moveAnim, scaleAnim, nil]];
	[animGroup setDuration:0.5f];
	[animGroup setDelegate:self];
	
	[animFriendInfo.friendIconPresenter.layer addAnimation:animGroup forKey:nil];
	 
}

-(void)updateScrollviewSubView
{
	//update scrollview's subview if it need to display otherwise clear it
	for(FriendInfo *fi in self.scrollViewSourceData)
	{
		[fi shouldDisplay];
		
	}
}

#pragma mark CoreAnimationDelegate
- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
	[animFriendInfo.friendIconPresenter setHidden:YES];
	[animFriendInfo.friendIconPresenter removeFromSuperview];
	[animFriendInfo release];
	self.animFriendInfo=nil;
}

#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

	
	if(deleteFriendAlert==alertView)
	{
		if(buttonIndex==1)
		{
			//delete friend
			[self doDeleteFriend];
			
		}
		
		self.deleteFriendAlert=nil;
	}
	else if(sendSuccessAlert==alertView)
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

#pragma mark UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	[self updateScrollviewSubView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	if(!decelerate)
		[self updateScrollviewSubView];
}

-(void)viewDidAppear:(BOOL)animated
{
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	if([scrollViewSourceData count]>0 && self.shouldUpdateFriend)
	{
		updateCount=[scrollViewSourceData count];
		updating=YES;
		
		UIActionSheet *actionSheet=[[[UIActionSheet alloc] initWithTitle:@"Updating friend list. Please wait." delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil] autorelease];
		UIActivityIndicatorView *activityView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
		[activityView setFrame:CGRectMake(259, 10, activityView.frame.size.width, activityView.frame.size.height)];
		[activityView setHidden:NO];
		[activityView startAnimating];
		[actionSheet addSubview:activityView];
		[activityView release];
		
		self.updatingView=actionSheet;
		
		[actionSheet showInView:appDelegate.rootController.view];
		
		for(int i=0; i<[self.scrollViewSourceData count]; i++)
		{
			FriendInfo *friendInfo=[self.scrollViewSourceData objectAtIndex:i];
			
			[friendInfo updateFriendInfo];
		}
	}
}

#pragma mark  touch

- (void)dealloc {
	
	[self.friendGalleryScrollView destroy];

	self.scrollViewSourceData=nil;

	[friendGalleryScrollView release];
	[areaCodeTextField release];
	[friendIDTextField release];
	[addFriendButton release];
	//[scrollViewSourceData release];
	[historyInfo release];
	[sendingGiftView release];
	[naviTitleView release];
	[deleteFriendButton release];
	[sendGiftButton release];
	[hintButton release];
	[hintController release];
	[sendSuccessAlert release];
	[deleteFriendAlert release];
	self.invitedPhoneNumber=nil;
	
    [super dealloc];
}


@end
