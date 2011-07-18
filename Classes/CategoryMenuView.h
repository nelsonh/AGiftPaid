//
//  CategoryMenuView.h
//  AGiftPaid
//
//  Created by Nelson on 3/22/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#define kHeightSpace 10
#define kWidthSpace 20
#define kItemHeight 37
#define kItemWidth 240
#define kColoumnItems 5

@protocol CategoryScrollViewSourceDataDelegate, CategoryScrollViewDelegate;

@class GiftSelectionController;

@interface CategoryMenuView : UIScrollView {
	
	GiftSelectionController *owner;
	NSMutableArray *categoryButtonContainer;
	CGPoint positionToSet;
	NSUInteger totalItem;
	
	id<CategoryScrollViewSourceDataDelegate> sourceDataDelegate;
	id<CategoryScrollViewDelegate> methodDelegate;

}

@property (nonatomic, retain) NSMutableArray *categoryButtonContainer;
@property (nonatomic, assign) IBOutlet GiftSelectionController *owner;
@property (nonatomic, assign) IBOutlet id<CategoryScrollViewSourceDataDelegate> sourceDataDelegate;
@property (nonatomic, assign) IBOutlet id<CategoryScrollViewDelegate> methodDelegate;

-(void)initialize;
-(void)setupContentSize:(NSUInteger)numberOfItem;
-(CGPoint)calculateNextPosition;
-(void)selectItemWithIndex:(NSInteger)selectedIndex;
-(void)categoryButtonSelected:(id)sender;

@end



@protocol CategoryScrollViewDelegate<NSObject>

-(void)CategoryScrollView:(CategoryMenuView*)categoryGalleryScrollView didSelectItemWithNumber:(NSString*)number;

@end

@protocol CategoryScrollViewSourceDataDelegate<NSObject>

-(NSUInteger)numberOfItemInContentWithCategoryScrollView:(CategoryMenuView*)categoryGalleryScrollView;
-(NSString*)CategoryScrollView:(CategoryMenuView*)categoryGalleryScrollView categoryNameForIndex:(NSUInteger)index;

@end