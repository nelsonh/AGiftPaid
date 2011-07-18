//
//  MessageDetailController.h
//  AGiftPaid
//
//  Created by Nelson on 5/12/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageDetailController : UIViewController {
	
	UITextView *msgTextView;
	UIButton *dismissButton;
}

@property (nonatomic, retain) IBOutlet UITextView *msgTextView;
@property (nonatomic, retain) IBOutlet UIButton *dismissButton;

-(IBAction)dismissButtonPressed;

@end
