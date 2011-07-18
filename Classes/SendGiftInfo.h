//
//  SendGiftInfo.h
//  AGiftPaid
//
//  Created by Nelson on 3/25/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SendGiftInfo : NSObject {
	
	NSString *senderID;
	NSString *receiverID;
	NSString *anonymous;
	NSString *canOpenTime;
	NSString *giftBoxVideoID;
	NSString *giftVideoID;
	NSString *beforeMsg;
	NSString *afterMsg;
	NSString *giftPhotoFileName;
	NSString *giftPhoto64Encoding;
	NSString *giftDefMusicID;
	NSString *customMusicFileName;
	NSString *customMusic64Encoding;
	NSString *gift3DObjID;
	NSString *giftBox3DObjID;
	NSString *giftBoxImageUrl;
	NSString *giftImageUrl;
	NSString *musicName;
	NSString *receiverPhotoUrl;
	NSString *receiverName;

}

@property (nonatomic, retain) NSString *senderID;
@property (nonatomic, retain) NSString *receiverID;
@property (nonatomic, retain) NSString *anonymous;
@property (nonatomic, retain) NSString *canOpenTime;
@property (nonatomic, retain) NSString *giftBoxVideoID;
@property (nonatomic, retain) NSString *giftVideoID;
@property (nonatomic, retain) NSString *beforeMsg;
@property (nonatomic, retain) NSString *afterMsg;
@property (nonatomic, retain) NSString *giftPhotoFileName;
@property (nonatomic, retain) NSString *giftPhoto64Encoding;
@property (nonatomic, retain) NSString *giftDefMusicID;
@property (nonatomic, retain) NSString *customMusicFileName;
@property (nonatomic, retain) NSString *customMusic64Encoding;
@property (nonatomic, retain) NSString *gift3DObjID;
@property (nonatomic, retain) NSString *giftBox3DObjID;
@property (nonatomic, retain) NSString *giftBoxImageUrl;
@property (nonatomic, retain) NSString *giftImageUrl;
@property (nonatomic, retain) NSString *musicName;
@property (nonatomic, retain) NSString *receiverPhotoUrl;
@property (nonatomic, retain) NSString *receiverName;

@end
