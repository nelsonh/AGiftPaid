//
//  FriendController.h
//  AGiftPaid
//
//  Created by Nelson on 3/24/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendGalleryScrollView.h"
#import "AGiftWebService.h"
#import "GiftHistoryInfo.h"
#import <QuartzCore/QuartzCore.h>
#import "FriendHintController.h"

#define AreaCodeLimitation 3

@interface FriendController : UIViewController <UITextFieldDelegate ,UIAlertViewDelegate, AGiftWebServiceDelegate ,FriendGalleryScrollViewSourceDataDelegate, FriendGalleryScrollViewDelegate>{
	
	FriendGalleryScrollView *friendGalleryScrollView;
	UITextField *areaCodeTextField;
	UITextField *friendIDTextField;
	UIButton *addFriendButton;
	UIView *sendingGiftView;
	GiftHistoryInfo *historyInfo;
	UIImageView *naviTitleView;
	UIButton *deleteFriendButton;
	UIButton *sendGiftButton;
	UIButton *hintButton;
	FriendHintController *hintController;
	UIAlertView *sendSuccessAlert;
	UIAlertView *deleteFriendAlert;
	UIActionSheet *updatingView;
	
	NSMutableArray *scrollViewSourceData;
	
	//for anim effect only
	FriendInfo *animFriendInfo;
	
	int updateCount;
	BOOL updating;

}

@property (nonatomic, retain) IBOutlet FriendGalleryScrollView *friendGalleryScrollView;
@property (nonatomic, retain) IBOutlet UITextField *friendIDTextField;
@property (nonatomic, retain) IBOutlet UITextField *areaCodeTextField;
@property (nonatomic, retain) IBOutlet UIButton *addFriendButton;
@property (nonatomic, retain) IBOutlet UIView *sendingGiftView;
@property (nonatomic, retain) IBOutlet UIButton *deleteFriendButton;
@property (nonatomic, retain) IBOutlet UIButton *sendGiftButton;
@property (nonatomic, retain) IBOutlet UIButton *hintButton;
@property (nonatomic, retain) IBOutlet FriendHintController *hintController;
@property (nonatomic, retain) NSMutableArray *scrollViewSourceData;
@property (nonatomic, retain) GiftHistoryInfo *historyInfo;
@property (nonatomic, retain) UIImageView *naviTitleView;
@property (nonatomic, assign) FriendInfo *animFriendInfo;
@property (nonatomic, retain) UIAlertView *sendSuccessAlert;
@property (nonatomic, retain) UIAlertView *deleteFriendAlert;
@property (nonatomic, retain) UIActionSheet *updatingView;



-(IBAction)addFriendButtonPressed;
-(IBAction)doneWithFriendID;
-(IBAction)deleteFriendButtonPressed:(id)sender;
-(IBAction)sendGiftButtonPressed:(id)sender;
-(IBAction)hintButtonPress;

-(void)deleteFriend;
-(void)doDeleteFriend;
-(void)resignKeyboard;
-(void)assignInfoToPackage;
-(void)sendGiftOut;
-(void)disableHint;

@end