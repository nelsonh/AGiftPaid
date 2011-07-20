//
//  MusicImageView.m
//  AGiftPaid
//
//  Created by Nelson on 3/23/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import "MusicImageView.h"
#import "MusicGalleryScrollView.h"


@implementation MusicImageView

@synthesize owner;
@synthesize musicImagePresenter;
@synthesize frontImage;
@synthesize musicNameLabel;
@synthesize index;
@synthesize number;


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		
		//[self.layer setCornerRadius:10.0f];
		//[self.layer setMasksToBounds:YES];
		
		//create music image preseter
		self.musicImagePresenter=[[[MusicImage alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 54)] autorelease];
		[musicImagePresenter setOwner:self];
		
		//create label
		self.musicNameLabel=[[[UILabel alloc] initWithFrame:CGRectMake(0, 54, frame.size.width, 10)] autorelease];
		[musicNameLabel setFont:[UIFont systemFontOfSize:10]];
		[musicNameLabel setTextAlignment:UITextAlignmentCenter];
		[musicNameLabel setBackgroundColor:[UIColor clearColor]];
		
		//create front image
		self.frontImage=[[[MusicImageFront alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)] autorelease];
		[frontImage setOwner:self];
		
		[self addSubview:musicImagePresenter];
		[self addSubview:musicNameLabel];
		[self addSubview:frontImage];
    }
    return self;
}

-(void)assignMusicFileName:(NSString*)fileName
{
	[musicNameLabel setText:fileName];
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

-(void)destroy
{
	for(UIView *childView in [self subviews])
	{
		[childView removeFromSuperview];
	}
	
	self.musicImagePresenter=nil;
	self.musicNameLabel=nil;
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
	
	self.owner=nil;
	//[owner release];
	//[musicImagePresenter release];
	//[frontImage release];
	//[number release];
	self.number=nil;
	//[musicNameLabel release];
	self.musicImagePresenter=nil;
	self.frontImage=nil;
	self.musicNameLabel=nil;
	self.number=nil;
	
    [super dealloc];
}


@end
