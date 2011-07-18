//
//  MusicImage.m
//  AGiftPaid
//
//  Created by Nelson on 3/23/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import "MusicImage.h"
#import "MusicImageView.h"

@implementation MusicImage

@synthesize owner;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		
		[self.layer setCornerRadius:10.0f];
		[self.layer setMasksToBounds:YES];
		
		[self setImage:[UIImage imageNamed:@"Music1.png"]];
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

- (void)dealloc {
	
	[owner release];
    [super dealloc];
}


@end
