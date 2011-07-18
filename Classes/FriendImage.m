//
//  FriendImage.m
//  AGiftPaid
//
//  Created by Nelson on 3/24/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import "FriendImage.h"
#import "FriendImageView.h"

@implementation FriendImage

@synthesize owner;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		[self.layer setCornerRadius:10.0f];
		[self.layer setMasksToBounds:YES];
	
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
