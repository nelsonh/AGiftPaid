//
//  MessageHintController.h
//  AGiftPaid
//
//  Created by Nelson on 5/24/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MessageHintController : UIViewController {
	
	UIButton *closeButton;
	UIButton *anonymousHintButton;
	UIButton *messageHintButton;
	UITextView *anonymousHintTextView;
	UITextView *messageHintTextView;

}

@property (nonatomic, retain) IBOutlet UIButton *closeButton;
@property (nonatomic, retain) IBOutlet UIButton *anonymousHintButton;
@property (nonatomic, retain) IBOutlet UIButton *messageHintButton;
@property (nonatomic, retain) IBOutlet UITextView *anonymousHintTextView;
@property (nonatomic, retain) IBOutlet UITextView *messageHintTextView;

-(IBAction)closeButtonPress;
-(IBAction)anonymousHintButtonPress;
-(IBAction)messageHintButtonPress;
-(void)reset;

@end
