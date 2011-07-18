//
//  MessageController.h
//  AGiftPaid
//
//  Created by Nelson on 3/23/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BeforeMessageView.h"
#import "AfterMessageView.h"
#import <QuartzCore/QuartzCore.h>
#import "MessageHintController.h"

@interface MessageController : UIViewController <UITextViewDelegate>{
	
	UISwitch *anonymousSwitcher;
	UIButton *onBoxButton;
	UIButton *onGiftButton;
	UISegmentedControl *segmentedControl;
	BeforeMessageView *beforeMsgView;
	AfterMessageView *afterMsgView;
	UIImageView *naviTitleView;
	NSArray *viewContainer;
	UIButton *hintButton;
	MessageHintController *hintController;
	
	UIView *currentView;
}

@property (nonatomic, retain) IBOutlet UISwitch *anonymousSwitcher;
@property (nonatomic, retain) IBOutlet UIButton *onBoxButton;
@property (nonatomic, retain) IBOutlet UIButton *onGiftButton;
@property (nonatomic, retain) IBOutlet BeforeMessageView *beforeMsgView;
@property (nonatomic, retain) IBOutlet AfterMessageView *afterMsgView;
@property (nonatomic, retain) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, retain) IBOutlet UIButton *hintButton;
@property (nonatomic, retain) IBOutlet MessageHintController *hintController;
@property (nonatomic, retain) UIImageView *naviTitleView;
@property (nonatomic, retain) NSArray *viewContainer;
@property (nonatomic, assign) UIView *currentView;


-(IBAction)onBoxButtonPressed;
-(IBAction)onGiftButtonPressed;
-(IBAction)confirmButtonPressed:(id)sender;
-(IBAction)segmentedControlChanged:(id)sender;
-(IBAction)hintButtonPress;

-(void)resignKeyBoard;
-(void)assignInfoToPackage;
-(void)nextView;
-(void)slideAnimationDidFinish;
-(void)disableHint;
-(void)afterMsgTextViewTapped;
-(void)beforeMsgTextViewTapped;
-(void)moveViewUpAnim;
-(void)moveViewDownAnim;

@end
