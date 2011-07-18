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
		recordImagePresenter=[[RecordImage alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 54)];
		[recordImagePresenter setOwner:self];
		
		//create label
		recordNameLabel=[[UILabel alloc] initWithFrame:CGRectMake(0, 54, frame.size.width, 10)];
		[recordNameLabel setFont:[UIFont systemFontOfSize:10]];
		[recordNameLabel setTextAlignment:UITextAlignmentCenter];
		[recordNameLabel setBackgroundColor:[UIColor clearColor]];
		[recordNameLabel setText:@"CustomMusic"];
		
		//create front image
		frontImage=[[RecordImageFront alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
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

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
	
	[recordImagePresenter release];
	[frontImage release];
	[recordNameLabel release];
	
    [super dealloc];
}


@end
