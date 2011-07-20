//
//  GiftGalleryScrollView.h
//  AGiftFree
//
//  Created by Nelson on 2/23/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


#define kSpace 5
#define kItemSize 64
#define kRowItem 4

@protocol GiftBoxGalleryScrollViewSourceDataDelegate, GiftBoxGalleryScrollViewDelegate;

@class GiftBoxThumbnailImageView;

@interface GiftBoxGalleryScrollView : UIScrollView {
	
	//hold images 
	NSMutableArray *giftThumbnails;
	CGPoint positionToSet;
	NSUInteger refreshStartIndex;
	NSUInteger totalItem;
	GiftBoxThumbnailImageView *lastSelectedIcon;
	
	id<GiftBoxGalleryScrollViewSourceDataDelegate> sourceDataDelegate;
	id<GiftBoxGalleryScrollViewDelegate> methodDelegate;
}

@property (nonatomic, retain) NSMutableArray *giftThumbnails;
@property (nonatomic, assign) IBOutlet id<GiftBoxGalleryScrollViewSourceDataDelegate> sourceDataDelegate;
@property (nonatomic, assign) IBOutlet id<GiftBoxGalleryScrollViewDelegate> methodDelegate;
@property (nonatomic, assign) GiftBoxThumbnailImageView *lastSelectedIcon;

-(void)initialize;

-(void)setupContentSize:(NSUInteger)numberOfItem;
-(CGPoint)calculateNextPosition;
-(void)selectItemWithNumber:(NSString*)imageNumber;
-(void)refreshItemIndex;
-(void)refreshView;
-(void)destroy;
@end

@protocol GiftBoxGalleryScrollViewDelegate<NSObject>

-(void)GalleryScrollView:(GiftBoxGalleryScrollView*)giftGalleryScrollView didSelectItemWithNumber:(NSString*)number;

@end

@protocol GiftBoxGalleryScrollViewSourceDataDelegate<NSObject>

-(NSUInteger)numberOfItemInContentWithGiftGalleryScrollView:(GiftBoxGalleryScrollView*)giftGalleryScrollView;
-(NSString*)GalleryScrollView:(GiftBoxGalleryScrollView*)giftGalleryScrollView giftImageURLForIndex:(NSUInteger)index;
-(NSUInteger)GalleryScrollView:(GiftBoxGalleryScrollView*)giftGalleryScrollView giftBoxIconNumberForIndex:(NSUInteger)index;

@end