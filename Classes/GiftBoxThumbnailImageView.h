//
//  GiftImageView.h
//  AGiftFree
//
//  Created by Nelson on 2/23/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GiftBoxGalleryScrollView;

@interface GiftBoxThumbnailImageView : UIImageView {
	
	//the scroll view that own this image view
	GiftBoxGalleryScrollView *owner;
	
	//thumbial image name
	NSString *thumbnailImageURL;
	
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
	
	//image data
	NSMutableData *imageData;
	
	//connection
	NSURLConnection *downloadConnection;
	
}

@property (nonatomic, retain) GiftBoxGalleryScrollView *owner;
@property (nonatomic, retain) NSString *thumbnailImageURL;
@property (nonatomic, retain) UIActivityIndicatorView *loadingActivityView;
@property (nonatomic, retain) UIImageView *checkIcon;
@property (nonatomic, retain) NSString *number;
@property (nonatomic, assign) NSUInteger index;
@property (nonatomic, assign) BOOL isDownloading;
@property (nonatomic, retain) NSMutableData *imageData;
@property (nonatomic, assign)NSURLConnection *downloadConnection;

-(id)initWithFrame:(CGRect)frame WithURL:(NSString*)iconURL;
-(void)getIconWithURL:(NSString*)iconURL;
-(void)removeCheck;
-(void)didCheck;
-(void)doubleTap;

@end
