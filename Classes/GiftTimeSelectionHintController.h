//
//  GiftTimeSelectionHintController.h
//  AGiftPaid
//
//  Created by Nelson on 5/24/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface GiftTimeSelectionHintController : UIViewController {
	
	UIButton *closeButton;
	UIButton *setTimeHintButton;
	UITextView *setTimeHintTextView;

}

@property (nonatomic, retain) IBOutlet UIButton *closeButton;
@property (nonatomic, retain) IBOutlet UIButton *setTimeHintButton;
@property (nonatomic, retain) IBOutlet UITextView *setTimeHintTextView;

-(IBAction)closeButtonPress;
-(IBAction)setTimeHintButtonPress;
-(void)reset;

@end
