//
//  AGiftPaidAppDelegate.m
//  AGiftPaid
//
//  Created by Nelson on 3/21/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import "AGiftPaidAppDelegate.h"
#import "RegisterViewController.h"
#import "SoapReachability.h"
#import "GiftHistorySection.h"
#import "NSData+Base64.h"
#import "UserPhotoSettingViewController.h"
#import "SendGiftSectionViewController.h"
#import "FriendInfo.h"



NSString *const RegisterStatusFileName=@"RegisterStatus";
NSString *const RegisterUserName=@"UserName";
NSString *const RegisterPhoneNumber=@"PhoneNumber";
NSString *const RegisterPhotoImage=@"PhotoImage";
NSString *const RegisterAuthorizedKey=@"AuthorizedKey";
NSString *const VerifyName=@"VerifyUserName";
NSString *const VerifyCode=@"VerifyPassword";

@implementation AGiftPaidAppDelegate

@synthesize window;
@synthesize backViewController;
@synthesize msgEditView;
@synthesize registerStatus;
@synthesize userName;
@synthesize userPhoneNumber;
@synthesize userPhotoImage;
@synthesize userAuthorizedKey;
@synthesize rootController;
@synthesize verifyUserName;
@synthesize verifyPassword;
@synthesize dataManager;
@synthesize mainOpQueue;
@synthesize firstRegister;
@synthesize tryAgainButton;
@synthesize noConnectionImageView;
@synthesize instructionView;

#pragma mark Extend sync method
- (void)retrieveAuthorizeKey
{
	[self fetchVerifyInfo];
	
	[tryAgainButton setHidden:YES];
	[noConnectionImageView setHidden:YES];
	
	[backViewController.backImageView setImage:[UIImage imageNamed:@"SplashScreenImage.jpg"]];
	[backViewController.statusView setHidden:NO];
	[backViewController changeStatusMessage:@"Connect to server"];
	
	//NSOperationQueue *opQueue=[[NSOperationQueue new] autorelease];
	AGiftWebService *service=[[AGiftWebService alloc] initAGiftWebService];
	[service setDelegate:self];
	[mainOpQueue addOperation:service];
	[service retrieveAuthorizedKeyWithUsername:verifyUserName Password:verifyPassword];
	[service release];
}

- (void)syncDataAndInfo
{
	//[backViewController.backImageView setImage:[UIImage imageNamed:@"Loading2.png"]];
	[backViewController.statusView setHidden:NO];
	[backViewController changeStatusMessage:@"Loading data..."];
	
	[self fetchRegisterInfo];
	[self fetchCoreData];
	
	//check register status
	[self checkRegisterStatus];
}

- (void)fetchVerifyInfo
{
	NSString *verifyFilePath=[[NSBundle mainBundle] pathForResource:@"VerifyData" ofType:@"plist"];
	NSDictionary *verifyInfoData=[[NSDictionary alloc] initWithContentsOfFile:verifyFilePath];
	
	self.verifyUserName=[verifyInfoData valueForKey:VerifyName];
	self.verifyPassword=[verifyInfoData valueForKey:VerifyCode];
	
	[verifyInfoData release];
}

- (void)fetchRegisterInfo
{
	
	NSString *fileExtention=@"plist";
	
	NSArray *domainPaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *fileDirPath=[domainPaths objectAtIndex:0];
	
	
	
	//check user has register plist info file in device
	if([self hasFileInPath:fileDirPath FileName:RegisterStatusFileName FileFormat:fileExtention])
	{
		//file existed in path
		
		NSString *preFileName=[RegisterStatusFileName stringByAppendingString:@"."];
		NSString *completeFileName=[preFileName stringByAppendingString:fileExtention];
		NSString *fullPath=[fileDirPath stringByAppendingPathComponent:completeFileName];
		
		//retrieve register info by path
		registerStatus=[[NSMutableDictionary alloc] initWithContentsOfFile:fullPath];
		
		//set user info so we can send to server to do verification
		self.userName=[registerStatus valueForKey:RegisterUserName];
		self.userPhoneNumber=[registerStatus valueForKey:RegisterPhoneNumber];
		self.userPhotoImage=[registerStatus valueForKey:RegisterPhotoImage];
		

	}
	else 
	{
		//file not existed in path
		registerStatus=nil;
		self.userName=nil;
		self.userPhoneNumber=nil;
		self.userPhotoImage=nil;
		
	}
	

}

- (void)fetchCoreData
{
}

- (BOOL)saveRegisterInfo
{
	if(self.userPhoneNumber!=nil && self.userPhotoImage!=nil && self.userName!=nil)
	{
		
		NSMutableDictionary *registerInfo=[[NSMutableDictionary alloc] init];
		NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *docDirectory=[paths objectAtIndex:0];
		NSString *fileName=[RegisterStatusFileName stringByAppendingString:@".plist"];
		NSString *savingFullPath=[docDirectory stringByAppendingPathComponent:fileName];
		
		//set value
		[registerInfo setObject:self.userName forKey:RegisterUserName];
		[registerInfo setObject:self.userPhoneNumber forKey:RegisterPhoneNumber];
		[registerInfo setObject:self.userPhotoImage forKey:RegisterPhotoImage];
		[registerInfo setObject:self.userAuthorizedKey forKey:RegisterAuthorizedKey];
		
		//save to device
		[registerInfo writeToFile:savingFullPath atomically:NO];
		
		[registerInfo release];
		
		return YES;
	}
	else 
	{
		NSLog(@"Can not save register info as plist");
		return NO;
	}
	
}

#pragma mark UITabBarDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
	if([viewController isKindOfClass:[UserPhotoSettingViewController class]])
	{
		[(UserPhotoSettingViewController*)viewController retrieveUserInfo];
	}
}

#pragma mark AGiftWebService delegate
-(void)aGiftWebService:(AGiftWebService*)webService AuthorizedKeyDictionary:(NSDictionary*)respondData
{

	
	//[backViewController.statusView setHidden:YES];
	
	if(respondData==nil)
		return;
	
	if([(NSString*)[respondData valueForKey:@"resbool"] boolValue])
	{
		
		self.userAuthorizedKey=[respondData valueForKey:@"resString"];
		
		[self saveRegisterInfo];
		
		//DebugLog
		NSLog(@"authorized key:%@", userAuthorizedKey);
		
		// sync data and info
		[self syncDataAndInfo];
	}
	else
	{
		UIAlertView *authKeyAlert=[[UIAlertView alloc] initWithTitle:@"Authorized Key" message:@"Unable to get authorized key" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[authKeyAlert show];
		[authKeyAlert release];
	}
}

-(void)aGiftWebService:(AGiftWebService*)webService userExistedDictionary:(NSDictionary*)respondData
{
	[backViewController.statusView setHidden:YES];
	/*
	if(respondData!=nil)
	{
		NSString *userPhoto64Encoding=[respondData valueForKey:@"ProfilePhoto"];
		
		self.userPhotoImage=[NSData dataWithBase64EncodedString:userPhoto64Encoding];
		self.userPhoneNumber=[respondData valueForKey:@"PhoneNumber"];
		self.userName=[respondData valueForKey:@"UserName"];
		
		[self saveRegisterInfo];
		
		[self presentAGiftRootView];
	}
	else 
	{
		//show register view 
		RegisterViewController *registerController=[[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
		[backViewController presentModalViewController:registerController animated:YES];
		[registerController release];
	}
	 */
	
	if(respondData==nil)
		return;
	

	NSNumber *success=[respondData valueForKey:@"resbool"];

	if([success boolValue])
	{
		NSDictionary *userProfile=[respondData valueForKey:@"UserProfile"];
		
		NSString *savPhoneNumber=[userProfile valueForKey:@"PhoneNumber"];
		NSString *savUserName=[userProfile valueForKey:@"UserName"];
		NSString *photo64Encoding=[userProfile valueForKey:@"ProfilePhoto"];
		NSData *savUserPhoto=[NSData dataWithBase64EncodedString:photo64Encoding];
		
		if([savPhoneNumber isEqualToString:self.userPhoneNumber])
		{
			self.userPhoneNumber=savPhoneNumber;
			self.userName=savUserName;
			self.userPhotoImage=savUserPhoto;
			
			[self saveRegisterInfo];
			
			//info vaild access agift
			//[self presentAGiftRootView];
            [self doImportContactList];
		}
		else 
		{
			if(self.firstRegister)
			{
				NSArray *phoneNumberSet=[savPhoneNumber componentsSeparatedByString:@"-"];
				
				RegisterViewController *registerController=[[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
				[registerController setInAreaCode:[phoneNumberSet objectAtIndex:0]];
				[registerController setInPhoneNumber:[phoneNumberSet objectAtIndex:1]];
				[registerController setInUserName:savUserName];
				[registerController setInUserPhoto:[UIImage imageWithData:savUserPhoto]];
				[backViewController presentModalViewController:registerController animated:YES];
				[registerController release];
			}
			else 
			{
				NSArray *phoneNumberSet=[savPhoneNumber componentsSeparatedByString:@"-"];
				
				NSString *msg=@"The previous phone number has been updated. Please re-register";
				UIAlertView *regAlert=[[UIAlertView alloc] initWithTitle:@"Alert" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
				[regAlert show];
				[regAlert release];
				
				RegisterViewController *registerController=[[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
				[registerController setInAreaCode:[phoneNumberSet objectAtIndex:0]];
				[registerController setInPhoneNumber:[phoneNumberSet objectAtIndex:1]];
				[registerController setInUserName:savUserName];
				[registerController setInUserPhoto:[UIImage imageWithData:savUserPhoto]];
				[backViewController presentModalViewController:registerController animated:YES];
				[registerController release];
				
			}


		}
	}
	else 
	{
		//invaildate register
		NSString *msg=@"The phone number is not existed please register again";
		UIAlertView *regAlert=[[UIAlertView alloc] initWithTitle:@"Alert" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[regAlert show];
		[regAlert release];
		
		RegisterViewController *registerController=[[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
		[backViewController presentModalViewController:registerController animated:YES];
		[registerController release];
	}

}

-(void)aGiftWebService:(AGiftWebService*)webService getAvailableContactListArray:(NSArray*)respondData
{
    
    for(NSDictionary *dic in respondData)
    {
        FriendInfo *fInfo=[[[FriendInfo alloc] init] autorelease];
        
        [fInfo setFriendID:[dic valueForKey:@"ContactPhoneNumber"]];
        [fInfo setFriendName:[dic valueForKey:@"ContactPersonName"]];
        [fInfo setFriendPhotoURL:[dic valueForKey:@"ContactPersonPhotoUri"]];
        
        [self.dataManager addNewFriend:fInfo];
    }
	
	
    if([self isNetworkVaild])
		[self presentAGiftRootView];
}

#pragma mark UI alert view delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //import contact list alert
    if(buttonIndex==1)
    {
        [self doImportContactList];
    }
    else
    {
        [self presentAGiftRootView];
    }
    
}


#pragma mark Extend method
- (void)startNetworkActivity
{
	activityInvockCount+=1;
	
	if(activityInvockCount>0)
	{
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
		[[UIApplication sharedApplication] setIdleTimerDisabled:YES];
	}

}

- (void)stopNetworkActivity
{
	activityInvockCount-=1;
	
	if(activityInvockCount==0)
	{
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
		[[UIApplication sharedApplication] setIdleTimerDisabled:NO];
	}
}

- (void)startEditMessage:(UITextView*)inTextView
{
	msgEditView.lastOrientation=UIDeviceOrientationPortrait;
	
	[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
	[[NSNotificationCenter defaultCenter] addObserver:msgEditView selector:@selector(deviceDidRotate:) name:UIDeviceOrientationDidChangeNotification object:nil];
	
	[window addSubview:msgEditView.view];
	[msgEditView.view setFrame:CGRectMake(0, -300, 320, 300)];

	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(startEditMessageAnimationDidStop)];
	[msgEditView.view setFrame:CGRectMake(0, 20, 320, 300)];
	[UIView commitAnimations]; 
	
	[msgEditView.editTextView becomeFirstResponder];

	[msgEditView assignInputTextView:inTextView];
}

- (void)doneEditMessage
{
	[[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
	[[NSNotificationCenter defaultCenter] removeObserver:msgEditView name:UIDeviceOrientationDidChangeNotification object:nil];
	
	UIDeviceOrientation orientation=[UIDevice currentDevice].orientation;
	
	if(orientation==UIDeviceOrientationPortrait)
	{
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(doneEditMessageAnimationDidStop)];
		[msgEditView.view setFrame:CGRectMake(msgEditView.view.frame.origin.x, -300, msgEditView.view.frame.size.width, msgEditView.view.frame.size.height)];
		[UIView commitAnimations];
	}
	else if(orientation==UIDeviceOrientationLandscapeLeft)
	{
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(doneEditMessageAnimationDidStop)];
		[msgEditView.view setFrame:CGRectMake(322, msgEditView.view.frame.origin.y, msgEditView.view.frame.size.width, msgEditView.view.frame.size.height)];
		[UIView commitAnimations];
	}
	else if(orientation==UIDeviceOrientationLandscapeRight)
	{
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(doneEditMessageAnimationDidStop)];
		[msgEditView.view setFrame:CGRectMake(-322, msgEditView.view.frame.origin.y, msgEditView.view.frame.size.width, msgEditView.view.frame.size.height)];
		[UIView commitAnimations];
	}
	else 
	{
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(doneEditMessageAnimationDidStop)];
		[msgEditView.view setFrame:CGRectMake(msgEditView.view.frame.origin.x, -300, msgEditView.view.frame.size.width, msgEditView.view.frame.size.height)];
		[UIView commitAnimations];
	}

	
	[msgEditView.editTextView resignFirstResponder];
	
	[[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
}

- (void)startEditMessageAnimationDidStop
{
	[msgEditView deviceDidRotate:nil];
}

- (void)doneEditMessageAnimationDidStop
{
	msgEditView.view.transform=CGAffineTransformMakeRotation(0);
	[msgEditView.view setFrame:CGRectMake(0, 20, 320, 300)];
	[msgEditView.editTextView setFrame:CGRectMake(msgEditView.editTextView.frame.origin.x, msgEditView.editTextView.frame.origin.y, msgEditView.editTextView.frame.size.width, 171)];
	[msgEditView.borderImageView setFrame:CGRectMake(msgEditView.editTextView.frame.origin.x, msgEditView.editTextView.frame.origin.y, msgEditView.editTextView.frame.size.width, 173)];
	
	[msgEditView.view removeFromSuperview];
	
}


- (BOOL)hasFileInPath:(NSString*)fileDirectoryPath FileName:(NSString*)fileName FileFormat:(NSString*)fileFormat
{
	NSString *fullPath;
	
	//default format is plist
	NSString *defaultFormat=[NSString stringWithString:@"plist"];
	
	if(fileFormat!=nil)
	{
		//deal with file name
		NSString *preCombineFileName=[fileName stringByAppendingString:@"."];
		NSString *completeFileName=[preCombineFileName stringByAppendingString:fileFormat];
		
		//append to file dictory path
		fullPath=[fileDirectoryPath stringByAppendingPathComponent:completeFileName];
	}
	else 
	{
		//deal with file name
		NSString *preCombineFileName=[fileName stringByAppendingString:@"."];
		NSString *completeFileName=[preCombineFileName stringByAppendingString:defaultFormat];
		
		//append to file dictory path
		fullPath=[fileDirectoryPath stringByAppendingPathComponent:completeFileName];
	}
	
	
	//retrieve default file manager
	NSFileManager *defaultFileManager=[NSFileManager defaultManager];
	
	//DebugLog
	//NSLog(@"file is existed? %i", [defaultFileManager fileExistsAtPath:fullPath]);
	return [defaultFileManager fileExistsAtPath:fullPath];
	
}

- (NSMutableDictionary*)registerStatusInfo
{
	return [self registerStatus];
}


-(void)checkRegisterStatus
{

	[backViewController.statusView setHidden:NO];
	[backViewController changeStatusMessage:@"Sync with server"];
	
	if([self registerStatusInfo]!=nil)
	{
		self.firstRegister=NO;
		/*
		[self presentAGiftRootView];
		 */
		
		
		//check if this register info vaild
		NSString *udid;
		UIDevice *userDevice=[UIDevice currentDevice];
		
		udid=[userPhoneNumber stringByAppendingString:[NSString stringWithFormat:@"@%@", userDevice.uniqueIdentifier]];
		
		//send register info to server
		//NSOperationQueue *opQueue=[[NSOperationQueue new] autorelease];
		AGiftWebService *service=[[AGiftWebService alloc] initAGiftWebService];
		[service setDelegate:self];
		[mainOpQueue addOperation:service];
		[service userExisted:udid];
		[service release];
		
	}
	else
	{
		self.firstRegister=YES;
		/*
		NSString *udid;
		UIDevice *userDevice=[UIDevice currentDevice];
		
		udid=[NSString stringWithFormat:@"IPhone%@", userDevice.uniqueIdentifier];
		
		//check if register info is existed in server
		AGiftWebService *service=[[AGiftWebService alloc] initAGiftWebService];
		[service setDelegate:self];
		[mainOpQueue addOperation:service];
		[service checkDeviceIDExisted:udid];
		[service release];
		 */
		
		/*
		RegisterViewController *registerController=[[RegisterViewController alloc] initWithNibName:@"RegisterViewController" bundle:nil];
		[backViewController presentModalViewController:registerController animated:YES];
		[registerController release];
		 */
		
		NSString *udid;
		UIDevice *userDevice=[UIDevice currentDevice];
		
		udid=[@"1111" stringByAppendingString:[NSString stringWithFormat:@"@%@", userDevice.uniqueIdentifier]];
		
		//send register info to server
		//NSOperationQueue *opQueue=[[NSOperationQueue new] autorelease];
		AGiftWebService *service=[[AGiftWebService alloc] initAGiftWebService];
		[service setDelegate:self];
		[mainOpQueue addOperation:service];
		[service userExisted:udid];
		[service release];
	}
}

-(void)doImportContactList
{
    ABAddressBookRef addressBook=ABAddressBookCreate();
    
    if(!addressBook)
    {
        NSLog(@"can not open");
    }
    
    NSMutableArray *phoneNumberList=[[[NSMutableArray alloc] init] autorelease];
    CFArrayRef allPeople=ABAddressBookCopyArrayOfAllPeople(addressBook);
    CFIndex numberOfPeople=ABAddressBookGetPersonCount(addressBook);
    
    for(int i=0; i<numberOfPeople; i++)
    {
        ABRecordRef personRec=CFArrayGetValueAtIndex(allPeople, i);
        
        NSString *pNumber;
        ABMultiValueRef pNumberRef;
        
        pNumberRef=ABRecordCopyValue(personRec, kABPersonPhoneProperty);
        pNumber=(NSString*)ABMultiValueCopyValueAtIndex(pNumberRef, 0);
        
        
        pNumber=[pNumber stringByReplacingOccurrencesOfString:@"-" withString:@""];
        pNumber=[pNumber stringByReplacingOccurrencesOfString:@"(" withString:@""];
        pNumber=[pNumber stringByReplacingOccurrencesOfString:@")" withString:@""];
        pNumber=[pNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        if([pNumber hasPrefix:@"+"])
        {
            pNumber=[pNumber stringByReplacingOccurrencesOfString:@"+" withString:@""];
            pNumber=[pNumber substringFromIndex:3];
        }
        
        //NSCharacterSet *numbers = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
        //NSString *trimmedPhoneNumber = [pNumber stringByTrimmingCharactersInSet:numbers];
        
        [phoneNumberList addObject:pNumber];
		
    }
	
	CFRelease(addressBook);
    
    AGiftWebService *service=[[AGiftWebService alloc] initAGiftWebService];
    [service setDelegate:self];
    [mainOpQueue addOperation:service];
    [service getAvailableContactList:phoneNumberList];
    [service release];
}

-(void)importContactList
{
    NSString *msg=@"Gift-you would like to use addressbook";
    //ask user to import contact list
    UIAlertView *importAlert=[[UIAlertView alloc] initWithTitle:@"Alert" message:msg delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [importAlert show];
    [importAlert release];
}

- (void)presentAGiftRootView
{
	
	//register push notification
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert)];
	
	CGRect frame=rootController.view.frame;
	UIView *customTabView=[[UIView alloc] initWithFrame:frame];
	[customTabView setBackgroundColor:[UIColor colorWithRed:43.0f/255.0f green:13.0f/255.0f blue:9.0f/255.0f alpha:1.0f]];
	[rootController.tabBar insertSubview:customTabView atIndex:0];
	[customTabView release];
	
	//add background
	UIImageView *tabbarBackground=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"PayBackground.png"]];
	[rootController.tabBar insertSubview:tabbarBackground atIndex:1];
	

	
	//[backViewController presentModalViewController:rootController animated:YES];
	
	//anim effect
	//UIView *tabView=rootController.tabBar;
	//float originX=tabView.frame.origin.x;
	
	//frame=CGRectMake(320, tabView.frame.origin.y, tabView.frame.size.width, tabView.frame.size.height);
	//[rootController.tabBar setFrame:frame];
	
	//present AGift view
	[rootController setSelectedIndex:1];
	[window addSubview:rootController.view];
	
	//add transition effct
	CATransition *animation = [CATransition animation];
	[animation setDelegate:self];
	[animation setDuration:2.0f];
	[animation setTimingFunction:UIViewAnimationCurveEaseInOut];
	[animation setType:@"rippleEffect" ];
	[window.layer addAnimation:animation forKey:NULL];

	
	/*
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(startInstructionAnim)];
	[UIView setAnimationCurve:UIViewAnimationTransitionCurlDown];
	[UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:window cache:YES];
	[UIView setAnimationDuration:1.5];
	//[UIView setAnimationDidStopSelector:@selector(editMessageAnimationDidStop)];
	//[rootController.tabBar setFrame:CGRectMake(originX, frame.origin.y, frame.size.width, frame.size.height)];
	[window addSubview:rootController.view];
	[UIView commitAnimations];
	 */
	

}

#pragma mark CAAnimationDelegate
- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
	[self startInstructionAnim];
}

- (void)startInstructionAnim
{
	[self performSelector:@selector(showInstructionAnim) withObject:nil afterDelay:0.0];
}

- (void)showInstructionAnim
{
	//add instruction view
	CGRect instructionRect=CGRectMake(0, window.frame.size.height-rootController.tabBar.frame.size.height-instructionView.frame.size.height, instructionView.frame.size.width, instructionView.frame.size.height);
	[instructionView setFrame:instructionRect];
	[instructionView setAlpha:0];
	[window addSubview:instructionView];
	
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(instructionViewDidFinish)];
	[UIView setAnimationDuration:1.0];
	[instructionView setAlpha:1];
	[UIView commitAnimations];
}

- (void)instructionViewDidFinish
{
	[self performSelector:@selector(dismissInstructionViewAnim) withObject:nil afterDelay:3];
}

- (void)dismissInstructionViewAnim
{
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(dismissInstructionViewDidFinish)];
	[UIView setAnimationDuration:1.0];
	[instructionView setAlpha:0];
	[UIView commitAnimations];
}

- (void)dismissInstructionViewDidFinish
{
	[instructionView removeFromSuperview];
}


- (void)refreshTabbarTitle:(NSString*)title index:(NSUInteger)index
{
	NSArray *tabbarItems=rootController.tabBar.items;

	if(index>([tabbarItems count]-1))
	{
		return;
	}

	UITabBarItem *tabItem=[tabbarItems objectAtIndex:index];
	
	[tabItem setTitle:title];
}

- (void)presentAGiftRootViewMultiTask
{
	
	UIView *topView=[[window subviews] objectAtIndex:[[window subviews] count]-1];
	
	[topView setAlpha:0.0f];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationCurve:UIViewAnimationTransitionCurlDown];
	[UIView setAnimationDuration:0.8];
	//[UIView setAnimationDidStopSelector:@selector(editMessageAnimationDidStop)];
	[topView setAlpha:1.0f];
	[UIView commitAnimations];
	
	if(topView==rootController.view)
	{
		if([[rootController selectedViewController] isKindOfClass:[GiftHistorySection class]])
		{
			[(GiftHistorySection*)[rootController selectedViewController] update];
		}
	}
}

- (void)presentNewController:(UIViewController*)newController animated:(BOOL)animation
{
	//tell root controller to present a new controller no retain
	[rootController presentModalViewController:newController animated:animation];
}

- (BOOL)isNetworkVaild
{
	return [SoapReachability connectedToNetwork];
}

- (void)createCoreDataManager
{
	self.dataManager=[[CoreDataManager alloc] init];
}

- (void)webServiceError:(NSString*)title message:(NSString*)msg
{
	UIAlertView *serviceErrorAlert=[[UIAlertView alloc] initWithTitle:title message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[serviceErrorAlert show];
	[serviceErrorAlert release];
	
	[self internetFail];
}

- (void)networkConnectionError
{
	NSString *msg=[NSString stringWithString:@"Unable to connect to internet. Please check your internet connection"];
	
	UIAlertView *networkFailAlert=[[UIAlertView alloc] initWithTitle:@"Internet fail" message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[networkFailAlert show];
	[networkFailAlert release];
	
	[self internetFail];
}

- (void)internetFail
{
		
	if(rootController.modalViewController)
	{
		[rootController.modalViewController dismissModalViewControllerAnimated:NO];
	}

	
	[rootController.view removeFromSuperview];
	backViewController.backImageView.image=nil;
	[backViewController.statusView setHidden:YES];
	
	//[rootController release];
	
	activityInvockCount=0;
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	[[UIApplication sharedApplication] setIdleTimerDisabled:NO];
	
	[tryAgainButton setHidden:NO];
	[noConnectionImageView setHidden:NO];
	[window bringSubviewToFront:tryAgainButton];
	[window bringSubviewToFront:noConnectionImageView];
	[tryAgainButton setHidden:NO];
	[noConnectionImageView setHidden:NO];
}

#pragma mark IBAction method
- (IBAction)tryAgainButtonPress
{
	[window sendSubviewToBack:tryAgainButton];
	[window sendSubviewToBack:noConnectionImageView];
	[tryAgainButton setHidden:YES];
	[noConnectionImageView setHidden:YES];
	
	[self retrieveAuthorizeKey];
}

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
	
	[[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
	
	activityInvockCount=0;
	
	self.mainOpQueue=[[NSOperationQueue alloc] init];
	
	[window addSubview:backViewController.view];
	
	//init core data manager
	[self createCoreDataManager];
	
	//get key from server
	[self retrieveAuthorizeKey];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
	
	if(rootController.modalViewController)
	{
		[rootController.modalViewController dismissModalViewControllerAnimated:NO];
	}
	
	[rootController.view removeFromSuperview];
	[backViewController dismissModalViewControllerAnimated:NO];
	//backViewController.backImageView.image=nil;
	[backViewController.backImageView setImage:[UIImage imageNamed:@"SplashScreenImage.jpg"]];
	[instructionView removeFromSuperview];
	//[rootController release];
	
	activityInvockCount=0;
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
	[[UIApplication sharedApplication] setIdleTimerDisabled:NO];
	
	[window sendSubviewToBack:tryAgainButton];
	[window sendSubviewToBack:noConnectionImageView];
	[tryAgainButton setHidden:YES];
	[noConnectionImageView setHidden:YES];
	
    [self saveContext];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of the transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
	
	[[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
	
	//[self presentAGiftRootViewMultiTask];
	[self retrieveAuthorizeKey];
	
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


/**
 applicationWillTerminate: saves changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application {
    [self saveContext];
	
	//save register info again
	NSArray *domainPaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *fileDirPath=[domainPaths objectAtIndex:0];
	
	NSString *preFileName=[RegisterStatusFileName stringByAppendingString:@"."];
	NSString *completeFileName=[preFileName stringByAppendingString:@"plist"];
	NSString *fullPath=[fileDirPath stringByAppendingString:completeFileName];
	
	[[self registerStatusInfo] writeToFile:fullPath atomically:NO];
}

#pragma mark register notification delegate
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken
{
	NSLog(@"token %@", devToken);
	
	//NSOperationQueue *opQueue=[[NSOperationQueue new] autorelease];
	AGiftWebService *service=[[AGiftWebService alloc] initAGiftWebService];
	[service setDelegate:self];
	[mainOpQueue addOperation:service];
	[service registerDeviceToken:devToken phoneNumber:self.userPhoneNumber];
	[service release];
}

- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)err
{
	NSLog(@"notification error %@", err);
}


- (void)saveContext {
    
    NSError *error = nil;
	NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}    


#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext {
    
    if (managedObjectContext_ != nil) {
        return managedObjectContext_;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext_ = [[NSManagedObjectContext alloc] init];
        [managedObjectContext_ setPersistentStoreCoordinator:coordinator];
    }
    return managedObjectContext_;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel {
    
    if (managedObjectModel_ != nil) {
        return managedObjectModel_;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"AGiftPaid" withExtension:@"momd"];
    managedObjectModel_ = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
    return managedObjectModel_;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (persistentStoreCoordinator_ != nil) {
        return persistentStoreCoordinator_;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"AGiftPaid.sqlite"];
    
    NSError *error = nil;
    persistentStoreCoordinator_ = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator_ addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return persistentStoreCoordinator_;
}


#pragma mark -
#pragma mark Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    
    [managedObjectContext_ release];
    [managedObjectModel_ release];
    [persistentStoreCoordinator_ release];
	[mainOpQueue release];
    
    [window release];
    [super dealloc];
}


@end

