//
//  GiftSectionViewController.m
//  AGiftFree
//
//  Created by Nelson on 2/22/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import "SendGiftSectionViewController.h"
#import "GiftBoxSelectionController.h"
#import "AGiftPaidAppDelegate.h"


@implementation SendGiftSectionViewController

@synthesize giftInfoPackage;

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
	
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	[self.navigationBar setTintColor:[UIColor colorWithRed:43.0f/255.0f green:13.0f/255.0f blue:9.0f/255.0f alpha:1.0f]];
	
	SendGiftInfo *packageInfo=[[SendGiftInfo alloc] init];
	self.giftInfoPackage=packageInfo;
	[packageInfo release];
	
	[giftInfoPackage setSenderID:appDelegate.userPhoneNumber];
	
	GiftBoxSelectionController *rootViewController=[[GiftBoxSelectionController alloc] initWithNibName:@"GiftBoxSelectionController" bundle:nil];
	NSArray *viewControllerArray=[[NSArray alloc] initWithObjects:rootViewController, nil];
	
	[self setViewControllers:viewControllerArray];
	[self setDelegate:self];
	
	[rootViewController release];
	[viewControllerArray release];
	
	
    [super viewDidLoad];
}

-(void)reset
{

	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	if(self.giftInfoPackage)
	{
		self.giftInfoPackage=nil;
	}
	self.giftInfoPackage=[[[SendGiftInfo alloc] init] autorelease];
	[giftInfoPackage setSenderID:appDelegate.userPhoneNumber];
	
	//pop all controller
	[self popToRootViewControllerAnimated:NO];
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
	
	[giftInfoPackage release];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}




- (void)dealloc {
	
	self.giftInfoPackage=nil;
    [super dealloc];
}


@end
