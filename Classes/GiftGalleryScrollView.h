//
//  GiftGalleryScrollView.h
//  AGiftPaid
//
//  Created by Nelson on 3/22/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kSpace 5
#define kItemSize 64
#define kRowItem 4

@protocol GiftGalleryScrollViewSourceDataDelegate, GiftGalleryScrollViewDelegate;

@class GiftThumbnailImageView;


@interface GiftGalleryScrollView : UIScrollView {
	
	//hold images 
	NSMutableArray *giftThumbnails;
	CGPoint positionToSet;
	NSUInteger refreshStartIndex;
	NSUInteger totalItem;
	GiftThumbnailImageView *lastSelectedIcon;
	
	id<GiftGalleryScrollViewSourceDataDelegate> sourceDataDelegate;
	id<GiftGalleryScrollViewDelegate> methodDelegate;
}

@property (nonatomic, retain) NSMutableArray *giftThumbnails;
@property (nonatomic, assign) IBOutlet id<GiftGalleryScrollViewSourceDataDelegate> sourceDataDelegate;
@property (nonatomic, assign) IBOutlet id<GiftGalleryScrollViewDelegate> methodDelegate;
@property (nonatomic, assign) GiftThumbnailImageView *lastSelectedIcon;

-(void)initialize;

-(void)setupContentSize:(NSUInteger)numberOfItem;
-(CGPoint)calculateNextPosition;
-(void)selectItemWithNumber:(NSString*)imageNumber;
-(void)refreshItemIndex;
-(void)refreshView;
-(void)reset;

@end

@protocol GiftGalleryScrollViewDelegate<NSObject>

-(void)GalleryScrollView:(GiftGalleryScrollView*)giftGalleryScrollView didSelectItemWithNumber:(NSString*)number;

@end

@protocol GiftGalleryScrollViewSourceDataDelegate<NSObject>

-(NSUInteger)numberOfItemInContentWithGiftGalleryScrollView:(GiftGalleryScrollView*)giftGalleryScrollView;
-(GiftThumbnailImageView*)GalleryScrollView:(GiftGalleryScrollView*)giftGalleryScrollView giftIconViewForIndex:(NSUInteger)index;

@end
