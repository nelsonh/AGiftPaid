//
//  Viewer3DGiftController.h
//  AGiftPaid
//
//  Created by Nelson on 3/23/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLView.h"
#import "AGiftWebService.h"
#import "GiftViewerHintController.h"
#import <MediaPlayer/MediaPlayer.h>


@interface Viewer3DGiftController : UIViewController <GLViewDelegate, AGiftWebServiceDelegate>{
	
	UIView *openGLESReferenceView;
	UIButton *closeButton;
	UIView *downloadingView;
	UIView *load3DView;
	RenderingEngine *modelRenderingEngine;
	NSString *giftNumber;
	NSString *giftPrefix;
	NSString *materialName;
	UIButton *hintButton;
	UIButton *playVideoButton;
	GiftViewerHintController *hintController;
	NSString *videoURL;
	
	BOOL isDismissed;
	BOOL shouldReleaseEngine;

}

@property (nonatomic, retain) IBOutlet UIView *openGLESReferenceView;
@property (nonatomic, retain) IBOutlet UIButton *closeButton;
@property (nonatomic, retain) IBOutlet UIView *downloadingView;
@property (nonatomic, retain) IBOutlet UIView *load3DView;
@property (nonatomic, retain) IBOutlet UIButton *hintButton;
@property (nonatomic, retain) IBOutlet GiftViewerHintController *hintController;
@property (nonatomic, retain) IBOutlet UIButton *playVideoButton;
@property (nonatomic, retain) RenderingEngine *modelRenderingEngine;
@property (nonatomic, retain) NSString *giftNumber;
@property (nonatomic, retain) NSString *giftPrefix;
@property (nonatomic, retain) NSString *materialName;
@property (nonatomic, retain) NSString *videoURL;
@property (nonatomic, assign) BOOL isDismissed;
@property (nonatomic, assign) BOOL shouldReleaseEngine;

-(IBAction)closeButtonPressed;
-(IBAction)hintButtonPress;
-(IBAction)playVideoButtonPress;

-(void)initRenderingEngine;
-(void)disableHint;

@end
