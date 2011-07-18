//
//  MusicImageFront.m
//  AGiftPaid
//
//  Created by Nelson on 3/24/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import "MusicImageFront.h"
#import "MusicImageView.h"

@implementation MusicImageFront

@synthesize owner;


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		
		[self.layer setCornerRadius:10.0f];
		[self.layer setMasksToBounds:YES];
		
		[self setBackgroundColor:[UIColor clearColor]];
		[self setAlpha:1.0f];
		[self setUserInteractionEnabled:YES];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

-(void)deSelected
{
	/*
	[self setBackgroundColor:[UIColor clearColor]];
	[self setAlpha:1.0f];
	 */
	
	for(UIView *subView in self.subviews)
	{
		[subView removeFromSuperview];
	}
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{	
	[owner didSelected];
	
	/*
	[self setBackgroundColor:[UIColor grayColor]];
	[self setAlpha:0.5f];
	 */
	
	UIImageView *imageView=[[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Nike.png"]] autorelease];
	[imageView setFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
	
	[self addSubview:imageView];
}

- (void)dealloc {
	
	[owner release];
	
    [super dealloc];
}


@end
