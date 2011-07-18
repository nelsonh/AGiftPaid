//
//  MusicImageFront.h
//  AGiftPaid
//
//  Created by Nelson on 3/24/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class MusicImageView;

@interface MusicImageFront : UIView {
	
	MusicImageView *owner;

}

@property (nonatomic, retain) MusicImageView *owner;

-(void)deSelected;

@end
