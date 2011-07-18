//
//  PhotoSelectionController.m
//  AGiftPaid
//
//  Created by Nelson on 3/23/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import "PhotoSelectionController.h"
#import "AGiftPaidAppDelegate.h"
#import "MusicSelectionController.h"
#import "SendGiftSectionViewController.h"
#import "NSData+Base64.h"


@implementation PhotoSelectionController

@synthesize cameraButton;
@synthesize folderButton;
@synthesize photoImage;
@synthesize naviTitleView;
@synthesize hintButton;
@synthesize hintController;
@synthesize photo64Encoding;
@synthesize processingView;


// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
	self.naviTitleView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iPhoto.png"]];
	[self.navigationItem setTitleView:self.naviTitleView];
	
	[self setTitle:@"Photo"];
	
	//custom navi right button
	UIImageView *nextButton=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MusicBla.png"]];
	[nextButton setUserInteractionEnabled:YES];
	UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nextView)];
	[tapGesture setNumberOfTapsRequired:1];
	[nextButton addGestureRecognizer:tapGesture];
	[tapGesture release];
	
	UIBarButtonItem *nextButtonItem=[[UIBarButtonItem alloc] initWithCustomView:nextButton];
	
	[self.navigationItem setRightBarButtonItem:nextButtonItem];
	[nextButtonItem release];
	
	[photoImage.layer setCornerRadius:5.0f];
	[photoImage.layer setMasksToBounds:YES];
	
    [super viewDidLoad];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
	
	self.cameraButton=nil;
	self.folderButton=nil;
	self.photoImage=nil;
	self.naviTitleView=nil;
	self.hintButton=nil;
	self.hintController=nil;
	
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark IBAction Method
-(IBAction)cameraButtonPressed
{
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
	{
		UIImagePickerController *photoLibraryPicker=[[UIImagePickerController alloc] init];
		photoLibraryPicker.delegate=self;
		[photoLibraryPicker setAllowsEditing:YES];
		photoLibraryPicker.sourceType=UIImagePickerControllerSourceTypeCamera;
		[appDelegate.rootController presentModalViewController:photoLibraryPicker animated:YES];
		[photoLibraryPicker release];
	}
	else
	{
		NSString *alertTitle=@"Device not support";
		NSString *alertMsg=@"Your device is not support camera";
		
		UIAlertView* deviceNotSupportAlert=[[UIAlertView alloc] initWithTitle:alertTitle message:alertMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[deviceNotSupportAlert show];
		[deviceNotSupportAlert release];
	}
}

-(IBAction)folderButtonPressed
{
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
	{
		UIImagePickerController *photoAlbumPicker=[[UIImagePickerController alloc] init];
		photoAlbumPicker.delegate=self;
		photoAlbumPicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
		[photoAlbumPicker setAllowsEditing:YES];
		[appDelegate.rootController presentModalViewController:photoAlbumPicker animated:YES];
		[photoAlbumPicker release];
	}
	else if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum])
	{
		UIImagePickerController *photoLibraryPicker=[[UIImagePickerController alloc] init];
		photoLibraryPicker.delegate=self;
		photoLibraryPicker.sourceType=UIImagePickerControllerSourceTypeSavedPhotosAlbum;
		[photoLibraryPicker setAllowsEditing:YES];
		[appDelegate.rootController presentModalViewController:photoLibraryPicker animated:YES];
		[photoLibraryPicker release];
	}
	else 
	{
		NSString *alertTitle=@"Device not support";
		NSString *alertMsg=@"Your device is not support both photo library and photo album";
		
		UIAlertView* deviceNotSupportAlert=[[UIAlertView alloc] initWithTitle:alertTitle message:alertMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[deviceNotSupportAlert show];
		[deviceNotSupportAlert release];
		
	}
}

-(IBAction)confirmButtonPressed:(id)sender
{
	UIView *senderView=(UIView*)sender;
	
	//anim effect
	CABasicAnimation *expandAnim=[CABasicAnimation animationWithKeyPath:@"transform"];
	[expandAnim setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
	[expandAnim setDuration:0.15];
	[expandAnim setRepeatCount:1];
	[expandAnim setAutoreverses:YES];
	[expandAnim setRemovedOnCompletion:YES];
	[expandAnim setToValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(2.0, 2.0, 1.0)]];
	[senderView.layer addAnimation:expandAnim forKey:nil];
	
	[self assignInfoToPackage];
	
	MusicSelectionController *musicController=[[MusicSelectionController alloc] initWithNibName:@"MusicSelectionController" bundle:nil];
	[self.navigationController pushViewController:musicController animated:YES];
	[musicController release];
}

-(IBAction)hintButtonPress
{
	
	
	if(hintController)
	{
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationTransition:UIViewAnimationTransitionCurlDown forView:self.view cache:YES];
		[UIView setAnimationDuration:1.0];
		
		[self.view addSubview:hintController.view];
		
		[UIView commitAnimations];
	}
	
}

#pragma mark Method
-(void)nextView
{
	[self assignInfoToPackage];
	
	[self disableHint];
	
	MusicSelectionController *musicController=[[MusicSelectionController alloc] initWithNibName:@"MusicSelectionController" bundle:nil];
	[self.navigationController pushViewController:musicController animated:YES];
	[musicController release];
}

-(void)assignInfoToPackage
{
	SendGiftSectionViewController *rootNaviController=(SendGiftSectionViewController*)self.navigationController;
	SendGiftInfo *package=rootNaviController.giftInfoPackage;
	
	if(photoImage.image!=nil)
	{
		[package setGiftPhotoFileName:@"GiftPhoto"];
		[package setGiftPhoto64Encoding:photo64Encoding];
	}
}

-(void)disableHint
{
	[hintController closeButtonPress];
}

-(void)startProcessingPhoto:(UIImage*)image
{
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	UIActionSheet *actionSheet=[[[UIActionSheet alloc] initWithTitle:@"Processing photo. Please wait." delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil] autorelease];
	UIActivityIndicatorView *activityView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	[activityView setFrame:CGRectMake(257, 10, activityView.frame.size.width, activityView.frame.size.height)];
	[activityView setHidden:NO];
	[activityView startAnimating];
	[actionSheet addSubview:activityView];
	[activityView release];

	
	self.processingView=actionSheet;
	
	[actionSheet showInView:appDelegate.rootController.view];
	
	[self performSelector:@selector(doProcessingPhoto:) withObject:image afterDelay:1];
}

-(void)doProcessingPhoto:(id)object
{
	UIImage *photo=object;
	
	//encoding photo
	NSData *photoData=UIImagePNGRepresentation(photo);
	self.photo64Encoding=[photoData base64Encoding];
	[photoImage setImage:photo];
	
	[self.processingView dismissWithClickedButtonIndex:0 animated:YES];
	self.processingView=nil;
}

#pragma mark UI image picker controller delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	UIImage *selectedImage=[info objectForKey:UIImagePickerControllerEditedImage];
	[self startProcessingPhoto:selectedImage];
	[picker dismissModalViewControllerAnimated:YES];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
	[picker dismissModalViewControllerAnimated:YES];
}

- (void)dealloc {
	
	[cameraButton release];
	[folderButton release];
	[photoImage release];
	[naviTitleView release];
	[hintButton release];
	[hintController release];
	[photo64Encoding release];
	[processingView release];
	
    [super dealloc];
}


@end
