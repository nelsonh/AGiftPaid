//
//  FriendGalleryScrollView.m
//  AGiftPaid
//
//  Created by Nelson on 3/24/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import "FriendGalleryScrollView.h"
#import "FriendImageView.h"

@implementation FriendGalleryScrollView

@synthesize friendThumbnails;
@synthesize lastSelectedIcon;
@synthesize sourceDataDelegate;
@synthesize methodDelegate;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
    }
    return self;
}

-(void)initialize
{
	if(self.friendThumbnails==nil)
		self.friendThumbnails=[[[NSMutableArray alloc] init] autorelease];
	
	//start position point
	positionToSet.x=kSpace;
	positionToSet.y=kSpace;
	
	if(self.sourceDataDelegate!=nil)
	{
		//setup content size base on number of item
		totalItem=[self.sourceDataDelegate numberOfItemInContentWithFriendGalleryScrollView:self];
		[self setupContentSize:totalItem];
		
	}
	
	if(self.sourceDataDelegate!=nil)
	{
		//setup images
		
		for(int i=0; i<totalItem; i++)
		{
			FriendImageView *tempImage=[self.sourceDataDelegate GalleryScrollView:self friendIconViewForIndex:i];
			[tempImage setOwner:self];
			[tempImage setIndex:i];
			
			[friendThumbnails addObject:tempImage];
			
		}
	}
	
	if(self.sourceDataDelegate!=nil)
	{
		for(int i=0; i<[friendThumbnails count]; i++)
		{
			//setup image position
			FriendImageView *thumbnail=[friendThumbnails objectAtIndex:i];
			CGRect thumbnailFrame=CGRectMake(positionToSet.x, positionToSet.y, thumbnail.frame.size.width, thumbnail.frame.size.height);
			
			//set frame
			thumbnail.frame=thumbnailFrame;
			
			//calculate next position
			positionToSet=[self calculateNextPosition];
		}
		
		for(int j=0; j<[friendThumbnails count]; j++)
		{
			//add image to scroll view
			FriendImageView *thumbnail=[friendThumbnails objectAtIndex:j];
			[self addSubview:thumbnail];
		}
	}
	
	[methodDelegate GalleryScrollViewDidFinishInit:self];
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
	for(int i=0; i<[friendThumbnails count]; i++)
	{
		FriendImageView *thumbnail=[friendThumbnails objectAtIndex:i];
		[thumbnail setIndex:i];
	}
}

-(void)refreshView
{
	for(int i=refreshStartIndex; i<[friendThumbnails count]; i++)
	{
		//setup image position
		FriendImageView *thumbnail=[friendThumbnails objectAtIndex:i];
		CGRect thumbnailFrame=CGRectMake(positionToSet.x, positionToSet.y, thumbnail.frame.size.width, thumbnail.frame.size.height);
		
		//set frame
		thumbnail.frame=thumbnailFrame;
		
		//calculate next position
		positionToSet=[self calculateNextPosition];
	}
	
	//refresh content size
	[self setupContentSize:[friendThumbnails count]];
}

-(void)reset
{
	for(FriendImageView *tempImage in friendThumbnails)
	{
		//remove from this scrollview
		[tempImage removeFromSuperview];
	}
	
	[self.friendThumbnails removeAllObjects];
	self.friendThumbnails=nil;
	totalItem=0;
	[self setContentSize:CGSizeMake(0,	0)];
	
	[self initialize];
}

-(void)addfriendPhoto:(FriendImageView*)friendIcon
{
	//setup image position
	CGRect thumbnailFrame=CGRectMake(positionToSet.x, positionToSet.y, friendIcon.frame.size.width, friendIcon.frame.size.height);
	
	//set frame
	friendIcon.frame=thumbnailFrame;
	
	[friendIcon setOwner:self];
	
	//add to container
	[friendThumbnails addObject:friendIcon];
	
	//add to scrollview
	[self addSubview:friendIcon];
	
	//calculate next position
	positionToSet=[self calculateNextPosition];
	
	//refresh index
	[self refreshItemIndex];
	
	//update contentsize
	[self setupContentSize:[friendThumbnails count]];
}

-(void)destroy
{
	for(UIView *childView in [self subviews])
	{
		[childView removeFromSuperview];
	}
	
	[self.friendThumbnails removeAllObjects];
}

- (void)dealloc {
	
	//[friendThumbnails release];
	self.friendThumbnails=nil;
	
    [super dealloc];
}


@end
