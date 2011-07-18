//
//  GiftTimeSelectionController.h
//  AGiftPaid
//
//  Created by Nelson on 3/22/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "GiftTimeSelectionHintController.h"


@interface GiftTimeSelectionController : UIViewController {
	
	UISwitch *openTimeSwitch;
	UIDatePicker *openDatePicker;
	NSDate *pickedDateTime;
	UIImageView *naviTitleView;
	UIButton *hintButton;
	GiftTimeSelectionHintController *hintController;
	
	
}

@property (nonatomic, retain) IBOutlet UISwitch *openTimeSwitch;
@property (nonatomic, retain) IBOutlet UIDatePicker *openDatePicker;
@property (nonatomic, retain) IBOutlet UIButton *hintButton;
@property (nonatomic, retain) IBOutlet GiftTimeSelectionHintController *hintController;
@property (nonatomic, retain) UIImageView *naviTitleView;


-(IBAction)openTimeSwitchChange:(id)sender;
-(IBAction)confirmButtonPressed:(id)sender;
-(IBAction)hintButtonPress;

-(void)toggleDateTimePicker:(BOOL)onOff;
-(void)assignInfoToPackage;
-(void)nextView;
-(void)disableHint;


@end
