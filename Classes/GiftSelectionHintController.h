//
//  GiftSelectionHintController.h
//  AGiftPaid
//
//  Created by Nelson on 5/24/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GiftSelectionHintController : UIViewController {
	
	UIButton *closeButton;
	UIButton *giftHintButton;
	UITextView *giftHintTextView;

}

@property (nonatomic, retain) IBOutlet UIButton *closeButton;
@property (nonatomic, retain) IBOutlet UIButton *giftHintButton;
@property (nonatomic, retain) IBOutlet UITextView *giftHintTextView;

-(IBAction)closeButtonPress;
-(IBAction)giftHintButtonPress;
-(void)reset;

@end
