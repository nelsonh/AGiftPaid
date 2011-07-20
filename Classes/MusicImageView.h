//
//  MusicImageView.h
//  AGiftPaid
//
//  Created by Nelson on 3/23/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MusicImage.h"
#import "MusicImageFront.h"
#import <QuartzCore/QuartzCore.h>

@class MusicGalleryScrollView;

@interface MusicImageView : UIView {
	
	MusicGalleryScrollView *owner;
	
	MusicImage *musicImagePresenter;
	
	MusicImageFront *frontImage;
	
	//music name label
	UILabel *musicNameLabel;
	
	//music number
	NSString *number;
	
	//index
	NSUInteger index;
}

@property (nonatomic, retain) MusicGalleryScrollView *owner;
@property (nonatomic, retain) MusicImage *musicImagePresenter;
@property (nonatomic, retain) MusicImageFront *frontImage;
@property (nonatomic, retain) UILabel *musicNameLabel;
@property (nonatomic, assign) NSUInteger index;
@property (nonatomic, retain) NSString *number;

-(void)assignMusicFileName:(NSString*)fileName;
-(void)didSelected;
-(void)deSelected;
-(void)destroy;

@end
