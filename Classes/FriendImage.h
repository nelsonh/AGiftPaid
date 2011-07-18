//
//  FriendImage.h
//  AGiftPaid
//
//  Created by Nelson on 3/24/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FriendImageView;

@interface FriendImage : UIImageView {
	
	FriendImageView *owner;
	
	NSString *friendPhotoURL;
}

@property (nonatomic, retain) FriendImageView *owner;

@end
