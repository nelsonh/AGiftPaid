//
//  PhotoSelectionController.h
//  AGiftPaid
//
//  Created by Nelson on 3/23/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "PhotoSelectionHintController.h"

@interface PhotoSelectionController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
	
	UIButton *cameraButton;
	UIButton *folderButton;
	UIImageView *photoImage;
	UIImageView *naviTitleView;
	UIButton *hintButton;
	PhotoSelectionHintController *hintController;
	NSString *photo64Encoding;
	UIActionSheet *processingView;

}

@property (nonatomic, retain) IBOutlet UIButton *cameraButton;
@property (nonatomic, retain) IBOutlet UIButton *folderButton;
@property (nonatomic, retain) IBOutlet UIImageView *photoImage;
@property (nonatomic, retain) IBOutlet UIButton *hintButton;
@property (nonatomic, retain) IBOutlet PhotoSelectionHintController *hintController;
@property (nonatomic, retain) UIImageView *naviTitleView;
@property (nonatomic, retain) NSString *photo64Encoding;
@property (nonatomic, retain) UIActionSheet *processingView;

-(IBAction)cameraButtonPressed;
-(IBAction)folderButtonPressed;
-(IBAction)confirmButtonPressed:(id)sender;
-(IBAction)hintButtonPress;

-(void)assignInfoToPackage;
-(void)nextView;
-(void)disableHint;
-(void)startProcessingPhoto:(UIImage*)image;
-(void)doProcessingPhoto:(id)object;

@end
