//
//  FriendImageFront.h
//  AGiftPaid
//
//  Created by Nelson on 3/24/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class FriendImageView;


@interface FriendImageFront : UIView {
	
	FriendImageView *owner;

}

@property (nonatomic, retain) FriendImageView *owner;

-(void)deSelected;

@end
