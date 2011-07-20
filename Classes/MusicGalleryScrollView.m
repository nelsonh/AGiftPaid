//
//  MusicGalleryScrollView.m
//  AGiftPaid
//
//  Created by Nelson on 3/23/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import "MusicGalleryScrollView.h"
#import "MusicImageView.h"

@implementation MusicGalleryScrollView

@synthesize musicThumbnails;
@synthesize sourceDataDelegate;
@synthesize methodDelegate;
@synthesize lastSelectedIcon;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
    }
    return self;
}

-(void)initialize
{
	if(self.musicThumbnails==nil)
		self.musicThumbnails=[[[NSMutableArray alloc] init] autorelease];
	
	//start position point
	positionToSet.x=kSpace;
	positionToSet.y=kSpace;
	
	if(self.sourceDataDelegate!=nil)
	{
		//setup content size base on number of item
		totalItem=[self.sourceDataDelegate numberOfItemInContentWithMusicGalleryScrollView:self];
		[self setupContentSize:totalItem];
		
	}
	
	if(self.sourceDataDelegate!=nil)
	{
		//setup images
		
		for(int i=0; i<totalItem; i++)
		{
			MusicImageView *tempImage=[self.sourceDataDelegate GalleryScrollView:self musicIconViewForIndex:i];
			[tempImage setIndex:i];
			
			[musicThumbnails addObject:tempImage];
			
		}
	}
	
	if(self.sourceDataDelegate!=nil)
	{
		for(int i=0; i<[musicThumbnails count]; i++)
		{
			//setup image position
			MusicImageView *thumbnail=[musicThumbnails objectAtIndex:i];
			CGRect thumbnailFrame=CGRectMake(positionToSet.x, positionToSet.y, thumbnail.frame.size.width, thumbnail.frame.size.height);
			
			//set frame
			thumbnail.frame=thumbnailFrame;
			
			//calculate next position
			positionToSet=[self calculateNextPosition];
		}
		
		for(int j=0; j<[musicThumbnails count]; j++)
		{
			//add image to scroll view
			MusicImageView *thumbnail=[musicThumbnails objectAtIndex:j];
			[self addSubview:thumbnail];
		}
	}
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

#pragma mark methods
-(void)setupContentSize:(NSUInteger)numberOfItem
{
	CGSize scrollViewContentSize;
	CGSize scrollViewSpaceSize;
	CGSize scrollViewTotalSize;
	NSUInteger numberOfRow=numberOfItem/kRowItem;
	NSUInteger remain=numberOfItem%kRowItem;
	
	if(remain!=0)
	{
		numberOfRow=numberOfRow+1;
	}
	
	scrollViewContentSize.width=kItemSize*kRowItem;
	scrollViewContentSize.height=numberOfRow*kItemSize;
	scrollViewSpaceSize.width=kSpace*(kRowItem+1);
	scrollViewSpaceSize.height=kSpace*(numberOfRow+1);
	
	scrollViewTotalSize.width=scrollViewContentSize.width+scrollViewSpaceSize.width;
	scrollViewTotalSize.height=scrollViewContentSize.height+scrollViewSpaceSize.height;
	
	[self setContentSize:CGSizeMake(scrollViewTotalSize.width,	scrollViewTotalSize.height)];
}

-(CGPoint)calculateNextPosition
{
	CGPoint newPoisition;
	
	//x position
	if((positionToSet.x+kItemSize+kSpace)<self.frame.size.width)
	{
		//a row is not full
		newPoisition.x=positionToSet.x+kItemSize+kSpace;
		
		//y position
		newPoisition.y=positionToSet.y;
	}
	else
	{
		//position to next row most left 
		newPoisition.x=kSpace;
		//y position
		newPoisition.y=positionToSet.y+kItemSize+kSpace;
	}
	
	return newPoisition;
}

-(void)selectItemWithIndex:(NSUInteger)index
{
	//inform delegate
	if(self.methodDelegate!=nil)
	{
		[self.methodDelegate GalleryScrollView:self didSelectItemWithIndex:index];
	}
}

-(void)refreshItemIndex
{
	for(int i=0; i<[musicThumbnails count]; i++)
	{
		MusicImageView *thumbnail=[musicThumbnails objectAtIndex:i];
		[thumbnail setIndex:i];
	}
}

-(void)refreshView
{
	for(int i=refreshStartIndex; i<[musicThumbnails count]; i++)
	{
		//setup image position
		MusicImageView *thumbnail=[musicThumbnails objectAtIndex:i];
		CGRect thumbnailFrame=CGRectMake(positionToSet.x, positionToSet.y, thumbnail.frame.size.width, thumbnail.frame.size.height);
		
		//set frame
		thumbnail.frame=thumbnailFrame;
		
		//calculate next position
		positionToSet=[self calculateNextPosition];
	}
	
	//refresh content size
	[self setupContentSize:[musicThumbnails count]];
}

-(void)reset
{
	for(MusicImageView *tempImage in musicThumbnails)
	{
		//remove from this scrollview
		[tempImage removeFromSuperview];
	}
	
	[musicThumbnails removeAllObjects];
	self.musicThumbnails=nil;
	totalItem=0;
	[self setContentSize:CGSizeMake(0,	0)];
	
	[self initialize];
}

-(void)deSelectLastIcon
{
	[lastSelectedIcon deSelected];
	self.lastSelectedIcon=nil;
}

-(void)destroy
{
	for(UIView *childView in [self subviews])
	{
		[childView removeFromSuperview];
	}
	
	[self.musicThumbnails removeAllObjects];
}

- (void)dealloc {
	
	self.musicThumbnails=nil;
	//[musicThumbnails release];
	[lastSelectedIcon release];
	
    [super dealloc];
}


@end
