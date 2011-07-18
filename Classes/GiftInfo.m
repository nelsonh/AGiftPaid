//
//  GiftInfo.m
//  AGiftPaid
//
//  Created by Nelson on 3/23/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import "GiftInfo.h"


@implementation GiftInfo

@synthesize thumbnailImageURL;
@synthesize imageData;
@synthesize giftNumber;
@synthesize giftIconPresenter;
@synthesize downloadConnection;


-(id)init
{
	if(self=[super init])
	{
		GiftThumbnailImageView *icon=[[GiftThumbnailImageView alloc] initWithFrame:CGRectMake(0, 0, kImageSize, kImageSize)];
		self.giftIconPresenter=icon;
		[icon release];
		
	}
	
	return self;
}

-(void)assignNumber:(NSUInteger)number
{
	self.giftNumber=number;
	[giftIconPresenter setNumber:[NSString stringWithFormat:@"%i", number]];
}

-(void)loadImage
{
	if(imageData!=nil)
	{
		[giftIconPresenter setImage:[UIImage imageWithData:imageData]];
	}
	else 
	{		
		[giftIconPresenter startDownloadIndicator];
		[giftIconPresenter setIsDownloading:YES];
		
		self.imageData=[[NSMutableData alloc] init];
		
		NSURL *url=[NSURL URLWithString:thumbnailImageURL];
		NSURLRequest *request=[NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
		NSURLConnection *connection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
		self.downloadConnection=connection;
		[connection release];
	}


}

#pragma mark NSURLDelegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[imageData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	self.downloadConnection=nil;
	
	[giftIconPresenter setIsDownloading:NO];
	[giftIconPresenter stopDownloadIndicator];
	
	[giftIconPresenter setImage:[UIImage imageWithData:imageData]];
}



-(void)dealloc
{
	[thumbnailImageURL release];
	
	if(imageData!=nil)
		[imageData release];
	
	[giftIconPresenter release];
	
	if(downloadConnection)
	{
		[downloadConnection cancel];
		self.downloadConnection=nil;
	}
	
	[super dealloc];
}

@end
