//
//  GiftGalleryScrollView.m
//  AGiftFree
//
//  Created by Nelson on 2/23/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import "GiftBoxGalleryScrollView.h"
#import "GiftBoxThumbnailImageView.h"

@implementation GiftBoxGalleryScrollView

@synthesize giftThumbnails;
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
	self.giftThumbnails=[[[NSMutableArray alloc] init] autorelease];
	
	//start position point
	positionToSet.x=kSpace;
	positionToSet.y=kSpace;
	
	if(self.sourceDataDelegate!=nil)
	{
		//setup content size base on number of item
		totalItem=[self.sourceDataDelegate numberOfItemInContentWithGiftGalleryScrollView:self];
		[self setupContentSize:totalItem];
		
	}
	
	if(self.sourceDataDelegate!=nil)
	{
		//setup images
		
		for(int i=0; i<totalItem; i++)
		{
			
			NSString *imageURL=[self.sourceDataDelegate GalleryScrollView:self giftImageURLForIndex:i];
			
			GiftBoxThumbnailImageView *tempImage=[[GiftBoxThumbnailImageView alloc] initWithFrame:CGRectMake(0, 0, kItemSize, kItemSize) WithURL:imageURL];
			NSString *aNumber=[NSString stringWithFormat:@"%i", [self.sourceDataDelegate GalleryScrollView:self giftBoxIconNumberForIndex:i]];
			[tempImage setNumber:aNumber];
			[tempImage setIndex:i];
			[tempImage setOwner:self];
			[giftThumbnails addObject:tempImage];
			[tempImage release];
		}
		
		//[imageFileName release];
	}
	
	if(self.sourceDataDelegate!=nil)
	{
		for(int i=0; i<[giftThumbnails count]; i++)
		{
			//setup image position
			GiftBoxThumbnailImageView *thumbnail=[giftThumbnails objectAtIndex:i];
			CGRect thumbnailFrame=CGRectMake(positionToSet.x, positionToSet.y, thumbnail.frame.size.width, thumbnail.frame.size.height);
			
			//set frame
			thumbnail.frame=thumbnailFrame;
			
			//calculate next position
			positionToSet=[self calculateNextPosition];
		}
		
		for(int j=0; j<[giftThumbnails count]; j++)
		{
			//add image to scroll view
			GiftBoxThumbnailImageView *thumbnail=[giftThumbnails objectAtIndex:j];
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

-(void)selectItemWithNumber:(NSString*)imageNumber;
{
	//inform delegate
	if(self.methodDelegate!=nil)
	{
		[self.methodDelegate GalleryScrollView:self didSelectItemWithNumber:imageNumber];
	}
}

-(void)refreshItemIndex
{
	for(int i=0; i<[giftThumbnails count]; i++)
	{
		GiftBoxThumbnailImageView *thumbnail=[giftThumbnails objectAtIndex:i];
		[thumbnail setIndex:i];
	}
}

-(void)refreshView
{
	for(int i=refreshStartIndex; i<[giftThumbnails count]; i++)
	{
		//setup image position
		GiftBoxThumbnailImageView *thumbnail=[giftThumbnails objectAtIndex:i];
		CGRect thumbnailFrame=CGRectMake(positionToSet.x, positionToSet.y, thumbnail.frame.size.width, thumbnail.frame.size.height);
		
		//set frame
		thumbnail.frame=thumbnailFrame;
		
		//calculate next position
		positionToSet=[self calculateNextPosition];
	}
	
	//refresh content size
	[self setupContentSize:[giftThumbnails count]];
}

-(void)destroy
{
	for(UIView *childView in [self subviews])
	{
		[childView removeFromSuperview];
	}
	
	[self.giftThumbnails removeAllObjects];
	
}


- (void)dealloc {
	
	//[giftThumbnails release];
	self.giftThumbnails=nil;
	self.sourceDataDelegate=nil;
	self.methodDelegate=nil;
	
    [super dealloc];
}


@end