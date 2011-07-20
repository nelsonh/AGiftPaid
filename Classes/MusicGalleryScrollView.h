//
//  MusicGalleryScrollView.h
//  AGiftPaid
//
//  Created by Nelson on 3/23/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kSpace 5
#define kItemSize 64
#define kRowItem 4

@protocol MusicGalleryScrollViewSourceDataDelegate, MusicGalleryScrollViewDelegate;

@class MusicImageView;

@interface MusicGalleryScrollView : UIScrollView {
	
	//hold images 
	NSMutableArray *musicThumbnails;
	CGPoint positionToSet;
	NSUInteger refreshStartIndex;
	NSUInteger totalItem;
	MusicImageView *lastSelectedIcon;
	
	id<MusicGalleryScrollViewSourceDataDelegate> sourceDataDelegate;
	id<MusicGalleryScrollViewDelegate> methodDelegate;

}

@property (nonatomic, retain) NSMutableArray *musicThumbnails;
@property (nonatomic, assign) IBOutlet id<MusicGalleryScrollViewSourceDataDelegate> sourceDataDelegate;
@property (nonatomic, assign) IBOutlet id<MusicGalleryScrollViewDelegate> methodDelegate;
@property (nonatomic, assign) MusicImageView *lastSelectedIcon;

-(void)initialize;

-(void)setupContentSize:(NSUInteger)numberOfItem;
-(CGPoint)calculateNextPosition;
-(void)selectItemWithIndex:(NSUInteger)index;
-(void)refreshItemIndex;
-(void)refreshView;
-(void)reset;
-(void)deSelectLastIcon;
-(void)destroy;

@end

@protocol MusicGalleryScrollViewDelegate<NSObject>

-(void)GalleryScrollView:(MusicGalleryScrollView*)musicGalleryScrollView didSelectItemWithIndex:(NSUInteger)index;

@end

@protocol MusicGalleryScrollViewSourceDataDelegate<NSObject>

-(NSUInteger)numberOfItemInContentWithMusicGalleryScrollView:(MusicGalleryScrollView*)musicGalleryScrollView;
-(MusicImageView*)GalleryScrollView:(MusicGalleryScrollView*)musicGalleryScrollView musicIconViewForIndex:(NSUInteger)index;

@end
