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
		friendImagePresenter=[[FriendImage alloc] initWithFrame:CGRectMake((self.frame.size.width-54)/2, 0, 54, 54)];
		[friendImagePresenter setOwner:self];
		
		//create label
		friendNameLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 54, frame.size.width, 10)];
		[friendNameLabel setFont:[UIFont systemFontOfSize:10]];
		[friendNameLabel setTextAlignment:UITextAlignmentCenter];
		[friendNameLabel setBackgroundColor:[UIColor clearColor]];
		
		//create front image
		frontImage=[[FriendImageFront alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
		[frontImage setOwner:self];
		
		
		[self addSubview:friendImagePresenter];
		[self addSubview:friendNameLabel];
		[self addSubview:frontImage];
    }
    return self;
}

-(void)assignFriendLabelName:(NSString*)friendName
{
	[friendNameLabel setText:friendName];
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
	[frontImage deSelected];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
	
	[owner release];
	[friendImagePresenter release];
	[frontImage release];
	[friendNameLabel release];
	[number release];
	
    [super dealloc];
}


@end
