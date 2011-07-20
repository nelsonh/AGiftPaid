//
//  RecordImageView.m
//  AGiftPaid
//
//  Created by Nelson on 4/18/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import "RecordImageView.h"
#import "MusicGalleryScrollView.h"
#import "RecordImage.h"
#import "MusicSelectionController.h"

@implementation RecordImageView

@synthesize owner;
@synthesize mainController;
@synthesize recordImagePresenter;
@synthesize frontImage;
@synthesize recordNameLabel;
@synthesize index;
@synthesize isSelected;



- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		
		[self.layer setCornerRadius:10.0f];
		[self.layer setMasksToBounds:YES];
		
		//create music image preseter
		self.recordImagePresenter=[[[RecordImage alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 54)] autorelease];
		[recordImagePresenter setOwner:self];
		
		//create label
		self.recordNameLabel=[[[UILabel alloc] initWithFrame:CGRectMake(0, 54, frame.size.width, 10)] autorelease];
		[recordNameLabel setFont:[UIFont systemFontOfSize:10]];
		[recordNameLabel setTextAlignment:UITextAlignmentCenter];
		[recordNameLabel setBackgroundColor:[UIColor clearColor]];
		[recordNameLabel setText:@"CustomMusic"];
		
		//create front image
		self.frontImage=[[[RecordImageFront alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)] autorelease];
		[frontImage setOwner:self];
		
		[self addSubview:recordImagePresenter];
		[self addSubview:recordNameLabel];
		[self addSubview:frontImage];
    }
    return self;
}

-(void)didSelected
{	
	self.isSelected=YES;
	[owner.lastSelectedIcon deSelected];
	[owner setLastSelectedIcon:nil];
	

	if(mainController)
	{
		if([[NSFileManager defaultManager] fileExistsAtPath:mainController.recordFilePath])
		{
			//play record sound
			[mainController playMusicWithPath:mainController.recordFilePath];
		}
	}
}

-(void)deSelected
{
	self.isSelected=NO;
	[frontImage deSelected];
}

-(void)destroy
{
	for(UIView *childView in [self subviews])
	{
		[childView removeFromSuperview];
	}
	
	self.recordImagePresenter=nil;
	self.recordNameLabel=nil;
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
	
	self.recordImagePresenter=nil;
	self.frontImage=nil;
	self.recordNameLabel=nil;
	//[recordImagePresenter release];
	//[frontImage release];
	//[recordNameLabel release];
	
    [super dealloc];
}


@end
