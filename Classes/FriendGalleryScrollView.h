//
//  FriendGalleryScrollView.h
//  AGiftPaid
//
//  Created by Nelson on 3/24/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kSpace 5
#define kItemSize 64
#define kRowItem 4

@protocol FriendGalleryScrollViewSourceDataDelegate, FriendGalleryScrollViewDelegate;

@class FriendImageView;

@interface FriendGalleryScrollView : UIScrollView {
	
	//hold images 
	NSMutableArray *friendThumbnails;
	CGPoint positionToSet;
	NSUInteger refreshStartIndex;
	NSUInteger totalItem;
	FriendImageView *lastSelectedIcon;
	
	id<FriendGalleryScrollViewSourceDataDelegate> sourceDataDelegate;
	id<FriendGalleryScrollViewDelegate> methodDelegate;

}

@property (nonatomic, retain) NSMutableArray *friendThumbnails;
@property (nonatomic, assign) IBOutlet id<FriendGalleryScrollViewSourceDataDelegate> sourceDataDelegate;
@property (nonatomic, assign) IBOutlet id<FriendGalleryScrollViewDelegate> methodDelegate;
@property (nonatomic, assign) FriendImageView *lastSelectedIcon;

-(void)initialize;

-(void)setupContentSize:(NSUInteger)numberOfItem;
-(CGPoint)calculateNextPosition;
-(void)selectItemWithIndex:(NSUInteger)index;
-(void)refreshItemIndex;
-(void)refreshView;
-(void)reset;
-(void)addfriendPhoto:(FriendImageView*)friendIcon;

@end

@protocol FriendGalleryScrollViewDelegate<NSObject>

-(void)GalleryScrollView:(FriendGalleryScrollView*)friendGalleryScrollView didSelectItemWithIndex:(NSUInteger)index;
-(void)GalleryScrollViewDidFinishInit:(FriendGalleryScrollView*)friendGalleryScrollView;

@end

@protocol FriendGalleryScrollViewSourceDataDelegate<NSObject>

-(NSUInteger)numberOfItemInContentWithFriendGalleryScrollView:(FriendGalleryScrollView*)friendGalleryScrollView;
-(FriendImageView*)GalleryScrollView:(FriendGalleryScrollView*)friendGalleryScrollView friendIconViewForIndex:(NSUInteger)index;

@end