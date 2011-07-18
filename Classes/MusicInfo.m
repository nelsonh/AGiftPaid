//
//  MusicInfo.m
//  AGiftPaid
//
//  Created by Nelson on 3/23/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import "MusicInfo.h"
#import "MusicImageView.h"
#import "AGiftPaidAppDelegate.h"

@implementation MusicInfo

@synthesize musicNumber;
@synthesize musicURL;
@synthesize musicFileName;
@synthesize isDownloadingMusic;
@synthesize musicData;
@synthesize musicIconPresenter;
@synthesize musicPrefix;


-(id)init
{
	if(self=[super init])
	{
		musicIconPresenter=[[MusicImageView alloc] initWithFrame:CGRectMake(0, 0, kImageSize, kImageSize)];
		musicPrefix=@"Music";
	}
	
	return self;
}

-(void)assignNumber:(NSUInteger)number
{
	self.musicNumber=number;
	[musicIconPresenter setNumber:[NSString stringWithFormat:@"%i", number]];
}

-(void)assignMusicFileName:(NSString*)fileName
{
	self.musicFileName=fileName;
	[musicIconPresenter assignMusicFileName:fileName];
}

-(void)downloadMusic
{
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	NSArray *domainPaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *docDirectory=[domainPaths objectAtIndex:0];
	
	//check if music is existed
	NSString *musicName=[musicPrefix stringByAppendingString:musicFileName];
	NSString *musicPath=[docDirectory stringByAppendingPathComponent:musicName];
	NSFileManager *fileManager=[NSFileManager defaultManager];
	
	if(![fileManager fileExistsAtPath:musicPath])
	{
		//music not existed download from server
		isDownloadingMusic=YES;
		
		musicData=[[NSMutableData alloc] init];
		
		[appDelegate startNetworkActivity];
		
		NSURL *url=[NSURL URLWithString:musicURL];
		NSURLRequest *request=[NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
		NSURLConnection *connection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
		[connection release];
	}
}

#pragma mark NSURLConnection delegate
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	[musicData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	NSArray *domainPaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *docDirectory=[domainPaths objectAtIndex:0];
	
	//write data to device
	NSString *musicSaveName=[musicPrefix stringByAppendingString:musicFileName];
	NSString *musicSavePath=[docDirectory stringByAppendingPathComponent:musicSaveName];
	
	[musicData writeToFile:musicSavePath atomically:NO];
	
	isDownloadingMusic=NO;
	
	[appDelegate stopNetworkActivity];
}



-(void)dealloc
{
	[musicURL release];
	[musicFileName release];
	
	if(musicData)
	{
		[musicData release];
	}
	
	[musicIconPresenter release];
	[musicPrefix release];
	
	[super dealloc];
}

@end
