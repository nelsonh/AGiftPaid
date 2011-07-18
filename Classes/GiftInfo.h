//
//  GiftInfo.h
//  AGiftPaid
//
//  Created by Nelson on 3/23/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GiftThumbnailImageView.h"

#define kImageSize 64

@interface GiftInfo : NSObject {
	
	//thumbial image URL
	NSString *thumbnailImageURL;
	
	//thumbial data
	NSMutableData *imageData;
	
	//number
	NSUInteger giftNumber;
	
	GiftThumbnailImageView *giftIconPresenter;
	
	NSURLConnection *downloadConnection;

}

@property (nonatomic, retain) NSString *thumbnailImageURL;
@property (nonatomic, retain) NSMutableData *imageData;
@property (nonatomic, assign) NSUInteger giftNumber;
@property (nonatomic, retain) GiftThumbnailImageView *giftIconPresenter;
@property (nonatomic, assign) NSURLConnection *downloadConnection;

-(void)assignNumber:(NSUInteger)number;
-(void)loadImage;

@end
