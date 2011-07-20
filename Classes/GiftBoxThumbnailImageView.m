//
//  GiftImageView.m
//  AGiftFree
//
//  Created by Nelson on 2/23/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import "GiftBoxThumbnailImageView.h"
#import "GiftBoxGalleryScrollView.h"

@implementation GiftBoxThumbnailImageView

@synthesize owner;
@synthesize thumbnailImageURL;
@synthesize number;
@synthesize index;
@synthesize loadingActivityView;
@synthesize checkIcon;
@synthesize isDownloading;
@synthesize imageData;
@synthesize downloadConnection;


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame WithURL:(NSString*)iconURL
{
	self=[super initWithFrame:frame];
	if(self)
	{
		//create check icon
		self.checkIcon=[[[UIImageView alloc] initWithFrame:frame] autorelease];
		[checkIcon setImage:[UIImage imageNamed:@"Nike.png"]];
		
		//create loading indicator
		CGSize size=CGSizeMake(frame.size.width/2, frame.size.height/2);
		CGPoint pos=CGPointMake(size.width-(size.width/2), size.height-(size.height/2));
		CGRect indicatorFrame=CGRectMake(pos.x, pos.y, size.width, size.height);
		self.loadingActivityView=[[[UIActivityIndicatorView alloc] initWithFrame:indicatorFrame] autorelease];
		[loadingActivityView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
		[self addSubview:loadingActivityView];
		
		//start animation
		//[loadingActivityView startAnimating];
		
		self.thumbnailImageURL=iconURL;
		
		[self getIconWithURL:iconURL];
		
		
		UITapGestureRecognizer *tapGestrue=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didCheck)];
		[tapGestrue setNumberOfTapsRequired:1];
		[self addGestureRecognizer:tapGestrue];
		[tapGestrue release];
		
		UITapGestureRecognizer *doubleTapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap)];
		[doubleTapGesture setNumberOfTapsRequired:2];
		[self addGestureRecognizer:doubleTapGesture];
		[doubleTapGesture release];
	}
	
	return self;
}

#pragma mark methods
-(void)getIconWithURL:(NSString*)iconURL
{
	if(imageData!=nil)
	{
		[self setImage:[UIImage imageWithData:imageData]];
	}
	else 
	{
		self.isDownloading=YES;
		
		[loadingActivityView startAnimating];
		
		self.imageData=[[NSMutableData alloc] init];
		
		NSURL *url=[NSURL URLWithString:iconURL];
		NSURLRequest *request=[NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:30];
		NSURLConnection *connection=[[NSURLConnection alloc] initWithRequest:request delegate:self];
		self.downloadConnection=connection;
		[connection release];
	}


	
}

-(void)removeCheck
{
	[checkIcon removeFromSuperview];
}

-(void)didCheck
{
	
	if(owner.lastSelectedIcon==nil)
	{
		[self addSubview:checkIcon];
		[owner setLastSelectedIcon:self];
	}
	else 
	{
		[(GiftBoxThumbnailImageView*)owner.lastSelectedIcon removeCheck];
		[self addSubview:checkIcon];
		[owner setLastSelectedIcon:self];
	}


}

-(void)doubleTap
{
	[NSObject cancelPreviousPerformRequestsWithTarget:self];
	
	//tell scrollview this image has been selected
	[owner selectItemWithNumber:self.number];
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
	
	self.isDownloading=NO;
	[loadingActivityView stopAnimating];
	
	[self setImage:[UIImage imageWithData:imageData]];
	
	//enable user interaction
	[self setUserInteractionEnabled:YES];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/


/*
#pragma mark touch
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	if(!isDownloading)
	{
		//do gesture decision
		if([[touches anyObject] tapCount]==1)
		{
			[self performSelector:@selector(didCheck) withObject:nil afterDelay:0.2];
		}
		else if([[touches anyObject] tapCount]==2)
		{
			[NSObject cancelPreviousPerformRequestsWithTarget:self];
			
			//tell scrollview this image has been  selected
			[owner selectItemWithNumber:self.number];
		}

	}
	
}
 */

- (void)dealloc {
	
	self.owner=nil;
	//[owner release];
	//[thumbnailImageURL release];
	//[loadingActivityView release];
	self.thumbnailImageURL=nil;
	self.loadingActivityView=nil;
	
	//[checkIcon release];
	self.checkIcon=nil;
	
	if(downloadConnection)
	{
		[downloadConnection cancel];
		self.downloadConnection=nil;
	}
	
	if(imageData!=nil)
		[imageData release];
	
    [super dealloc];
}


@end
