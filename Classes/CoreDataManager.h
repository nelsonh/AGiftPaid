//
//  CoreDataManager.h
//  AGiftFree
//
//  Created by Nelson on 3/8/11.
//  Copyright 2011 ASquare LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FriendInfo;
@class GiftHistoryInfo;

@interface CoreDataManager : NSObject {

}

-(NSMutableArray*)retrieveFriendList;
-(BOOL)addNewFriend:(FriendInfo*)friendInfo;
-(BOOL)updateFriendInfo:(FriendInfo*)friendInfo;
-(BOOL)removeFriend:(NSString*)friendID;
-(BOOL)isFriendExisted:(NSString*)friendID;
-(BOOL)addGiftToHistory:(NSString*)giftID;
-(NSMutableArray*)retrieveGiftHistory;
-(BOOL)saveGiftHistory:(GiftHistoryInfo*)historyInfo;
-(BOOL)removeGiftHistoryWithGiftID:(NSString*)giftID;
@end
