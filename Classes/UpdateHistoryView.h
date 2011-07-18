//
//  UpdateHistoryView.h
//  AGiftPaid
//
//  Created by Nelson on 3/31/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GiftHistorySection;

@interface UpdateHistoryView : UIView {

	GiftHistorySection *owner;
	
	UIButton *updateButton;
}

@property (nonatomic, retain) IBOutlet UIButton *updateButton;
@property (nonatomic, assign) IBOutlet GiftHistorySection *owner;

-(IBAction)updateButtonPressed;

@end
