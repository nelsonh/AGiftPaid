//
//  BoxViewerHintController.h
//  AGiftPaid
//
//  Created by Nelson on 5/26/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BoxViewerHintController : UIViewController {
	
	UIButton *closeButton;
	UIButton *gestureHintButton;
	UIButton *previewVideoButton;
	UITextView *gestureHintTextView;
	UITextView *previewVideoTextView;
	UIImageView *zoomInOutImageView;
	UIImageView *panImageView;

}

@property (nonatomic, retain) IBOutlet UIButton *closeButton;
@property (nonatomic, retain) IBOutlet UIButton *gestureHintButton;
@property (nonatomic, retain) IBOutlet UITextView *gestureHintTextView;
@property (nonatomic, retain) IBOutlet UIImageView *zoomInOutImageView;
@property (nonatomic, retain) IBOutlet UIImageView *panImageView;
@property (nonatomic, retain) IBOutlet UIButton *previewVideoButton;
@property (nonatomic, retain) IBOutlet UITextView *previewVideoTextView;

-(IBAction)closeButtonPress;
-(IBAction)gestureHintButtonPress;
-(IBAction)previewVideoButtonPress;

-(void)reset;

@end
