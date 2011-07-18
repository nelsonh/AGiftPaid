//
//  PhotoSelectionHintController.h
//  AGiftPaid
//
//  Created by Nelson on 5/24/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PhotoSelectionHintController : UIViewController {
	
	UIButton *closeButton;
	UIButton *photoCameraHintButton;
	UIButton *photoLibraryHintButton;
	UIButton *photoExpHintButton;
	UITextView *photoCameraHintTextView;
	UITextView *photoLibraryHintTextView;
	UITextView *photoExpHintTextView;

}

@property (nonatomic, retain) IBOutlet UIButton *closeButton;
@property (nonatomic, retain) IBOutlet UIButton *photoCameraHintButton;
@property (nonatomic, retain) IBOutlet UIButton *photoLibraryHintButton;
@property (nonatomic, retain) IBOutlet UIButton *photoExpHintButton;
@property (nonatomic, retain) IBOutlet UITextView *photoCameraHintTextView;
@property (nonatomic, retain) IBOutlet UITextView *photoLibraryHintTextView;
@property (nonatomic, retain) IBOutlet UITextView *photoExpHintTextView;

-(IBAction)closeButtonPress;
-(IBAction)photoCameraHintButtonPress;
-(IBAction)photoLibraryHintButtonPress;
-(IBAction)photoExpHintButtonPress;
-(void)reset;

@end
