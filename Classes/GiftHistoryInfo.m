//
//  GiftHistoryInfo.m
//  AGiftPaid
//
//  Created by Nelson on 3/25/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import "GiftHistoryInfo.h"
#import "AGiftWebService.h"
#import "HistoryTableCell.h"
#import "GiftHistorySection.h"
#import "AGiftPaidAppDelegate.h"

@implementation GiftHistoryInfo

@synthesize giftID;
@synthesize canOpenTime;
@synthesize receiverName;
@synthesize SendDate;
@synthesize cell;
@synthesize isUpdatingStatus;
@synthesize historySection;
@synthesize removedCellIndex;
@synthesize giftBoxImageUrl;
@synthesize giftImageUrl;
@synthesize giftPhotoDataIndex;
@synthesize musicName;
@synthesize beforeMsg;
@synthesize afterMsg;
@synthesize receiverPhotoURL;
@synthesize receiverPhoneNumber;

-(void)updateGiftStatusWithCell:(HistoryTableCell*)inCell
{
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	self.cell=inCell;
	
	self.isUpdatingStatus=YES;
	
	[cell.updatingIndicator startAnimating];
	
	//NSOperationQueue *opQueue=[[NSOperationQueue new] autorelease];
	AGiftWebService *service=[[AGiftWebService alloc] initAGiftWebService];
	[service setDelegate:self];
	[appDelegate.mainOpQueue addOperation:service];
	[service updateGiftStatus:giftID];
	[service release];
}

-(void)cancelGift:(NSIndexPath*)removedIndex
{
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	self.removedCellIndex=removedIndex;
	
	//NSOperationQueue *opQueue=[[NSOperationQueue new] autorelease];
	AGiftWebService *service=[[AGiftWebService alloc] initAGiftWebService];
	[service setDelegate:self];
	[appDelegate.mainOpQueue addOperation:service];
	[service cancelGiftWithGiftID:giftID];
	[service release];
}

-(void)deleteGiftWithCell:(UITableViewCell*)inCell
{
	[historySection deleteTableCell:inCell];
}

#pragma mark AGiftWebServiceDelegate
-(void)aGiftWebService:(AGiftWebService*)webService updateGiftStatusStatusDictionary:(NSDictionary*)respondData
{
	UIImage *statusImage;
	
	NSNumber *status=[respondData valueForKey:@"GiftStatus"];
	
	NSString *strGiftStatus=[NSString stringWithFormat:@"%i", [status integerValue]];
	
	//receiver name
	NSString *strName=[respondData valueForKey:@"GiftReceiverName"];
	
	[cell.receiverNameLabel setText:strName];
	
	if([strGiftStatus isEqualToString:@"0"])
	{
		statusImage=[UIImage imageNamed:@"BOX2.png"];
		[cell.cancelGiftButton setHidden:NO];
	}
	else if([strGiftStatus isEqualToString:@"1"]) 
	{
		statusImage=[UIImage imageNamed:@"BOX2.png"];
		[cell.cancelGiftButton setHidden:YES];
	}
	else if([strGiftStatus isEqualToString:@"2"])
	{
		statusImage=[UIImage imageNamed:@"BOX.png"];
		[cell.cancelGiftButton setHidden:YES];
	}
	else if([strGiftStatus isEqualToString:@"4"])
	{
		statusImage=[UIImage imageNamed:@"BOX2.png"];
		[cell.cancelGiftButton setHidden:YES];
	}
	
	if(cell)
	{
		[cell.giftStatusImageView setImage:statusImage];
		[cell.updatingIndicator stopAnimating];
	}
	
	self.isUpdatingStatus=NO;
}

-(void)aGiftWebService:(AGiftWebService*)webService cancelGiftResult:(NSString*)respondData
{
	if([respondData isEqualToString:@"1"])
	{
		NSString *msg=@"Gift has been cancel";
		
		UIAlertView *giftCancelAlert=[[UIAlertView alloc] initWithTitle:@"Cancel gift" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[giftCancelAlert show];
		[giftCancelAlert release];
		
		if(historySection)
		{
			[historySection reloadSourceData];
		}
	}
	else if([respondData isEqualToString:@"0"]) 
	{
		NSString *msg=@"Unable to cancel this gift";
		
		UIAlertView *cancelAlert=[[UIAlertView alloc] initWithTitle:@"Cancel fail" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[cancelAlert show];
		[cancelAlert release];
	}

}

-(void)dealloc
{
	[giftID release];
	[canOpenTime release];
	[receiverName release];
	[SendDate release];
	[musicName release];
	[beforeMsg release];
	[afterMsg release];
	[giftBoxImageUrl release];
	[giftImageUrl release];
	[receiverPhotoURL release];
	[receiverPhoneNumber release];
	[giftPhotoDataIndex release];
	
	[super dealloc];
}

@end
