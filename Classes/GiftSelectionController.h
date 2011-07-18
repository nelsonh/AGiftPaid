//
//  GiftSelectionController.h
//  AGiftPaid
//
//  Created by Nelson on 3/22/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryMenuView.h"
#import "GiftGalleryScrollView.h"
#import "AGiftWebService.h"
#import <QuartzCore/QuartzCore.h>
#import "GiftSelectionHintController.h"

#define CategoryMenuStartX 400.0
#define CategoryMenuEndX -400.0

@interface GiftSelectionController : UIViewController <AGiftWebServiceDelegate, GiftGalleryScrollViewSourceDataDelegate, GiftGalleryScrollViewDelegate, CategoryScrollViewSourceDataDelegate, CategoryScrollViewDelegate>{
	
	GiftGalleryScrollView *giftGalleryScrollView;
	CategoryMenuView *categoryMenu;
	UIButton *categorySelectedButton;
	UIButton *confirmButton;
	NSUInteger currentCategory;
	float categoryMenuPresentXPos;
	UIImageView *naviTitleView;
	AGiftWebService *tempService;
	UIButton *hintButton;
	GiftSelectionHintController *hintController;
	
	//NSMutableDictionary *scrollviewSouceData;
	NSMutableArray *scrollviewSouceData;
	
	BOOL shouldReload;
}

@property (nonatomic, retain) IBOutlet GiftGalleryScrollView *giftGalleryScrollView;
@property (nonatomic, retain) IBOutlet CategoryMenuView *categoryMenu;
@property (nonatomic, retain) IBOutlet UIButton *categorySelectedButton;
@property (nonatomic, retain) IBOutlet UIButton *confirmButton;
@property (nonatomic, retain) IBOutlet UIButton *hintButton;
@property (nonatomic, retain) IBOutlet GiftSelectionHintController *hintController;
@property (nonatomic, retain) UIImageView *naviTitleView;

//@property (nonatomic, retain) NSMutableDictionary *scrollviewSouceData;
@property (nonatomic, retain) NSMutableArray *scrollviewSouceData;
@property (nonatomic, assign) NSUInteger currentCategory;
@property (nonatomic, assign) AGiftWebService *tempService;
@property (nonatomic, assign) BOOL shouldReload;

-(IBAction)categorySelectedButtonPressed;
-(IBAction)confirmButtonPressed:(id)sender;
-(IBAction)hintButtonPress;

-(void)changeCategoryWithIndex:(NSUInteger)index;
-(void)categoryMenuAnimationDidStop;

-(void)assignInfoToPackage;
-(void)nextView;
-(void)disableHint;


@end
