//
//  GiftBoxSelectionController.h
//  AGiftPaid
//
//  Created by Nelson on 3/21/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GiftBoxGalleryScrollView.h"
#import "AGiftWebService.h"
#import <QuartzCore/QuartzCore.h>
#import "GiftBoxSelectionHintController.h"

@interface GiftBoxSelectionController : UIViewController <GiftBoxGalleryScrollViewDelegate, GiftBoxGalleryScrollViewSourceDataDelegate, AGiftWebServiceDelegate>{
	
	GiftBoxGalleryScrollView *boxGalleryScrollView;
	UIImageView *naviTitleView;
	UIButton *hintButton;
	GiftBoxSelectionHintController *hintController;
	
	NSArray *scrollviewSouceData;
	
	BOOL shouldReload;
}

@property (nonatomic, retain) IBOutlet GiftBoxGalleryScrollView *boxGalleryScrollView;
@property (nonatomic, retain) IBOutlet UIButton *hintButton;
@property (nonatomic, retain) IBOutlet GiftBoxSelectionHintController *hintController;
@property (nonatomic, retain) UIImageView *naviTitleView;
@property (nonatomic, retain) NSArray *scrollviewSouceData;
@property (nonatomic, assign) BOOL shouldReload;

-(IBAction)confirmButtonPressed:(id)sender;
-(IBAction)hintButtonPress;

-(void)nextView;
-(void)assignInfoToPackage;
-(void)disableHint;

@end
