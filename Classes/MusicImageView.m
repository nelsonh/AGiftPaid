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
		musicImagePresenter=[[MusicImage alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 54)];
		[musicImagePresenter setOwner:self];
		
		//create label
		musicNameLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 54, frame.size.width, 10)];
		[musicNameLabel setFont:[UIFont systemFontOfSize:10]];
		[musicNameLabel setTextAlignment:UITextAlignmentCenter];
		[musicNameLabel setBackgroundColor:[UIColor clearColor]];
		
		//create front image
		frontImage=[[MusicImageFront alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
	
	[owner release];
	[musicImagePresenter release];
	[frontImage release];
	[number release];
	[musicNameLabel release];
	[number release];
	
    [super dealloc];
}


@end
