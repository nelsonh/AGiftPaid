//
//  FriendImageView.m
//  AGiftPaid
//
//  Created by Nelson on 3/24/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import "FriendImageView.h"
#import "FriendGalleryScrollView.h"


@implementation FriendImageView

@synthesize owner;
@synthesize friendImagePresenter;
@synthesize frontImage;
@synthesize friendNameLabel;
@synthesize index;
@synthesize number;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		
		//[self.layer setCornerRadius:10.0f];
		//[self.layer setMasksToBounds:YES];
		
		//create friend image preseter
		self.friendImagePresenter=[[[FriendImage alloc] initWithFrame:CGRectMake((self.frame.size.width-54)/2, 0, 54, 54)] autorelease];
		[self.friendImagePresenter setOwner:self];
		
		//create label
		self.friendNameLabel=[[[UILabel alloc] initWithFrame:CGRectMake(0, 54, frame.size.width, 10)] autorelease];
		[friendNameLabel setFont:[UIFont systemFontOfSize:10]];
		[friendNameLabel setTextAlignment:UITextAlignmentCenter];
		[friendNameLabel setBackgroundColor:[UIColor clearColor]];
		
		//create front image
		self.frontImage=[[[FriendImageFront alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)] autorelease];
		[frontImage setOwner:self];
		
		
		[self addSubview:self.friendImagePresenter];
		[self addSubview:self.friendNameLabel];
		[self addSubview:self.frontImage];
		
    }
    return self;
}

-(void)assignFriendLabelName:(NSString*)friendName
{
	[self.friendNameLabel setText:friendName];
}

-(void)didSelected
{
	if(owner.lastSelectedIcon==nil)
	{
		[owner setLastSelectedIcon:self];
	}
	else 
	{
		[owner.lastSelectedIcon deSelected];
		[owner setLastSelectedIcon:self];
	}
	
	[owner selectItemWithIndex:self.index];
}

-(void)deSelected
{
	[self.frontImage deSelected];
}

-(void)destroy
{
	for(UIView *childView in [self subviews])
	{
		[childView removeFromSuperview];
	}
	
	self.friendImagePresenter=nil;
	self.friendNameLabel=nil;
	self.frontImage=nil;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
	
	//[owner release];
	self.owner=nil;
	//[friendImagePresenter release];
	//[frontImage release];
	//[friendNameLabel release];
	//[number release];
	self.number=nil;
	self.friendImagePresenter=nil;
	self.frontImage=nil;
	self.friendNameLabel=nil;
	
    [super dealloc];
}


@end
