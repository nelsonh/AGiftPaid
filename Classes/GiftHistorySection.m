//
//  GiftHistorySection.m
//  AGiftPaid
//
//  Created by Nelson on 3/28/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import "GiftHistorySection.h"
#import "GiftHistoryInfo.h"
#import "AGiftPaidAppDelegate.h"
#import "HistoryTableCell.h"
#import "UpdateHistoryView.h"

@implementation GiftHistorySection

@synthesize tableSourceData;
@synthesize updateView;
@synthesize table;
@synthesize gestureView;
@synthesize detailController;
@synthesize hintButton;
@synthesize hintController;

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
		
	
	CGRect updateViewRect=CGRectMake(320, updateView.frame.origin.y, updateView.frame.size.width, updateView.frame.size.height);
	[updateView setFrame:updateViewRect];
	[updateView.layer setCornerRadius:10.0f];
	[updateView.layer setMasksToBounds:YES];
	
	
	CGRect gestureViewRect=CGRectMake(0, 33, updateView.frame.size.width, updateView.frame.size.height);
	UIView *aView=[[UIView alloc] initWithFrame:gestureViewRect];
	[aView setBackgroundColor:[UIColor clearColor]];
	self.gestureView=aView;
	[self.view addSubview:aView];
	[aView release];
	
	UISwipeGestureRecognizer *swipLeft=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(updateViewSlideIn)];
	[swipLeft setNumberOfTouchesRequired:1];
	[swipLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
	[self.gestureView addGestureRecognizer:swipLeft];
	[swipLeft release];
	
	UISwipeGestureRecognizer *swipRight=[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(updateViewSlideOut)];
	[swipRight setNumberOfTouchesRequired:1];
	[swipRight setDirection:UISwipeGestureRecognizerDirectionRight];
	[self.updateView addGestureRecognizer:swipRight];
	[swipRight release];
	
	
	//set background image
	UIImageView *tableBackground=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Brown_background.png"]];
	[table setBackgroundView:tableBackground];
	[tableBackground release];
	
	
	
    [super viewDidLoad];
}


-(void)updateViewSlideIn
{
	[self.view bringSubviewToFront:updateView];
	
	CGRect inPosition=CGRectMake(0, updateView.frame.origin.y, updateView.frame.size.width, updateView.frame.size.height);
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	[updateView setFrame:inPosition];
	[UIView commitAnimations];
}

-(void)updateViewSlideOut
{
	CGRect outPosition=CGRectMake(320, updateView.frame.origin.y, updateView.frame.size.width, updateView.frame.size.height);
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	[updateView setFrame:outPosition];
	[UIView commitAnimations];
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
	
	self.table=nil;
	self.updateView=nil;
	self.hintButton=nil;
	self.hintController=nil;
	
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark table view data source methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	
	if(tableSourceData==nil)
		return 0;
	
	return [tableSourceData count];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *HistoryTableCellIdentifier=@"HistoryTableCellIdentifier";
	
	HistoryTableCell *cell=(HistoryTableCell*)[tableView dequeueReusableCellWithIdentifier:HistoryTableCellIdentifier];
	
	if(cell==nil)
	{
		//create a new one
		NSArray *tableCellNib=[[NSBundle mainBundle] loadNibNamed:@"HistoryTableCell" owner:self options:nil];
		
		for(id tableCellModel in tableCellNib)
		{
			if([tableCellModel isKindOfClass:[HistoryTableCell class]])
			{
				cell=(HistoryTableCell*)tableCellModel;
			}
		}
	}
	
	GiftHistoryInfo *historyInfo=[tableSourceData objectAtIndex:[indexPath row]];
	
	[cell setHistoryInfo:historyInfo];
	[cell setIndex:indexPath];
	[historyInfo setHistorySection:self];
	
	//NSString *receiverName=historyInfo.receiverName;
	
	NSDateFormatter *dateFormatter=[[[NSDateFormatter alloc] init] autorelease];
	[dateFormatter setDateFormat:@"MMM/dd/yyyy"];
	NSString *strSendDate=[dateFormatter stringFromDate:historyInfo.SendDate];
	
	UIImage *timeImage;
	
	if(historyInfo.canOpenTime==nil)
	{
		timeImage=[UIImage imageNamed:@"open.png"];
	}
	else 
	{
		[dateFormatter setDateFormat:@"yyyy/MM/dd/HH/mm/ss"];
		[dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
		NSDate *canOpenTime=[dateFormatter dateFromString:historyInfo.canOpenTime];
		NSTimeInterval time=[canOpenTime timeIntervalSinceNow];
		
		if(time<=0)
		{
			timeImage=[UIImage imageNamed:@"open.png"];
		}
		else 
		{
			timeImage=[UIImage imageNamed:@"NOpen.png"];
		}

	}
	
	[cell.receiverNameLabel setText:@"Updating..."];
	[cell.sendDateLabel setText:strSendDate];
	[cell.canOpenTimeStatusImageView setImage:timeImage];
	[cell setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.6]];
	
	//update cell status
	[historyInfo updateGiftStatusWithCell:cell];
	
	return cell;
	
}

#pragma mark table view delegate methods
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return kTableCellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];
	GiftHistoryInfo *historyInfo=[tableSourceData objectAtIndex:[indexPath row]];
	
	if(detailController!=nil)
	{
		[detailController setGiftHistoryInfo:historyInfo];
		[appDelegate.window addSubview:detailController.view];
	}
	else 
	{
		HistoryDetailController *controller=[[HistoryDetailController alloc] initWithNibName:@"HistoryDetailController" bundle:nil];
		self.detailController=controller;
		[controller release];
		
		[detailController setGiftHistoryInfo:historyInfo];
		[appDelegate.window addSubview:detailController.view];
	}

	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
	return YES;
}

/*
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	GiftHistoryInfo *historyInfo=[tableSourceData objectAtIndex:[indexPath row]];
	
	if(historyInfo.isUpdatingStatus)
	{
		return UITableViewCellEditingStyleNone;
	}
	
	return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	if(editingStyle==UITableViewCellEditingStyleDelete)
	{
		GiftHistoryInfo *historyInfo=[tableSourceData objectAtIndex:[indexPath row]];
		
		//send delete gift status to server
		//call send gift service
		//NSOperationQueue *opQueue=[NSOperationQueue new];
		AGiftWebService *service=[[AGiftWebService alloc] initAGiftWebService];
		[appDelegate.mainOpQueue addOperation:service];
		[service deleteGiftStatus:historyInfo.giftID];
		[service release];
		
		//remove from core data
		[appDelegate.dataManager removeGiftHistoryWithGiftID:historyInfo.giftID];
		
		NSArray *indexPathArray=[NSArray arrayWithObject:indexPath];
		
		//delete from source data
		[tableSourceData removeObjectAtIndex:[indexPath row]];
		
		//delete from table
		[tableView deleteRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationFade];
	}
}
 */

#pragma mark IBAction methos
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

#pragma mark methos
-(void)reloadSourceData
{
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	self.tableSourceData=[appDelegate.dataManager retrieveGiftHistory];
	
	[table reloadData];
}

-(void)deleteTableCell:(UITableViewCell*)inCell
{
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	NSIndexPath *deletedIndexPath=[table indexPathForCell:inCell];
	NSArray *indexPaths=[NSArray arrayWithObjects:deletedIndexPath, nil];
	
	
	GiftHistoryInfo *historyInfo=[tableSourceData objectAtIndex:[deletedIndexPath row]];
	
	//send delete gift status to server
	//call send gift service
	//NSOperationQueue *opQueue=[NSOperationQueue new];
	AGiftWebService *service=[[AGiftWebService alloc] initAGiftWebService];
	[appDelegate.mainOpQueue addOperation:service];
	[service deleteGiftStatus:historyInfo.giftID];
	[service release];
	
	//remove from core data
	[appDelegate.dataManager removeGiftHistoryWithGiftID:historyInfo.giftID];
	
	//delete from source data
	[tableSourceData removeObjectAtIndex:[deletedIndexPath row]];
	
	//delete from table
	[table deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
	
}

-(void)disableHint
{
	[hintController closeButtonPress];
}


-(void)viewDidAppear:(BOOL)animated
{	
	[self reloadSourceData];
}

#pragma mark mutitask protocol
-(void)update
{
	[table reloadData];
}


- (void)dealloc {
	
	[table release];
	[updateView release];
	[gestureView release];
	[tableSourceData release];
	[hintButton release];
	[hintController release];
	
	if(detailController)
	{
		[detailController release];
	}
	
    [super dealloc];
}


@end
