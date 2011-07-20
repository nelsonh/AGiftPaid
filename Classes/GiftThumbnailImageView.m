//
//  GiftThumbnailImageView.m
//  AGiftPaid
//
//  Created by Nelson on 3/22/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import "GiftThumbnailImageView.h"
#import "GiftGalleryScrollView.h"


@implementation GiftThumbnailImageView

@synthesize owner;
@synthesize number;
@synthesize index;
@synthesize loadingActivityView;
@synthesize checkIcon;
@synthesize isDownloading;


- (id)initWithFrame:(CGRect)frame {
    
 	self=[super initWithFrame:frame];
	if(self)
	{
		//create check icon
		UIImageView *icon=[[[UIImageView alloc] initWithFrame:frame] autorelease];
		self.checkIcon=icon;
		//[icon release];
		
		[checkIcon setImage:[UIImage imageNamed:@"Nike.png"]];
		
		//create loading indicator
		CGSize size=CGSizeMake(frame.size.width/2, frame.size.height/2);
		CGPoint pos=CGPointMake(size.width-(size.width/2), size.height-(size.height/2));
		CGRect indicatorFrame=CGRectMake(pos.x, pos.y, size.width, size.height);
		self.loadingActivityView=[[[UIActivityIndicatorView alloc] initWithFrame:indicatorFrame] autorelease];
		[loadingActivityView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
		

		
		UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didCheck)];
		[tapGesture setNumberOfTapsRequired:1];
		[self addGestureRecognizer:tapGesture];
		[tapGesture release];
		
		UITapGestureRecognizer *doubleTapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTap)];
		[doubleTapGesture setNumberOfTapsRequired:2];
		[self addGestureRecognizer:doubleTapGesture];
		[doubleTapGesture release];
		
	}
	
	return self;
}

#pragma mark methods
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
		[(GiftThumbnailImageView*)owner.lastSelectedIcon removeCheck];
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

-(void)startDownloadIndicator
{
	[self addSubview:loadingActivityView];
	[loadingActivityView startAnimating];
}

-(void)stopDownloadIndicator
{
	//enable user interaction
	[self setUserInteractionEnabled:YES];
	
	[loadingActivityView stopAnimating];
	[loadingActivityView removeFromSuperview];
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
			
			//tell scrollview this image has been selected
			[owner selectItemWithNumber:self.number];
		}
		
	}
	
}
 */

- (void)dealloc {
	
	self.owner=nil;
	//[owner release];
	//[loadingActivityView release];
	self.loadingActivityView=nil;
	//[checkIcon release];
	self.checkIcon=nil;
	self.number=nil;
	
    [super dealloc];
}


@end
