//
//  GiftBoxSelectionHintController.h
//  AGiftPaid
//
//  Created by Nelson on 5/24/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GiftBoxSelectionHintController : UIViewController {
	
	UIButton *closeButton;
	UIButton *giftBoxHintButton;
	UITextView *giftBoxHintTextView;

}

@property (nonatomic, retain) IBOutlet UIButton *closeButton;
@property (nonatomic, retain) IBOutlet UIButton *giftBoxHintButton;
@property (nonatomic, retain) IBOutlet UITextView *giftBoxHintTextView;

-(IBAction)closeButtonPressed;
-(IBAction)giftBoxHintButtonPressed;
-(void)reset;

@end
