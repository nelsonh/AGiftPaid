//
//  FriendHintController.h
//  AGiftPaid
//
//  Created by Nelson on 5/24/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface FriendHintController : UIViewController {
	
	UIButton *closeButton;
	UIButton *friendIDHintButton;
	UIButton *addFriendHintButton;
	UIButton *friendDisplayHintButton;
	UIButton *removeFriendHintButton;
	UIButton *sendGiftHintButton;
	UITextView *friendIDHintTextView;
	UITextView *addFriendHintTextView;
	UITextView *friendDisplayHintTextView;
	UITextView *removeFriendHintTextView;
	UITextView *sendGiftHintTextView;

}

@property (nonatomic, retain) IBOutlet UIButton *closeButton;
@property (nonatomic, retain) IBOutlet UIButton *friendIDHintButton;
@property (nonatomic, retain) IBOutlet UIButton *addFriendHintButton;
@property (nonatomic, retain) IBOutlet UIButton *friendDisplayHintButton;
@property (nonatomic, retain) IBOutlet UIButton *removeFriendHintButton;
@property (nonatomic, retain) IBOutlet UIButton *sendGiftHintButton;
@property (nonatomic, retain) IBOutlet UITextView *friendIDHintTextView;
@property (nonatomic, retain) IBOutlet UITextView *addFriendHintTextView;
@property (nonatomic, retain) IBOutlet UITextView *friendDisplayHintTextView;
@property (nonatomic, retain) IBOutlet UITextView *removeFriendHintTextView;
@property (nonatomic, retain) IBOutlet UITextView *sendGiftHintTextView;

-(IBAction)closeButtonPress;
-(IBAction)friendIDHintButtonPress;
-(IBAction)addFriendHintButtonPress;
-(IBAction)friendDisplayHintButtonPress;
-(IBAction)removeFriendHintButtonPress;
-(IBAction)sendGiftHintButtonPress;
-(void)reset;

@end
