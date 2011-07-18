//
//  HistoryHintController.h
//  AGiftPaid
//
//  Created by Nelson on 5/24/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@interface HistoryHintController : UIViewController {
	
	UIButton *closeButton;
	UIButton *updateHintButton;
	UIButton *historyHintButton;
	UITextView *updateHintTextView;
	UITextView *historyHintTextView;
	UIView *iconExpHintView;

}

@property (nonatomic, retain) IBOutlet UIButton *closeButton;
@property (nonatomic, retain) IBOutlet UIButton *updateHintButton;
@property (nonatomic, retain) IBOutlet UIButton *historyHintButton;
@property (nonatomic, retain) IBOutlet UITextView *updateHintTextView;
@property (nonatomic, retain) IBOutlet UITextView *historyHintTextView;
@property (nonatomic, retain) IBOutlet UIView *iconExpHintView;

-(IBAction)closeButtonPress;
-(IBAction)updateHintButtonPress;
-(IBAction)historyHintButtonPress;
-(void)reset;

@end
