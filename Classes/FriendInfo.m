//
//  FriendInfo.m
//  AGiftPaid
//
//  Created by Nelson on 3/24/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import "FriendInfo.h"
#import "FriendImageView.h"
#import "AGiftPaidAppDelegate.h"
#import "FriendGalleryScrollView.h"


@implementation FriendInfo

@synthesize friendPhotoURL;
@synthesize friendID;
@synthesize friendName;
@synthesize friendIconPresenter;
@synthesize friendPhotoData;


-(id)init
{
	if(self=[super init])
	{
		friendIconPresenter=[[FriendImageView alloc] initWithFrame:CGRectMake(0, 0, kImageSize, kImageSize)];
	}
	
	return self;
}

-(void)assignFriendName:(NSString*)name
{
	self.friendName=name;
	[friendIconPresenter assignFriendLabelName:name];
}

-(void)assignFriendPhotoData:(NSData*)photoData
{
	self.friendPhotoData=(NSMutableData*)photoData;
	[friendIconPresenter.friendImagePresenter setImage:[UIImage imageWithData:friendPhotoData]];
}

-(void)downloadFriendPhoto
{
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	/*
	if(friendPhotoData==nil)
	{

	}
	 */
	
	if(friendPhotoURL!=nil)
	{
		friendPhotoData=[[NSMutableData alloc] init];
		NSURL *url=[NSURL URLWithString:friendPhotoURL];
		NSURLRequest *request=[NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
		NSURLConnection *connection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
		[connection release];
	}
	else 
	{
		//friend has no photo use default photo
		NSData *photoData=UIImagePNGRepresentation([UIImage imageNamed:@"AUser2.png"]);
		self.friendPhotoData=(NSMutableData*)photoData;
		
		//write friend info to core data
		[appDelegate.dataManager addNewFriend:self];
		
		//assign photo
		[friendIconPresenter.friendImagePresenter setImage:[UIImage imageWithData:friendPhotoData]];
		
	}

}

#pragma mark NSURLConnectionDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[friendPhotoData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	//write friend info to core data
	if(![appDelegate.dataManager isFriendExisted:self.friendID])
	{
		[appDelegate.dataManager addNewFriend:self];
	}
	else 
	{
		[appDelegate.dataManager updateFriendInfo:self];
	}

	
	
	//assign photo
	[friendIconPresenter.friendImagePresenter setImage:[UIImage imageWithData:friendPhotoData]];
	
	if(friendIconPresenter)
	{
		[friendIconPresenter.friendNameLabel setText:self.friendName];
		[friendIconPresenter.owner reset];
	}
}

#pragma mark methods
-(void)updateFriendInfo
{
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	//use add friend service to update friend info
	//NSOperationQueue *opQueue=[NSOperationQueue new];
	AGiftWebService *service=[[AGiftWebService alloc] initAGiftWebService];
	[service setDelegate:self];
	[appDelegate.mainOpQueue addOperation:service];
	[service addFriend:appDelegate.userPhoneNumber FriendID:self.friendID];
	[service release];
}

#pragma mark AGiftWebServiceDelegate
-(void)aGiftWebService:(AGiftWebService*)webService addFriendDictionary:(NSDictionary*)respondData
{
	if(respondData)
	{
		
		if([respondData valueForKey:@"FriendPhotoUri"]!=[NSNull null])
		{
			self.friendPhotoURL=[NSString stringWithString:[respondData valueForKey:@"FriendPhotoUri"]];
			
			[self downloadFriendPhoto];
		}

		
		self.friendName=[NSString stringWithString:[respondData valueForKey:@"FriendName"]];
		
		self.friendID=[NSString stringWithString:[respondData valueForKey:@"FindID"]];
		
		
	}
	else 
	{
		//receiver change phone number
		[friendIconPresenter.friendImagePresenter setImage:[UIImage imageNamed:@"AUser2.png"]];
		[friendIconPresenter.owner reset];
	}

	
}

-(void)dealloc
{
	[friendPhotoURL release];
	[friendName release];
	[friendIconPresenter release];
	[friendPhotoData release];
	[friendID release];
	
	[super dealloc];
}

@end
