//
//  GiftHistoryInfo.h
//  AGiftPaid
//
//  Created by Nelson on 3/25/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AGiftWebService.h"

@class HistoryTableCell;
@class GiftHistorySection;

@interface GiftHistoryInfo : NSObject <AGiftWebServiceDelegate>{
	
	NSString *giftID;
	NSString *canOpenTime;
	NSString *receiverName;
	NSDate *SendDate;
	NSString *giftBoxImageUrl;
	NSString *giftImageUrl;
	NSString *giftPhotoDataIndex;
	NSString *musicName;
	NSString *receiverPhotoURL;
	NSString *receiverPhoneNumber;
	NSString *beforeMsg;
	NSString *afterMsg;
	GiftHistorySection *historySection;
	
	//tableview use
	HistoryTableCell *cell;
	BOOL isUpdatingStatus;
	NSIndexPath *removedCellIndex;
}

@property (nonatomic, retain) NSString *giftID;
@property (nonatomic, retain) NSString *canOpenTime;
@property (nonatomic, retain) NSString *receiverName;
@property (nonatomic, retain) NSDate *SendDate;
@property (nonatomic, assign) HistoryTableCell *cell;
@property (nonatomic, assign) BOOL isUpdatingStatus;
@property (nonatomic, assign) GiftHistorySection *historySection;
@property (nonatomic, assign) NSIndexPath *removedCellIndex;
@property (nonatomic, retain) NSString *giftBoxImageUrl;
@property (nonatomic, retain) NSString *giftImageUrl;
@property (nonatomic, retain) NSString *giftPhotoDataIndex;
@property (nonatomic, retain) NSString *musicName;
@property (nonatomic, retain) NSString *beforeMsg;
@property (nonatomic, retain) NSString *afterMsg;
@property (nonatomic, retain) NSString *receiverPhotoURL;
@property (nonatomic, retain) NSString *receiverPhoneNumber;

-(void)updateGiftStatusWithCell:(HistoryTableCell*)inCell;
-(void)cancelGift:(NSIndexPath*)removedIndex;
-(void)deleteGiftWithCell:(UITableViewCell*)inCell;

@end
