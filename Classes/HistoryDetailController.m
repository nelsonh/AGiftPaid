//
//  HistoryDetailController.m
//  AGiftPaid
//
//  Created by Nelson on 5/11/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import "HistoryDetailController.h"
#import "StateCell.h"
#import "GiftBoxCell.h"
#import "OpenTimeCell.h"
#import "GiftCell.h"
#import "PhotoCell.h"
#import "MusicCell.h"
#import "MessageCell.h"
#import "AGiftWebService.h"
#import "AGiftPaidAppDelegate.h"


@implementation HistoryDetailController

@synthesize receiverImageView;
@synthesize receiverNameLabel;
@synthesize receiverPhoneNumberLabel;
@synthesize dismissButton;
@synthesize table;
@synthesize tableCellArray;
@synthesize messageController;
@synthesize giftHistoryInfo;
@synthesize loadingActivity;
@synthesize loadingLabel;
@synthesize smallIcon;

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
	
	[receiverImageView.layer setCornerRadius:7.0f];
	[receiverImageView.layer setMasksToBounds:YES];
	
	[table setBackgroundColor:[UIColor clearColor]];
	[table setAllowsSelection:NO];

	
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
	
	self.receiverImageView=nil;
	self.receiverNameLabel=nil;
	self.receiverPhoneNumberLabel=nil;
	self.dismissButton=nil;
	self.table=nil;
	self.loadingActivity=nil;
	self.loadingLabel=nil;
	self.smallIcon=nil;
	
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark IBAction method
-(IBAction)dismissButtonPressed
{
	[self.view removeFromSuperview];
}

#pragma mark method
-(void)loadHistoryInfo
{
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	NSArray *tableCellNib;
	
	if(tableCellArray)
	{
		self.tableCellArray=nil;
		
		NSMutableArray *array=[[NSMutableArray alloc] init];
		self.tableCellArray=array;
		[array release];
	}
	else 
	{
		NSMutableArray *array=[[NSMutableArray alloc] init];
		self.tableCellArray=array;
		[array release];
	}

	
	//receiver photo
	NSURL *receiverPhotoUrl=[NSURL URLWithString:giftHistoryInfo.receiverPhotoURL];
	NSURLRequest *request=[NSURLRequest requestWithURL:receiverPhotoUrl];
	NSURLResponse *respond;
	NSError *error;
	[NSURLConnection sendSynchronousRequest:request returningResponse:&respond error:&error];
	
	if([[respond MIMEType] isEqualToString:@"text/html"])
	{
		[receiverImageView setImage:[UIImage imageNamed:@"AUser2.png"]];
	}
	else 
	{
		[receiverImageView setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:receiverPhotoUrl]]];
	}

	
	//receiver name
	[receiverNameLabel setText:@"Updating..."];
	
	//receiver phone number
	[receiverPhoneNumberLabel setText:giftHistoryInfo.receiverPhoneNumber];
	
	//state cell
	tableCellNib=[[NSBundle mainBundle] loadNibNamed:@"StateCell" owner:self options:nil];
	
	for(id tableCellModel in tableCellNib)
	{
		if([tableCellModel isKindOfClass:[StateCell class]])
		{
			StateCell *cell=tableCellModel;
			
			NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
			[dateFormatter setDateFormat:@"MMM/dd/yyyy-HH:mm:ss aa"];
			NSString *strSendDate=[dateFormatter stringFromDate:giftHistoryInfo.SendDate];
			
			[cell.sentTimeLabel setText:strSendDate];
			
			[dateFormatter release];
			
			[tableCellArray addObject:cell];
			
			break;
		}
	}
	
	//gift box cell
	tableCellNib=[[NSBundle mainBundle] loadNibNamed:@"GiftBoxCell" owner:self options:nil];
	
	for(id tableCellModel in tableCellNib)
	{
		if([tableCellModel isKindOfClass:[GiftBoxCell class]])
		{
			GiftBoxCell *cell=tableCellModel;
			
			NSURL *imageUrl=[NSURL URLWithString:giftHistoryInfo.giftBoxImageUrl];
			[cell.giftBoxImageView setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]]];
			
			[tableCellArray addObject:cell];
			
			break;
		}
	}
	
	//open time
	tableCellNib=[[NSBundle mainBundle] loadNibNamed:@"OpenTimeCell" owner:self options:nil];
	
	for(id tableCellModel in tableCellNib)
	{
		if([tableCellModel isKindOfClass:[OpenTimeCell class]])
		{
			OpenTimeCell *cell=tableCellModel;
			
			if(giftHistoryInfo.canOpenTime!=nil)
			{
				NSString *dateStr;
				NSString *timeStr;
				NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
				[dateFormatter setDateFormat:@"yyyy/MM/dd/HH/mm/ss"];
				[dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
				NSDate *canOpenTimeGMT=[dateFormatter dateFromString:giftHistoryInfo.canOpenTime];
	
				[dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
				
				[dateFormatter setDateFormat:@"MMM/dd/yyyy"];
				
				dateStr=[dateFormatter stringFromDate:canOpenTimeGMT];
				
				[dateFormatter setDateFormat:@"HH:mm:ss aa"];
				
				timeStr=[dateFormatter stringFromDate:canOpenTimeGMT];
				
				[cell.openedDateLabel setText:dateStr];
				[cell.openedTimeLabel setText:timeStr];
				
				[dateFormatter release];
			}
			else
			{
				[cell.openedDateLabel setText:@"--/--/--"];
				[cell.openedTimeLabel setText:@"--:--:--"];
			}
			
			[tableCellArray addObject:cell];
			
			break;
		}
	}
	
	//gift cell
	tableCellNib=[[NSBundle mainBundle] loadNibNamed:@"GiftCell" owner:self options:nil];
	
	for(id tableCellModel in tableCellNib)
	{
		if([tableCellModel isKindOfClass:[GiftCell class]])
		{
			GiftCell *cell=tableCellModel;
			
			NSURL *imageUrl=[NSURL URLWithString:giftHistoryInfo.giftImageUrl];
			[cell.giftImageView setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]]];
			
			[tableCellArray addObject:cell];
			
			break;
		}
	}
	
	//photo cell
	tableCellNib=[[NSBundle mainBundle] loadNibNamed:@"PhotoCell" owner:self options:nil];
	
	for(id tableCellModel in tableCellNib)
	{
		if([tableCellModel isKindOfClass:[PhotoCell class]])
		{
			PhotoCell *cell=tableCellModel;
			
			[cell.photoImageView.layer setCornerRadius:5.0f];
			[cell.photoImageView.layer setMasksToBounds:YES];
			
			if(giftHistoryInfo.giftPhotoDataIndex!=nil)
			{
				NSArray *domainPaths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
				NSString *fileDirPath=[domainPaths objectAtIndex:0];
				NSString *photoPath=[fileDirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", giftHistoryInfo.giftPhotoDataIndex]];
				
				[cell.photoImageView setImage:[UIImage imageWithContentsOfFile:photoPath]];
				
				[cell.noPhotoLabel setHidden:YES];
			}
			else 
			{
				[cell.photoImageView setHidden:YES];
				[cell.noPhotoLabel setHidden:NO];
			}

			
			[tableCellArray addObject:cell];
			
			break;
		}
	}
	
	//music cell
	tableCellNib=[[NSBundle mainBundle] loadNibNamed:@"MusicCell" owner:self options:nil];
	
	for(id tableCellModel in tableCellNib)
	{
		if([tableCellModel isKindOfClass:[MusicCell class]])
		{
			MusicCell *cell=tableCellModel;
			
			if(giftHistoryInfo.musicName!=nil)
			{
				[cell.musicNameLabel setText:giftHistoryInfo.musicName];
			}
			else 
			{
				[cell.musicNameLabel setText:@"No music"];
			}

			
			[tableCellArray addObject:cell];
			
			break;
		}
	}
	
	//message cell
	tableCellNib=[[NSBundle mainBundle] loadNibNamed:@"MessageCell" owner:self options:nil];
	
	for(id tableCellModel in tableCellNib)
	{
		if([tableCellModel isKindOfClass:[MessageCell class]])
		{
			MessageCell *cell=tableCellModel;
			
			if(![giftHistoryInfo.beforeMsg isEqualToString:@""])
			{
				//add gesure
				UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(beforeMsgDidTap)];
				[tapGesture setNumberOfTapsRequired:1];
				[cell.onGiftBoxLabel addGestureRecognizer:tapGesture];
				[cell.onGiftBoxLabel setUserInteractionEnabled:YES];
				[tapGesture release];
			}

			
			if(![giftHistoryInfo.afterMsg isEqualToString:@""])
			{
				//add gesure
				UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(afterMsgDidTap)];
				[tapGesture setNumberOfTapsRequired:1];
				[cell.onGiftLabel addGestureRecognizer:tapGesture];
				[cell.onGiftLabel setUserInteractionEnabled:YES];
				[tapGesture release];
			}
			
			[cell.onGiftBoxLabel setText:giftHistoryInfo.beforeMsg];
			[cell.onGiftLabel setText:giftHistoryInfo.afterMsg];	
			
			[tableCellArray addObject:cell];
			
			break;
		}
	}
	
	//update gift status from server
	//NSOperationQueue *opQueue=[[NSOperationQueue new] autorelease];
	AGiftWebService *service=[[AGiftWebService alloc] initAGiftWebService];
	[service setDelegate:self];
	[appDelegate.mainOpQueue addOperation:service];
	[service trackGiftStatus:giftHistoryInfo.giftID];
	[service release];
	
	//update receiver name
	//NSOperationQueue *opQueue=[[NSOperationQueue new] autorelease];
	AGiftWebService *getNameService=[[AGiftWebService alloc] initAGiftWebService];
	[getNameService setDelegate:self];
	[appDelegate.mainOpQueue addOperation:getNameService];
	[getNameService updateGiftStatus:giftHistoryInfo.giftID];
	[getNameService release];
	
	//do reload table
	[table reloadData];
	
	[loadingActivity setHidden:YES];
	[loadingActivity stopAnimating];
	[loadingLabel setHidden:YES];
	
	[receiverImageView setHidden:NO];
	[receiverNameLabel setHidden:NO];
	[receiverPhoneNumberLabel setHidden:NO];
	[dismissButton setHidden:NO];
	[table setHidden:NO];
	[smallIcon setHidden:NO];
}

-(void)beforeMsgDidTap
{
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	if(messageController!=nil)
	{
		[appDelegate.window addSubview:messageController.view];
		
		[messageController.msgTextView setText:giftHistoryInfo.beforeMsg];
	}
	else 
	{
		MessageDetailController *controller=[[MessageDetailController alloc] initWithNibName:@"MessageDetailController" bundle:nil];
		self.messageController=controller;
		[controller release];
		
		[appDelegate.window addSubview:messageController.view];
		
		[messageController.msgTextView setText:giftHistoryInfo.beforeMsg];
	}

}

-(void)afterMsgDidTap
{
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	if(messageController!=nil)
	{
		[appDelegate.window addSubview:messageController.view];
		
		[messageController.msgTextView setText:giftHistoryInfo.afterMsg];
	}
	else 
	{
		MessageDetailController *controller=[[MessageDetailController alloc] initWithNibName:@"MessageDetailController" bundle:nil];
		self.messageController=controller;
		[controller release];
		
		[appDelegate.window addSubview:messageController.view];
		
		[messageController.msgTextView setText:giftHistoryInfo.afterMsg];
	}
}

#pragma mark AGiftWebServiceDelegate
-(void)aGiftWebService:(AGiftWebService*)webService trackGiftStatusStatusDictionary:(NSDictionary*)respondData
{
	StateCell *cell;
	NSString *receiveTime;
	NSString *openedTime;
	
	if(tableCellArray!=nil)
	{
		cell=[tableCellArray objectAtIndex:0];
		
		receiveTime=[respondData valueForKey:@"GiftReceiveTime"];
		openedTime=[respondData valueForKey:@"GiftOpenTime"];
		
		if(![receiveTime isEqualToString:@""])
		{
			NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
			[dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm:ss aa"];
			[dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
			NSDate *receiveTimeGMT=[dateFormatter dateFromString:receiveTime];
			
			[dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
			[dateFormatter setDateFormat:@"MMM/dd/yyyy-HH:mm:ss aa"];
			
			receiveTime=[dateFormatter stringFromDate:receiveTimeGMT];
			[cell.receiveTimeLabel setText:receiveTime];
			
			[dateFormatter release];
		}
		else 
		{
			[cell.receiveTimeLabel setText:@"--/--/-- --:--:--"];
		}
		
		if(![openedTime isEqualToString:@""])
		{
			NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
			[dateFormatter setDateFormat:@"MM/dd/yyyy hh:mm:ss aa"];
			[dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
			NSDate *openTimeGMT=[dateFormatter dateFromString:openedTime];
			
			[dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
			[dateFormatter setDateFormat:@"MMM/dd/yyyy-HH:mm:ss aa"];
			
			[cell.openedTimeLabel setText:[dateFormatter stringFromDate:openTimeGMT]];
			
			[dateFormatter release];
		}
		else
		{
			[cell.openedTimeLabel setText:@"--/--/-- --:--:--"];
		}

	}
	

}

-(void)aGiftWebService:(AGiftWebService*)webService updateGiftStatusStatusDictionary:(NSDictionary*)respondData
{
	//receiver name
	NSString *strName=[respondData valueForKey:@"GiftReceiverName"];
	
	[receiverNameLabel setText:strName];
}

#pragma mark table view data source methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if(tableCellArray!=nil)
	{
		return [tableCellArray count];
	}
	
	return 0;

}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell=[tableCellArray objectAtIndex:[indexPath row]];

	return cell;
}

#pragma mark table view delegate methods
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[table deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell=[tableCellArray objectAtIndex:[indexPath row]];
	
	return cell.frame.size.height;
}

-(void)viewWillAppear:(BOOL)animated
{
	[loadingActivity setHidden:NO];
	[loadingActivity startAnimating];
	[loadingLabel setHidden:NO];
	
	[receiverImageView setHidden:YES];
	[receiverNameLabel setHidden:YES];
	[receiverPhoneNumberLabel setHidden:YES];
	[dismissButton setHidden:YES];
	[table setHidden:YES];
	[smallIcon setHidden:YES];
	
	[self performSelector:@selector(loadHistoryInfo) withObject:nil afterDelay:1];
}


- (void)dealloc {
	
	[receiverImageView release];
	[receiverNameLabel release];
	[receiverPhoneNumberLabel release];
	[dismissButton release];
	[table release];
	[tableCellArray release];
	[giftHistoryInfo release];
	[loadingActivity release];
	[loadingLabel release];
	[smallIcon release];
	
	if(messageController)
		[messageController release];
	
    [super dealloc];
}


@end
