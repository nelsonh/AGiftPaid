//
//  MusicSelectionHintController.h
//  AGiftPaid
//
//  Created by Nelson on 5/24/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MusicSelectionHintController : UIViewController {
	
	UIButton *closeButton;
	UIButton *customSoundHintButton;
	UIButton *soundControllerHintButton;
	UIButton *buildinSoundHintButton;
	UITextView *customSoundHintTextView;
	UITextView *soundControllerHintTextView;
	UITextView *buildinSoundHintTextView;
}

@property (nonatomic, retain) IBOutlet UIButton *closeButton;
@property (nonatomic, retain) IBOutlet UIButton *customSoundHintButton;
@property (nonatomic, retain) IBOutlet UIButton *soundControllerHintButton;
@property (nonatomic, retain) IBOutlet UIButton *buildinSoundHintButton;
@property (nonatomic, retain) IBOutlet UITextView *customSoundHintTextView;
@property (nonatomic, retain) IBOutlet UITextView *soundControllerHintTextView;
@property (nonatomic, retain) IBOutlet UITextView *buildinSoundHintTextView;

-(IBAction)closeButtonPress;
-(IBAction)customSoundHintButtonPress;
-(IBAction)soundControllerHintButtonPress;
-(IBAction)buildinSoundHintButtonPress;
-(void)reset;

@end
