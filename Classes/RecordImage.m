//
//  RecordImage.m
//  AGiftPaid
//
//  Created by Nelson on 4/18/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import "RecordImage.h"
#import "RecordImageView.h"



@implementation RecordImage

@synthesize owner;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		
		[self.layer setCornerRadius:10.0f];
		[self.layer setMasksToBounds:YES];
		
		[self setImage:[UIImage imageNamed:@"Sonar.png"]];
    }
    return self;
}

- (void)dealloc {
	
	[owner release];
    [super dealloc];
}

@end
