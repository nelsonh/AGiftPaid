//
//  MessageEditViewController.h
//  AGiftPaid
//
//  Created by Nelson on 5/4/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MessageEditViewController : UIViewController {
	
	UIButton *DoneButton;
	UITextView *editTextView;
	UITextView *inputTextView;
	UIImageView *borderImageView;
	UIDeviceOrientation lastOrientation;

}

@property (nonatomic, retain) IBOutlet UIButton *DoneButton;
@property (nonatomic, retain) IBOutlet UITextView *editTextView;
@property (nonatomic, retain) IBOutlet UIImageView *borderImageView;
@property (nonatomic, assign) UITextView *inputTextView;
@property (nonatomic, assign) UIDeviceOrientation lastOrientation;

-(IBAction)DoneButtonPressed;
-(void)assignInputTextView:(UITextView*)inTextView;
-(void)deviceDidRotate:(NSNotification*)notification;

@end
