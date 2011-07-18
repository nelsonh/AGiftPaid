//
//  GiftThumbnailImageView.h
//  AGiftPaid
//
//  Created by Nelson on 3/22/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GiftGalleryScrollView;

@interface GiftThumbnailImageView : UIImageView {
	
	//the scroll view that own this image view
	GiftGalleryScrollView *owner;
	
	//loading indicator
	UIActivityIndicatorView *loadingActivityView;
	
	//check indicator
	UIImageView *checkIcon;
	
	//number
	NSString *number;
	
	//index
	NSUInteger index;
	
	//is downloading icon
	BOOL isDownloading;
	
}

@property (nonatomic, retain) GiftGalleryScrollView *owner;
@property (nonatomic, retain) UIActivityIndicatorView *loadingActivityView;
@property (nonatomic, retain) UIImageView *checkIcon;
@property (nonatomic, retain) NSString *number;
@property (nonatomic, assign) NSUInteger index;
@property (nonatomic, assign) BOOL isDownloading;

-(void)removeCheck;
-(void)didCheck;
-(void)startDownloadIndicator;
-(void)stopDownloadIndicator;
-(void)doubleTap;

@end
