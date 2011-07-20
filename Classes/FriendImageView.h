//
//  FriendImageView.h
//  AGiftPaid
//
//  Created by Nelson on 3/24/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendImage.h"
#import "FriendImageFront.h"
#import <QuartzCore/QuartzCore.h>

@class FriendGalleryScrollView;

@interface FriendImageView : UIView {
	
	FriendGalleryScrollView *owner;
	
	FriendImage *friendImagePresenter;
	
	FriendImageFront *frontImage;
	
	//friend name label
	UILabel *friendNameLabel;
	
	//friend number
	NSString *number;
	
	//index
	NSUInteger index;

}

@property (nonatomic, retain) FriendGalleryScrollView *owner;
@property (nonatomic, retain) FriendImage *friendImagePresenter;
@property (nonatomic, retain) FriendImageFront *frontImage;
@property (nonatomic, retain) UILabel *friendNameLabel;
@property (nonatomic, assign) NSUInteger index;
@property (nonatomic, retain) NSString *number;

-(void)assignFriendLabelName:(NSString*)friendName;
-(void)didSelected;
-(void)deSelected;
-(void)destroy;

@end
