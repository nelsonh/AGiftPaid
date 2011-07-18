//
//  CoreDataManager.m
//  AGiftFree
//
//  Created by Nelson on 3/8/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import "CoreDataManager.h"
#import "AGiftPaidAppDelegate.h"
#import "FriendInfo.h"
#import "GiftHistoryInfo.h"


@implementation CoreDataManager

-(NSMutableArray*)retrieveFriendList
{
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	NSManagedObjectContext *context=[appDelegate managedObjectContext];
	NSManagedObject *friendObject=nil;
	NSMutableArray *friendInfoList=[[[NSMutableArray alloc] init] autorelease];
	
	NSError *error;
	
	NSFetchRequest *request=[[NSFetchRequest alloc] init];
	
	NSEntityDescription *entityDescription=[NSEntityDescription entityForName:@"FriendList" inManagedObjectContext:context];
	[request setEntity:entityDescription];
	
	NSArray *objects=[context executeFetchRequest:request error:&error];
	
	[request release];
	
	for(friendObject in objects)
	{
		FriendInfo *newFriendInfo=[[FriendInfo alloc] init];
		
		[newFriendInfo setFriendPhotoURL:[friendObject valueForKey:@"FriendPhotoURL"]];
		
		[newFriendInfo setFriendID:[friendObject valueForKey:@"FriendID"]];
		[newFriendInfo assignFriendName:[friendObject valueForKey:@"FriendName"]];
		[newFriendInfo assignFriendPhotoData:[friendObject valueForKey:@"FriendPhotoData"]];
		
		[friendInfoList addObject:newFriendInfo];
		
		[newFriendInfo release];
	}
	
	return friendInfoList;
}

-(BOOL)addNewFriend:(FriendInfo*)friendInfo
{
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	NSManagedObjectContext *context=[appDelegate managedObjectContext];
	NSManagedObject *friendObject=nil;
	
	NSError *error;
	
	NSPredicate *pred=[NSPredicate predicateWithFormat:@"(FriendID=%@)", friendInfo.friendID];
	
	NSFetchRequest *request=[[NSFetchRequest alloc] init];
	
	NSEntityDescription *entityDescription=[NSEntityDescription entityForName:@"FriendList" inManagedObjectContext:context];
	[request setEntity:entityDescription];
	[request setPredicate:pred];
	
	NSArray *objects=[context executeFetchRequest:request error:&error];
	
	[request release];
	
	if([objects count]>0)
	{
		//friend existed
		return NO;
	}
	else 
	{
		//friend not existed 
		
		friendObject=[NSEntityDescription insertNewObjectForEntityForName:@"FriendList" inManagedObjectContext:context];
		
		[friendObject setValue:friendInfo.friendID forKey:@"FriendID"];
		[friendObject setValue:friendInfo.friendName forKey:@"FriendName"];
		[friendObject setValue:friendInfo.friendPhotoURL forKey:@"FriendPhotoURL"];
		//[friendObject setValue:friendInfo.friendPhotoData forKey:@"FriendPhotoData"];
		
		return [context save:&error];
	}

}

-(BOOL)updateFriendInfo:(FriendInfo*)friendInfo
{
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	NSManagedObjectContext *context=[appDelegate managedObjectContext];
	NSManagedObject *friendObject=nil;
	
	NSError *error;
	
	NSPredicate *pred=[NSPredicate predicateWithFormat:@"(FriendID=%@)", friendInfo.friendID];
	
	NSFetchRequest *request=[[NSFetchRequest alloc] init];
	
	NSEntityDescription *entityDescription=[NSEntityDescription entityForName:@"FriendList" inManagedObjectContext:context];
	[request setEntity:entityDescription];
	[request setPredicate:pred];
	
	NSArray *objects=[context executeFetchRequest:request error:&error];
	
	[request release];
	
	if([objects count]>0)
	{
		friendObject=[objects objectAtIndex:0];
		
		[friendObject setValue:friendInfo.friendID forKey:@"FriendID"];
		[friendObject setValue:friendInfo.friendName forKey:@"FriendName"];
		[friendObject setValue:friendInfo.friendPhotoURL forKey:@"FriendPhotoURL"];
		//[friendObject setValue:friendInfo.friendPhotoData forKey:@"FriendPhotoData"];
	}
	
	return [context save:&error];
}

-(BOOL)removeFriend:(NSString*)friendID
{
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	NSManagedObjectContext *context=[appDelegate managedObjectContext];
	NSManagedObject *removedFriend=nil;
	
	NSError *error;
	
	NSPredicate *pred=[NSPredicate predicateWithFormat:@"(FriendID=%@)", friendID];
	
	NSFetchRequest *request=[[NSFetchRequest alloc] init];
	
	NSEntityDescription *entityDescription=[NSEntityDescription entityForName:@"FriendList" inManagedObjectContext:context];
	[request setEntity:entityDescription];
	[request setPredicate:pred];
	
	NSArray *objects=[context executeFetchRequest:request error:&error];
	
	[request release];
	
	if([objects count]>0)
	{
		removedFriend=[objects objectAtIndex:0];
		[context deleteObject:removedFriend];
		
		return [context save:&error];
	}
	else 
	{
		return NO;
	}

}

-(BOOL)isFriendExisted:(NSString*)friendID
{
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	NSManagedObjectContext *context=[appDelegate managedObjectContext];
	
	NSError *error;
	
	NSPredicate *pred=[NSPredicate predicateWithFormat:@"(FriendID=%@)", friendID];
	
	NSFetchRequest *request=[[NSFetchRequest alloc] init];
	
	NSEntityDescription *entityDescription=[NSEntityDescription entityForName:@"FriendList" inManagedObjectContext:context];
	[request setEntity:entityDescription];
	[request setPredicate:pred];
	
	NSArray *objects=[context executeFetchRequest:request error:&error];
	
	[request release];
	
	if([objects count]>0)
	{
		//friend existed
		return YES;
	}
	else 
	{
		return NO;
	}
}

-(BOOL)addGiftToHistory:(NSString*)giftID
{
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	NSManagedObjectContext *context=[appDelegate managedObjectContext];
	NSManagedObject *giftHistory=[NSEntityDescription insertNewObjectForEntityForName:@"SendGiftHistory" inManagedObjectContext:context];
	
	NSError *error;
	
	[giftHistory setValue:giftID forKey:@"GiftID"];
	
	return [context save:&error];
}

-(NSMutableArray*)retrieveGiftHistory
{
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	NSManagedObjectContext *context=[appDelegate managedObjectContext];
	NSManagedObject *giftHistory=nil;
	NSMutableArray *giftHistoryList=[[[NSMutableArray alloc] init] autorelease];
	
	NSError *error;
	
	NSFetchRequest *request=[[NSFetchRequest alloc] init];
	
	NSEntityDescription *entityDescription=[NSEntityDescription entityForName:@"SendGiftHistory" inManagedObjectContext:context];
	[request setEntity:entityDescription];
	
	NSArray *objects=[context executeFetchRequest:request error:&error];
	
	[request release];
	
	for(giftHistory in objects)
	{
		GiftHistoryInfo *historyInfo=[[GiftHistoryInfo alloc] init];
		
		[historyInfo setGiftID:[giftHistory valueForKey:@"GiftID"]];
		[historyInfo setCanOpenTime:[giftHistory valueForKey:@"CanOpenTime"]];
		[historyInfo setReceiverName:[giftHistory valueForKey:@"ReceiverName"]];
		[historyInfo setReceiverPhoneNumber:[giftHistory valueForKey:@"ReceiverPhoneNumber"]];
		[historyInfo setReceiverPhotoURL:[giftHistory valueForKey:@"ReceiverPhotoUrl"]];
		[historyInfo setSendDate:[giftHistory valueForKey:@"SendDate"]];
		[historyInfo setGiftBoxImageUrl:[giftHistory valueForKey:@"GiftBoxImageUrl"]];
		[historyInfo setGiftImageUrl:[giftHistory valueForKey:@"GiftImageUrl"]];
		[historyInfo setGiftPhotoDataIndex:[giftHistory valueForKey:@"GiftPhotoIndex"]];
		[historyInfo setMusicName:[giftHistory valueForKey:@"MusicName"]];
		[historyInfo setBeforeMsg:[giftHistory valueForKey:@"OnGiftBoxMsg"]];
		[historyInfo setAfterMsg:[giftHistory valueForKey:@"OnGiftMsg"]];
		
		[giftHistoryList addObject:historyInfo];
	}
	
	return giftHistoryList;
}

-(BOOL)saveGiftHistory:(GiftHistoryInfo*)historyInfo
{
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	NSManagedObjectContext *context=[appDelegate managedObjectContext];
	NSManagedObject *historyObject=nil;
	
	NSError *error;
	
	NSPredicate *pred=[NSPredicate predicateWithFormat:@"(GiftID=%i)", historyInfo.giftID];
	
	NSFetchRequest *request=[[NSFetchRequest alloc] init];
	
	NSEntityDescription *entityDescription=[NSEntityDescription entityForName:@"SendGiftHistory" inManagedObjectContext:context];
	[request setEntity:entityDescription];
	[request setPredicate:pred];
	
	NSArray *objects=[context executeFetchRequest:request error:&error];
	
	[request release];
	
	if([objects count]>0)
	{
		//a gift history existed
		return NO;
	}
	else 
	{
		//gift history not existed
		
		historyObject=[NSEntityDescription insertNewObjectForEntityForName:@"SendGiftHistory" inManagedObjectContext:context];
		
		[historyObject setValue:historyInfo.giftID forKey:@"GiftID"];
		[historyObject setValue:historyInfo.canOpenTime forKey:@"CanOpenTime"];
		[historyObject setValue:historyInfo.receiverName forKey:@"ReceiverName"];
		[historyObject setValue:historyInfo.receiverPhoneNumber forKey:@"ReceiverPhoneNumber"];
		[historyObject setValue:historyInfo.receiverPhotoURL forKey:@"ReceiverPhotoUrl"];
		[historyObject setValue:historyInfo.SendDate forKey:@"SendDate"];
		[historyObject setValue:historyInfo.giftBoxImageUrl forKey:@"GiftBoxImageUrl"];
		[historyObject setValue:historyInfo.giftImageUrl forKey:@"GiftImageUrl"];
		[historyObject setValue:historyInfo.giftPhotoDataIndex forKey:@"GiftPhotoIndex"];
		[historyObject setValue:historyInfo.musicName forKey:@"MusicName"];
		[historyObject setValue:historyInfo.beforeMsg forKey:@"OnGiftBoxMsg"];
		[historyObject setValue:historyInfo.afterMsg forKey:@"OnGiftMsg"];
		
		
		
		return [context save:&error];
	}
}

-(BOOL)removeGiftHistoryWithGiftID:(NSString*)giftID
{
	AGiftPaidAppDelegate *appDelegate=(AGiftPaidAppDelegate*)[[UIApplication sharedApplication] delegate];
	
	NSManagedObjectContext *context=[appDelegate managedObjectContext];
	NSManagedObject *removedGiftHistory=nil;
	
	NSError *error;
	
	NSPredicate *pred=[NSPredicate predicateWithFormat:@"(GiftID=%@)", giftID];
	
	NSFetchRequest *request=[[NSFetchRequest alloc] init];
	
	NSEntityDescription *entityDescription=[NSEntityDescription entityForName:@"SendGiftHistory" inManagedObjectContext:context];
	[request setEntity:entityDescription];
	[request setPredicate:pred];
	
	NSArray *objects=[context executeFetchRequest:request error:&error];
	
	[request release];
	
	if([objects count]>0)
	{
		removedGiftHistory=[objects objectAtIndex:0];
		[context deleteObject:removedGiftHistory];
		
		return [context save:&error];
	}
	else 
	{
		return NO;
	}
}


-(void)dealloc
{
	[super dealloc];
}

@end
