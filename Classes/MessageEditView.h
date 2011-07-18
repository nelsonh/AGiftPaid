//
//  MessageEditView.h
//  AGiftPaid
//
//  Created by Nelson on 3/23/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MessageEditView : UIView {
	
	UIButton *DoneButton;
	UITextView *editTextView;
	UITextView *inputTextView;

}

@property (nonatomic, retain) IBOutlet UIButton *DoneButton;
@property (nonatomic, retain) IBOutlet UITextView *editTextView;
@property (nonatomic, assign) UITextView *inputTextView;

-(IBAction)DoneButtonPressed;
-(void)assignInputTextView:(UITextView*)inTextView;

@end
