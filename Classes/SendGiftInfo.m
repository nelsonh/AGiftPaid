//
//  SendGiftInfo.m
//  AGiftPaid
//
//  Created by Nelson on 3/25/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import "SendGiftInfo.h"


@implementation SendGiftInfo

@synthesize senderID;
@synthesize receiverID;
@synthesize anonymous;
@synthesize canOpenTime;
@synthesize giftBoxVideoID;
@synthesize giftVideoID;
@synthesize beforeMsg;
@synthesize afterMsg;
@synthesize giftPhotoFileName;
@synthesize giftPhoto64Encoding;
@synthesize giftDefMusicID;
@synthesize customMusicFileName;
@synthesize customMusic64Encoding;
@synthesize gift3DObjID;
@synthesize giftBox3DObjID;
@synthesize giftBoxImageUrl;
@synthesize giftImageUrl;
@synthesize musicName;
@synthesize receiverPhotoUrl;
@synthesize receiverName;

-(void)dealloc
{
	
	[senderID release];
	[receiverID release];
	[anonymous release];
	[canOpenTime release];
	[giftBoxVideoID release];
	[giftVideoID release];
	[beforeMsg release];
	[afterMsg release];
	[giftPhotoFileName release];
	[giftPhoto64Encoding release];
	[giftDefMusicID release];
	[customMusicFileName release];
	[customMusic64Encoding release];
	[gift3DObjID release];
	[giftBox3DObjID release];
	[giftBoxImageUrl release];
	[giftImageUrl release];
	[musicName release];
	[receiverPhotoUrl release];
	[receiverName release];
	
	[super dealloc];
}

@end
